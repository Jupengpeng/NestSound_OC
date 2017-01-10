
#import <AVFoundation/AVAudioSession.h>
#import "AudioRecord.h"
#import "RecordAVPacketDataBlock.h"

//#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define DOCUMENTS_FOLDER @"/Users/czhui/Desktop/"
#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"a.caf"]

#define AUDIO_RECORD 0

#if AUDIO_RECORD
//#define AUDIO_RECORD_Log(fmt, ...) NSLog((@"%@ " fmt), @"##AUDIO RECORD##", ##__VA_ARGS__)
#define AUDIO_RECORD_Log(fmt, ...) printf("##AUDIO RECORD## %s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#define AUDIO_RECORD_Log(...) {}
#endif

@implementation UAudioRecord
static UAudioRecord *audioRecord;


static void HandleInputBuffer (
                               void                                 *aqData,
                               AudioQueueRef                        inAQ,
                               AudioQueueBufferRef                  inBuffer,
                               const AudioTimeStamp                 *inStartTime,
                               UInt32                               inNumPackets,
                               const AudioStreamPacketDescription   *inPacketDesc
                               ) 
{
    AQRecorderState *pAqData = (AQRecorderState *) aqData;
    if (inNumPackets == 0 &&  pAqData->mDataFormat.mBytesPerPacket != 0)
        
        inNumPackets = inBuffer->mAudioDataByteSize / pAqData->mDataFormat.mBytesPerPacket;
    
    short outData[RECORD_AUDIO_PACKET_SIZE/2];
    bzero(outData, RECORD_AUDIO_PACKET_SIZE);
    if((![[UAudioRecord Instance] GetMicState]))
    {
        memcpy(outData, inBuffer->mAudioData, inBuffer->mAudioDataByteSize);
        AUDIO_RECORD_Log(@"-****cap audio len:%d", inBuffer->mAudioDataByteSize);
        
        //            int isPA = 0;
        for (int i =0; i< RECORD_AUDIO_PACKET_SIZE/2; i++)
        {
            //                double pdB = (double)outData[i] / 32768.0;
            //                pdB = 20.0 * log10(fabs(pdB));
            //                if(pdB > -45.0)
            //                    isPA ++;
            outData[i] = ((outData[i] & 0x00ff) << 8) | ((outData[i] & 0xff00) >> 8);
            
        }
        //printf("delecount = %i\n", delecount);
        //            if(isPA < AUDIOPACKET/6)
        //            {
        //                bzero(outData, AUDIOPACKET);
        //            }
    }
    
    /*
    if (AudioFileWritePackets (
     pAqData->mAudioFile,
     false,
     inBuffer->mAudioDataByteSize,
     inPacketDesc,
     pAqData->mCurrentPacket,
     &inNumPackets,
     outData
     ) == noErr)
    
    {
        pAqData->mCurrentPacket += inNumPackets; 
    }
    */

    if (pAqData->mIsRunning == 0) 
        return;
    
//    [[blockPacket instance]AudioOutputData:outData length:AUDIOPACKET];
    [[RecordAVPacketDataBlock shareInstance] addRecordAudioPacketToQueue:(unsigned char *)outData length:RECORD_AUDIO_PACKET_SIZE];
    AudioQueueEnqueueBuffer (pAqData->mQueue, inBuffer, 0, NULL);
}


+(UAudioRecord *)Instance
{
    if(audioRecord == nil){
        audioRecord = [UAudioRecord alloc];
    }
    return audioRecord;
}

+ (void)FreeAudioRecord
{
    AUDIO_RECORD_Log(@"FreeAudioRecord");
    if(audioRecord)
        [audioRecord release];
    audioRecord = nil;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        AUDIO_RECORD_Log(@"audioRecord init");
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) DeriveBufferSize:(AudioQueueRef) audioQueue audioDescription:(AudioStreamBasicDescription  *)ASBDescription second:(Float64) seconds outBufSize:(UInt32 *)outBufferSize
{
    static const int maxBufferSize = 0x5000;      
    
    int maxPacketSize = ASBDescription->mBytesPerPacket; 
    if (maxPacketSize == 0) 
    {  
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        
        AudioQueueGetProperty (
                               audioQueue,
                               kAudioQueueProperty_MaximumOutputPacketSize,
                               &maxPacketSize,
                               &maxVBRPacketSize
                               );
    }
    
    Float64 numBytesForTime = ASBDescription->mSampleRate * maxPacketSize * seconds; 
    *outBufferSize = UInt32 (numBytesForTime < maxBufferSize ? numBytesForTime : maxBufferSize);             
}

-(OSStatus) SetMagicCookieForFile:(AudioQueueRef) inQueue aFileID:(AudioFileID) inFile //本地使用
{
    OSStatus result = noErr;          
    UInt32 cookieSize;      
    
    if (AudioQueueGetPropertySize (inQueue, kAudioQueueProperty_MagicCookie, &cookieSize ) == noErr) {
        char* magicCookie = (char *) malloc (cookieSize);   
        
        if (
            AudioQueueGetProperty (                   
                                   inQueue,
                                   kAudioQueueProperty_MagicCookie,
                                   magicCookie,
                                   &cookieSize
                                   ) == noErr
            )
            result =  AudioFileSetProperty (   
                                            inFile,
                                            kAudioFilePropertyMagicCookieData,
                                            cookieSize,
                                            magicCookie
                                            );
        free (magicCookie);                                 
    }
    return result;         
}

-(void) SetRecordAudio:(float)mSampleRate
{
    //    AQRecorderState aqData;                                      
    
    aqData.mDataFormat.mFormatID         = kAudioFormatLinearPCM; 
    aqData.mDataFormat.mSampleRate       = mSampleRate;   //  mSampleRate
    aqData.mDataFormat.mChannelsPerFrame = 1;                    
    aqData.mDataFormat.mBitsPerChannel   = 16;                   
    aqData.mDataFormat.mBytesPerPacket   =  
    aqData.mDataFormat.mBytesPerFrame    = aqData.mDataFormat.mChannelsPerFrame * sizeof (SInt16);
    aqData.mDataFormat.mFramesPerPacket  = 1; 
    aqData.mDataFormat.mFormatFlags      = 1;
    //    AudioFileTypeID fileType             = kAudioFileAIFFType;
    aqData.mDataFormat.mFormatFlags      =  
    kLinearPCMFormatFlagIsBigEndian
    | kLinearPCMFormatFlagIsSignedInteger
    | kLinearPCMFormatFlagIsPacked;
}

-(void) StartRecord
{
    AUDIO_RECORD_Log(@"-----StartRecord------");
    BOOL havMicPho = [self hasMicphone];
    if(!havMicPho)
        return;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    
    micOff = NO;
    [self SetRecordAudio:8000.0];
    AudioQueueNewInput (&aqData.mDataFormat, 
                        HandleInputBuffer, 
                        &aqData,
                        NULL, 
                        kCFRunLoopCommonModes, 
                        0,  
                        &aqData.mQueue 
                        );
    
    UInt32 dataFormatSize = sizeof (aqData.mDataFormat);
    AudioQueueGetProperty (aqData.mQueue,
                           kAudioQueueProperty_StreamDescription, 
                           &aqData.mDataFormat, 
                           &dataFormatSize 
                           );
    
    
        [self SetMagicCookieForFile:aqData.mQueue aFileID:aqData.mAudioFile];
    [self DeriveBufferSize:aqData.mQueue audioDescription:&aqData.mDataFormat second:0.08 outBufSize:&aqData.bufferByteSize];
    
    CFURLRef fileURL =  CFURLCreateFromFileSystemRepresentation(NULL, (const UInt8 *) [FILEPATH UTF8String], [FILEPATH length], NO);
    AudioFileCreateWithURL(fileURL, kAudioFileAIFFType, &aqData.mDataFormat, kAudioFileFlags_EraseFile, &aqData.mAudioFile);
    
    AUDIO_RECORD_Log(@"outbufSize %u",(unsigned int)aqData.bufferByteSize);
    for (int i = 0; i < kNumberBuffers; ++i) 
    {

        AudioQueueAllocateBuffer (aqData.mQueue, aqData.bufferByteSize, &aqData.mBuffers[i]);
        AudioQueueEnqueueBuffer (aqData.mQueue, aqData.mBuffers[i], 0, NULL);
    }
    
    aqData.mCurrentPacket = 0; 
    aqData.mIsRunning = true;
    AUDIO_RECORD_Log(@"start record");
    AudioQueueStart (aqData.mQueue, NULL);
    
}

- (BOOL)hasMicphone 
{
    return [[AVAudioSession sharedInstance] inputIsAvailable];
}


-(void) StopRecord
{
//    AudioQueueStop (aqData.mQueue, true);
    aqData.mIsRunning = false; 
//    [[AudioCodec Instance] FreeCode];
//    AudioQueueDispose (aqData.mQueue, true);
//    [audioRecord release];
//    audioRecord = nil;

}

- (BOOL) GetMicState
{
    return micOff;
}

- (BOOL) SetMicState
{
    if(micOff)
        micOff = NO;
    else
        micOff = YES;
    
    return micOff;
}


@end
