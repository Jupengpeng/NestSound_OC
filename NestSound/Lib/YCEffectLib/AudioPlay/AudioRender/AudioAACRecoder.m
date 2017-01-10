
#import "AudioAACRecoder.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "faac.h"

#import "UluInternalProtocolDefine.h"

#import <UIKit/UIKit.h>

#if 0
//#define AAC_Recorder_Log(fmt, ...) NSLog((@"%@ " fmt), @"##AUDIO AAC_RECORD##", ##__VA_ARGS__)
#define AAC_Recorder_Log(fmt, ...) printf("##AUDIO AAC_RECORD## %s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#define AAC_Recorder_Log(...) {}
#endif

#define kNumberBuffers_szy  8
#define kBytesPerFrame 2
#define kFrameSize     1024 * kBytesPerFrame
#define kSamplingRate   8000
#define kNumberChannels 1
#define kBitsPerChannels  16

@interface  AudioAACRecoder()
{
    AudioQueueRef               _queue;
    AudioQueueBufferRef         _mBuffers[kNumberBuffers_szy];
    NSMutableData *_aacData;
    
    faacEncHandle               _faacEnc;
    unsigned long  _nInputSamples;
    unsigned long  _nMaxOutputBytes;
    BOOL           _isCancel;
    
    short          m_instantaueousAmplitude;
}

@end

@implementation AudioAACRecoder


static void AQInputCallback (void                   * inUserData,
                             AudioQueueRef          inAudioQueue,
                             AudioQueueBufferRef    inBuffer,
                             const AudioTimeStamp   * inStartTime,
                             UInt32          inNumPackets,
                             const AudioStreamPacketDescription * inPacketDesc)
{
    AAC_Recorder_Log(@"inNumPackets = %u",inNumPackets);
    AudioAACRecoder * engine = (__bridge AudioAACRecoder *) inUserData;
    
    
    if (!engine.isStop && inNumPackets == 0) {
        [engine processAudioQueueStop];
        return;
    }
    [engine processAudioBuffer:inBuffer withQueue:inAudioQueue];
    AudioQueueEnqueueBuffer(inAudioQueue, inBuffer, 0, NULL);
   
    //audio wave render
    if (nil != engine.audioWaveProtocol && [engine.audioWaveProtocol respondsToSelector:@selector(audioQueueBuffer:size:)]) {
        [engine.audioWaveProtocol audioQueueBuffer:inBuffer->mAudioData size:inBuffer->mAudioDataByteSize];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isStop = YES;
        
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
    }
    return self;
}


-(BOOL)aacEncInit
{
    if (_faacEnc) return NO;
    _faacEnc = faacEncOpen(kSamplingRate, kNumberChannels, &_nInputSamples, &_nMaxOutputBytes);
    if(_faacEnc == NULL)
    {
        printf("[ERROR] Failed to call faacEncOpen()\n");
        return NO;
    }
    printf("nInputSamples=%u\n", (unsigned int)_nInputSamples);
   
    faacEncConfigurationPtr pConfiguration = faacEncGetCurrentConfiguration(_faacEnc);
    pConfiguration->inputFormat = FAAC_INPUT_16BIT;
    pConfiguration->outputFormat = 1;
    pConfiguration->mpegVersion = MPEG4;
    pConfiguration->aacObjectType = LOW;
    pConfiguration->allowMidside = 0;
    pConfiguration->shortctl=SHORTCTL_NORMAL;
    pConfiguration->quantqual = 100;
    pConfiguration->useTns = 1;//1;
    pConfiguration->useLfe=0;
    pConfiguration->bitRate = 0;
    pConfiguration->bandWidth=0;

    return faacEncSetConfiguration(_faacEnc, pConfiguration);;
}

-(void)aacEncFree
{
    if (_faacEnc) {
        faacEncClose(_faacEnc);
        _faacEnc = NULL;
    }
}

-(BOOL)audioQueueStart
{
    [self audioQueueFree];
    OSStatus status;
    AudioStreamBasicDescription mDataFormat;
    mDataFormat.mSampleRate = kSamplingRate;
    mDataFormat.mFormatID = kAudioFormatLinearPCM;
    mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger |kLinearPCMFormatFlagIsPacked;
    mDataFormat.mFramesPerPacket = 1;
    mDataFormat.mChannelsPerFrame = kNumberChannels;
    mDataFormat.mBitsPerChannel = kBitsPerChannels;
    mDataFormat.mBytesPerPacket = 2;
    mDataFormat.mBytesPerFrame = kBytesPerFrame;
    
    //audio wave
    if (nil != _audioWaveProtocol && [_audioWaveProtocol respondsToSelector:@selector(setAudioFormat:)]) {
        [_audioWaveProtocol setAudioFormat:mDataFormat];
    }
    
    status = AudioQueueNewInput(&mDataFormat, (AudioQueueInputCallback)AQInputCallback, (__bridge void *)(self), NULL, kCFRunLoopCommonModes,0, &_queue);
    if (status != 0) {
        return NO;
    }
    for (int i=0;i<kNumberBuffers_szy;i++)
    {
        status =  AudioQueueAllocateBuffer(_queue, kFrameSize, &_mBuffers[i]);
        status =  AudioQueueEnqueueBuffer(_queue, _mBuffers[i], 0, NULL);
    }
    
    status = AudioQueueStart(_queue, NULL);
    
    if (status != 0) {
        return NO;
    }
    
    return YES;
}

-(BOOL)audioQueueFree
{
    if (_queue) {
        AudioQueueDispose(_queue, true);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {//iOS 10.0 early
            for (int i=0;i<kNumberBuffers_szy;i++)
            {
                AudioQueueFreeBuffer(_queue, _mBuffers[i]);
                
            }
        }
        _queue = NULL;
    }
    
    return YES;
}


-(BOOL)start
{
    
    if (![self aacEncInit]) return NO;
 
    _aacData = [NSMutableData new];
    
    if (![self audioQueueStart]) {
        [self  aacEncFree];
        return NO;
    }
    _isStop = NO;
    _isCancel =NO;
    return YES;
}
-(BOOL)stop
{
    AudioQueueStop(_queue, true);
    return YES;
}

-(BOOL)cancel
{
    _isCancel = YES;
    AudioQueueStop(_queue, true);
    return YES;
}

-(void)appendAACData:(const void *)bytes length:(NSUInteger)length
{
    if (_aacData.length + length > 128*1024) return;
    [_aacData appendBytes:bytes length:length];
}

- (void) processAudioQueueStop
{
    unsigned char buff[2048];
    int  bufflen;
    
    m_instantaueousAmplitude = 0;//reset
    
    while ((bufflen =faacEncEncode(_faacEnc, NULL, 0, buff, (UInt32)_nMaxOutputBytes))>0)
    {
        [self appendAACData:buff length:bufflen];
    }
    [self aacEncFree];
    
    if (_isCancel) {
        _aacData = nil;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRecoderComplete:aacData:)]) {
        [self.delegate onRecoderComplete:self aacData:_aacData];
    }
    
    _isStop = YES;
    AAC_Recorder_Log(@"processAudioQueueStop");
}

- (void) processAudioBuffer:(AudioQueueBufferRef) buffer withQueue:(AudioQueueRef) queue
{
    AAC_Recorder_Log(@"processAudio(unsigned int)Data :%d", buffer->mAudioDataByteSize);
    
    if (!_faacEnc) return;
    /*
     * iOS 10 mAudioDataByteSize 长度经常为 1000
    if (buffer->mAudioDataByteSize != _nInputSamples*2) return;
     */
    
    for (int i = 0; i < buffer->mAudioDataByteSize; i++) {//instaneous amplitude
        m_instantaueousAmplitude = ((short *)buffer->mAudioData)[i];
    }
    
    unsigned char buff[2048];
    
    int  bufflen =faacEncEncode(_faacEnc, (int*)buffer->mAudioData, buffer->mAudioDataByteSize/2, buff, (UInt32)_nMaxOutputBytes);
    
    [self appendAACData:buff length:bufflen];
}

-(short)getInstantaneousAmplitude{
    return m_instantaueousAmplitude;
}

- (void)dealloc
{
    [self audioQueueFree];
}
@end
