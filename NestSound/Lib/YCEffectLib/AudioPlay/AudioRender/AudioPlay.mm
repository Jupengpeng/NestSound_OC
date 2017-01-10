
#import "AudioPlay.h"
#import <AVFoundation/AVFoundation.h>
#import "ReceiveStreamingData.h"
//#import "RecordAVPacketDataBlock.h"
//#import <AVFoundation/AVAudioSession.h>

#if 0
//#define Audio_Play_Log(fmt, ...) NSLog((@"%@ " fmt), @"##AUDIO PLAY##", ##__VA_ARGS__)
#define Audio_Play_Log(fmt, ...) printf("##AUDIO PLAY## %s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#define Audio_Play_Log(...) {}
#endif

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"a.caf"]


@implementation AudioPlay


static void BufferCallback(void *inUserData,AudioQueueRef inAQ, AudioQueueBufferRef buffer)
{
        //printf("\n\n\nBufferCallback-----getAudioData\n");
   // ISLog(@"*****in buffer call Back*******");
    AudioPlay* player=( AudioPlay*)inUserData;
    [player audioQueueOutputWithQueue:inAQ queueBuffer:buffer];
}


    //缓存数据读取方法的实现
-(void) audioQueueOutputWithQueue:(AudioQueueRef)audioQueue queueBuffer:(AudioQueueBufferRef)audioQueueBuffer
{
        //读取包数据
    UInt32 numBytes;
        //    UInt32 numPackets=numPacketsToRead;
    UInt32 numPackets ;
    
        //成功读取时
//    NSMutableData   *data=[[NSMutableData alloc] init];
    [[ReceiveStreamingData  getInstance] getAudioData:dataBuffer senderid:playID PlayCount:&playCount];
//    [[RecordAVPacketDataBlock shareInstance] getAudioData:dataBuffer senderid:playID PlayCount:&playCount];
        //[[blockPacket    instance] getAudioData:data :playID playCount:&playCount];
    numBytes=(UInt32)dataBuffer.length;
    Audio_Play_Log(@"numBytes = %i", (unsigned int)numBytes);
    aqData.mNumPacketsToRead=(UInt32)dataBuffer.length/2;
    numPackets= aqData.mNumPacketsToRead;
        //numBytes=fread(inbuf, 1, numPackets*4,wavFile);
    AudioQueueBufferRef outBufferRef=audioQueueBuffer;
        //NSData *aData=[[NSData alloc]initWithBytes:inbuf length:numBytes];
    
    if(numBytes>0){
       // ISLog(@"numBytes>0");
        memcpy(outBufferRef->mAudioData, dataBuffer.bytes, dataBuffer.length);
        
        outBufferRef->mAudioDataByteSize=numBytes;
        AudioQueueEnqueueBufferWithParameters(audioQueue, outBufferRef, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL);
            // AudioQueueEnqueueBuffer(audioQueue, outBufferRef, 0, nil);
        aqData.mCurrentPacket += numPackets;
    }
    else{
        //ISLog(@"numBytes<=0");
        AudioQueueStop (audioQueue, false);
        aqData.mIsRunning = false;
        
    }
    
//    static int count = 0;
//    count ++;
//    if(count > 30){
//        CZH_Log(@" get audio data playID = %li, data length = %i\n\n\n", playID, [data length]);
//        count = 0;
//    }
    [dataBuffer resetBytesInRange:NSMakeRange(0, [dataBuffer length])];
    [dataBuffer setLength:0];
//    [data   dealloc];
}







#if 0
static void HandleOutputBuffer (void *aqData,AudioQueueRef inAQ,AudioQueueBufferRef inBuffer) 
{
    AQPlayerState *pAqData = (AQPlayerState *) aqData;  
    if (pAqData->mIsRunning == 0) 
    {
        ISLog(@"play back");
        return;
    }      
    UInt32 numBytesReadFromFile;        
    UInt32 numPackets; //= pAqData->mNumPacketsToRead;  
    NSMutableData *audioPlay = [[NSMutableData alloc]init];
    
    int dataLength = [[blockPacket instance] getAudioData:audioPlay];
        //printf("running\n");
    numBytesReadFromFile = audioPlay.length;
    //    memset(audioD, 0, 1000);
    memcpy((char *)inBuffer->mAudioData, (char *)[audioPlay bytes], audioPlay.length);
    pAqData->mNumPacketsToRead = audioPlay.length / 2;
    numPackets = pAqData->mNumPacketsToRead; 
    [audioPlay release];
    
    //ISLog(@"*** %d ***numBytesReadFromFile %lu  the mNumPakets is %lu mCurrent %lld", dataLength, numBytesReadFromFile, pAqData->mNumPacketsToRead, pAqData->mCurrentPacket);
    if (numPackets > 0) 
    {      
        inBuffer->mAudioDataByteSize = numBytesReadFromFile; 
        AudioQueueEnqueueBuffer ( 
                                 pAqData->mQueue,
                                 inBuffer,
                                 0,
                                 pAqData->mPacketDescs
                                 );
//            struct AudioTimeStamp reternTimeStamp;
//            AudioQueueEnqueueBufferWithParameters(pAqData->mQueue, inBuffer, 0, pAqData->mPacketDescs, 0, 0, 0, NULL, &reternTimeStamp, NULL);
            //AudioQueueEnqueueBufferWithParameters(<#AudioQueueRef inAQ#>, <#AudioQueueBufferRef inBuffer#>, <#UInt32 inNumPacketDescs#>, <#const AudioStreamPacketDescription *inPacketDescs#>, <#UInt32 inTrimFramesAtStart#>, <#UInt32 inTrimFramesAtEnd#>, <#UInt32 inNumParamValues#>, <#const AudioQueueParameterEvent *inParamValues#>, <#const AudioTimeStamp *inStartTime#>, <#AudioTimeStamp *outActualStartTime#>)
            //AudioQueueEnqueueBuffer(<#AudioQueueRef inAQ#>, <#AudioQueueBufferRef inBuffer#>, <#UInt32 inNumPacketDescs#>, <#const AudioStreamPacketDescription *inPacketDescs#>)
        
        
        pAqData->mCurrentPacket += numPackets;    
    } 
    else 
    {
        AudioQueueStop (pAqData->mQueue, false);
        pAqData->mIsRunning = false; 
    }
}
#endif


    //static AudioPlay* audioPlay;
//+(AudioPlay *)Instance
//{
//    if(audioPlay == nil)
//    {
//        audioPlay = [[AudioPlay alloc]init];
//    }
//    return  audioPlay;
//}
//
//+ (void)FreeAudioPlay
//{
//    SLog(@"FreeAudioPlay");
//    if(audioPlay)
//        [audioPlay release];
//    audioPlay = nil;
//}

- (id)init
{
    self = [super init];
    if(self)
    {
        Audio_Play_Log(@"AudioPlay init");
        playCount = 0;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) DeriveBufferSize:(AudioStreamBasicDescription *)ASBDesc PacketSize:(UInt32) maxPacketSize Second:(Float64)seconds OutBufSize:(UInt32*)outBufferSize OutNumPack:(UInt32*)outNumPacketsToRead
{
    static const int maxBufferSize = 0x10000; 
    static const int minBufferSize = 0x4000; 
    
    if (ASBDesc->mFramesPerPacket != 0) 
    {    
        Float64 numPacketsForTime =
        ASBDesc->mSampleRate / ASBDesc->mFramesPerPacket * seconds;
        *outBufferSize = numPacketsForTime * maxPacketSize;
    } 
    else 
    {  
        *outBufferSize = maxBufferSize > maxPacketSize ? maxBufferSize : maxPacketSize;
    }
    
    if ( 
        *outBufferSize > maxBufferSize &&
        *outBufferSize > maxPacketSize
        )
        *outBufferSize = maxBufferSize;
    else 
    { 
        if (*outBufferSize < minBufferSize)
            *outBufferSize = minBufferSize;
    }
    
    *outNumPacketsToRead = *outBufferSize / maxPacketSize; 
}

-(void)setAudioPlayFormat:(AudioFormat)format{
    m_audioPlayFormat.mSampleRate = format.mSampleRate;
    m_audioPlayFormat.mChannelsPerFrame = format.mChannelsPerFrame;
    m_audioPlayFormat.mBitsPerChannel = format.mBitsPerChannel;
}

-(void) SetPlayAudio:(AudioFormat)format
{
    //    AQRecorderState aqData;
    Audio_Play_Log(@"set audio player sample rate = %f", format.mSampleRate);
    Audio_Play_Log(@"set audio player channels = %d", (unsigned int)format.mChannelsPerFrame);
    Audio_Play_Log(@"set audio player mBitsPerChannel = %d", (unsigned int)format.mBitsPerChannel);
//    NSLog(@"aqData %@",aqData);
    aqData.mDataFormat.mFormatID         = kAudioFormatLinearPCM;
    aqData.mDataFormat.mSampleRate       = format.mSampleRate;   //  mSampleRate
    aqData.mDataFormat.mChannelsPerFrame = format.mChannelsPerFrame;
    aqData.mDataFormat.mBitsPerChannel   = format.mBitsPerChannel;
    aqData.mDataFormat.mBytesPerPacket   = 
    aqData.mDataFormat.mBytesPerFrame    = aqData.mDataFormat.mChannelsPerFrame * sizeof (SInt16);
    aqData.mDataFormat.mFramesPerPacket  = 1; 
    
    aqData.mDataFormat.mFormatFlags      =  
    kLinearPCMFormatFlagIsBigEndian
    | kLinearPCMFormatFlagIsSignedInteger
    | kLinearPCMFormatFlagIsPacked;
    
    
//    aqData.mDataFormat.mSampleRate = 8000.0;
//	aqData.mDataFormat.mFormatID = kAudioFormatLinearPCM;
//	aqData.mDataFormat.mFramesPerPacket = 1;
//	aqData.mDataFormat.mChannelsPerFrame = 1;
//	aqData.mDataFormat.mBytesPerFrame = 2;
//	aqData.mDataFormat.mBytesPerPacket = 2;
//	aqData.mDataFormat.mBitsPerChannel = 16;
//	aqData.mDataFormat.mReserved = 0;
//	aqData.mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsBigEndian     |
//    kLinearPCMFormatFlagIsSignedInteger |
//    kLinearPCMFormatFlagIsPacked;
    
}

-(void)StartPlay
{
    Audio_Play_Log(@"-------Audio StartPlay---------");
    dataBuffer = [[NSMutableData alloc] init];//added by czh 14-01-07
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    
    
//    NSError *myErr;
//    BOOL    bAudioInputAvailable = FALSE;
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    bAudioInputAvailable = [audioSession inputIsAvailable];
//    
//    if (bAudioInputAvailable)
//    {
//        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&myErr];
//    }
//    else
//    {
//        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&myErr];
//    }

    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    
    
//    [self LoudSpeaker:true];
    //    CFURLRef fileURL =  CFURLCreateFromFileSystemRepresentation(NULL, (const UInt8 *) [FILEPATH UTF8String], [FILEPATH  length], NO);
    //    AudioFileOpenURL(fileURL, kAudioFileReadPermission, 0/*inFileTypeHint*/, &aqData.mAudioFile);
    //	CFRelease(fileURL);
    
//    UInt32 dataFormatSize = sizeof (aqData.mDataFormat);
    
    [self SetPlayAudio:m_audioPlayFormat];//8000.0
    
    AudioQueueNewOutput (
                         &aqData.mDataFormat, 
                         BufferCallback,   
                         self,
                         CFRunLoopGetCurrent (), 
                         kCFRunLoopCommonModes,  
                         0, 
                         &aqData.mQueue 
                         );
//    UInt32 maxPacketSize;
//    UInt32 propertySize = sizeof (maxPacketSize);
    //    AudioFileGetProperty (aqData.mAudioFile, kAudioFilePropertyPacketSizeUpperBound, &propertySize, &maxPacketSize);
    
    [self DeriveBufferSize:&aqData.mDataFormat PacketSize:2 Second:(0.06*AUDIOFORPLAY) OutBufSize:&aqData.bufferByteSize OutNumPack:&aqData.mNumPacketsToRead];   
    Audio_Play_Log(@"max packetSize %u playback mNumPacketsToRead %u",(unsigned int)aqData.bufferByteSize, (unsigned int)aqData.mNumPacketsToRead);
    
    
    aqData.mCurrentPacket = 0;
    aqData.mIsRunning = true;
    for (int i = 0; i < kNumberReaBuffers; ++i) 
    {     
        AudioQueueAllocateBuffer (aqData.mQueue, aqData.bufferByteSize, &aqData.mBuffers[i]);
        
        BufferCallback(self, aqData.mQueue, aqData.mBuffers[i]);
    }
    
    NSLog(@"%",aqData);
    Float32 gain = 1.0;  
    // Optionally, allow user to override gain setting here
    AudioQueueSetParameter (aqData.mQueue, kAudioQueueParam_Volume, gain);
    
    AudioQueueStart (aqData.mQueue, NULL);
        //AudioQueueEnqueueBufferWithParameters(<#AudioQueueRef inAQ#>, <#AudioQueueBufferRef inBuffer#>, <#UInt32 inNumPacketDescs#>, <#const AudioStreamPacketDescription *inPacketDescs#>, <#UInt32 inTrimFramesAtStart#>, <#UInt32 inTrimFramesAtEnd#>, <#UInt32 inNumParamValues#>, <#const AudioQueueParameterEvent *inParamValues#>, <#const AudioTimeStamp *inStartTime#>, <#UInt32 inNumPacketDescs#><#AudioTimeStamp *outActualStartTime#>)
        //AudioQueueEnqueueBuffer(<#AudioQueueRef inAQ#>, <#AudioQueueBufferRef inBuffer#>, , <#const AudioStreamPacketDescription *inPacketDescs#>)
    
}

-(BOOL) SetVolume:(Float32) Volume
{
    PRINT_FUNCTION_NAME;
    OSStatus status = AudioQueueSetParameter(aqData.mQueue, kAudioQueueParam_Volume, Volume);
    Audio_Play_Log(@"set audio volume(%f.2) status = %d", Volume, status);
    
    if (0 == status) {
        return true;
    }
    return false;
    
//    Float32 gain;
//    AudioQueueGetParameter(aqData.mQueue, kAudioQueueParam_Volume, &gain);
//    if( gain == 1.0)
//    {
//        gain = 0.0;
//        AudioQueueSetParameter(aqData.mQueue, kAudioQueueParam_Volume, gain);
//        return NO;
//    }
//    else
//    {
//        gain = 1.0;
//        AudioQueueSetParameter(aqData.mQueue, kAudioQueueParam_Volume, gain);
//        return YES;
//    }
}

-(bool) LoudSpeaker:(bool)bOpen
{
    //return false;
    UInt32 route;
    OSStatus error;    
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord; 
    
    error = AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,                       
                                     sizeof (sessionCategory),                                  
                                     &sessionCategory                                           
                                     );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    error = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    //[blockPacket instance].loudSpeaker = bOpen;
    return true;
}



-(void) StopPlay
{ 
    AudioQueueStop(aqData.mQueue, true);
    AudioQueueDispose (aqData.mQueue, true); 
    free (aqData.mPacketDescs);
    [dataBuffer release];//added by czh 14-01-07
    dataBuffer = nil;//added by czh 14-01-07
//   [[AudioCodec Instance] FreeDecode];
//    [audioPlay release];
//    audioPlay = nil;
}

-(void)SetPlayID:(int)audioPlayID
{
    playID = audioPlayID;
}


@end
