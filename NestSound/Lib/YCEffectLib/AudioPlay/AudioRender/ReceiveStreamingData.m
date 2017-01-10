
#import "ReceiveStreamingData.h"
#import "receive_ff_data_callbacks.h"

#if 0
//#define RECV_STREAMING_Log(fmt, ...) NSLog((@"%@ " fmt), @"##RECV STREAMING##", ##__VA_ARGS__)
#define RECV_STREAMING_Log(fmt, ...) printf("##RECV STREAMING## %s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#define RECV_STREAMING_Log(...) {}
#endif

static ReceiveStreamingData    *shareReceiveStreamingData = nil;


@implementation ReceiveStreamingData

+(ReceiveStreamingData *)getInstance{
    @synchronized(self){
        if(nil == shareReceiveStreamingData){
            shareReceiveStreamingData = [[[self alloc] init] autorelease];
            shareReceiveStreamingData->isinitFinish = FALSE;
            [shareReceiveStreamingData initData];
        }
    }
    return shareReceiveStreamingData;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (nil == shareReceiveStreamingData) {
            shareReceiveStreamingData = [super allocWithZone:zone];
            return  shareReceiveStreamingData;
        }
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

//-(id)retain{
//
//    return self;
//
//}

-(NSUInteger)retainCount{
    
    return NSUIntegerMax;
    
}


-(id)autorelease{
    
    return self;
    
}

-(void)setAudioFormat:(AudioFormat)format{
    if (0 == format.mSampleRate || 0 == format.mChannelsPerFrame || 0 == format.mBitsPerChannel) {
        m_audioFormat.mSampleRate = 8000;
        m_audioFormat.mChannelsPerFrame = 1;
        m_audioFormat.mBitsPerChannel = 16;
    }else{
        m_audioFormat.mSampleRate = format.mSampleRate;
        m_audioFormat.mChannelsPerFrame = format.mChannelsPerFrame;
        m_audioFormat.mBitsPerChannel = format.mBitsPerChannel;
    }
}


int receive_video_streaming_data(unsigned char *buffer, int length){
    RECV_STREAMING_Log(@"receive video streaming data. length = %i", length);
    NSMutableData *one_fame_video_data = [[NSMutableData alloc] initWithBytes:buffer length:length];
    [shareReceiveStreamingData addVideoPacketToQueue:one_fame_video_data];
    [one_fame_video_data    release];
    return 1;
}

int receive_audio_streaming_data(unsigned char *buffer, int length){
    RECV_STREAMING_Log(@"receive audio streaming data. length = %i", length);
    NSMutableData *one_fame_audio_data = [[NSMutableData alloc] initWithBytes:buffer length:length];
    [shareReceiveStreamingData addAudioPacketToQueue:one_fame_audio_data];
    [one_fame_audio_data    release];
    return 1;
}

-(void)initData{//得用主线程来启动
    if(isinitFinish)return;
    
    RECV_STREAMING_Log(@"ReceiveStreamingData initData ......");
    
    isinitFinish = TRUE;
    _isPlaying = FALSE;
    
    m_hasDataReceived = FALSE;
    
    m_videoQueueMutableArray = [[NSMutableArray alloc] init];
    m_audioQueueMutableArray = [[NSMutableArray alloc]  init];
    
    pthread_mutex_init(&rw_audio_data_mutex, NULL);
    
    m_readWriteVideoDataLock = [[NSCondition    alloc]  init];
    
    m_auidoPlayedBitCount = 0;
    
//    mutiAudioPlayControl = [[MutiAudioPlay   alloc] init];//add by czh
//    mutiAudioPlayCount = 0;
//    [mutiAudioPlayControl   AddNode:mutiAudioPlayCount];
//    mutiAudioPlayCount++;
//    [mutiAudioPlayControl   AddNode:mutiAudioPlayCount];
//    mutiAudioPlayCount++;
    
//    dispatch_async ( dispatch_get_global_queue ( DISPATCH_QUEUE_PRIORITY_DEFAULT , 0 ), ^{
//        //Fire api
//        while(1){
//            sleep(2);
//            if([self hasAudioData]){
//                [mutiAudioPlayControl   AddNode:mutiAudioPlayCount];
//                break;
//            }
//        }
//        
//    });
}

-(void)startPlay{
    if(_isPlaying)return;
    _isPlaying = TRUE;
    mutiAudioPlayControl = [[MutiAudioPlay   alloc] init];//add by czh
    [mutiAudioPlayControl setAudioFormat:m_audioFormat];
    mutiAudioPlayCount = 0;
    [mutiAudioPlayControl   AddNode:mutiAudioPlayCount];
}

-(BOOL)setAudioVolume:(Float32)volume{
    return [mutiAudioPlayControl setVolume:volume];
}

-(void)releaseData{
    [mutiAudioPlayControl release];
    mutiAudioPlayControl = nil;
    
    pthread_mutex_destroy(&rw_audio_data_mutex);
    
    [m_readWriteVideoDataLock release];
    m_readWriteVideoDataLock = nil;
    
    [m_videoQueueMutableArray removeAllObjects];
    [m_videoQueueMutableArray   release];
    [m_audioQueueMutableArray   removeAllObjects];
    [m_audioQueueMutableArray   release];
    
    isinitFinish = FALSE;
}

-(void)dealloc{
    RECV_STREAMING_Log(@"ReceiveStreamingData dealloc......");
    [self   releaseData];
    [super  dealloc];
}

-(void)addAudioPacketToQueue:(NSMutableData *)audioPacket{
    RECV_STREAMING_Log(@"add one frame audio packet to audio queue.....");
    m_hasDataReceived = TRUE;
    pthread_mutex_lock(&rw_audio_data_mutex);
    if([m_audioQueueMutableArray count] > 2000){
        RECV_STREAMING_Log(@"romove audio packet range of 0 to 30 in m_audioQueueMutableArray!");
        [m_audioQueueMutableArray   removeObjectsInRange:NSMakeRange(0, 30)];
    }
    
    NSMutableData *topPacket = [m_audioQueueMutableArray lastObject];
    if (nil != topPacket && [topPacket length] <= 682) {
        [topPacket appendData:audioPacket];
    } else {
        [m_audioQueueMutableArray   addObject:audioPacket];
    }
    
    pthread_mutex_unlock(&rw_audio_data_mutex);

}

-(void)addVideoPacketToQueue:(NSMutableData *)videoPacket{
    RECV_STREAMING_Log(@"add one frame video packet to video queue.....");
    m_hasDataReceived = TRUE;
     [m_readWriteVideoDataLock lock];
    if([m_videoQueueMutableArray    count] > 50){
        RECV_STREAMING_Log(@"romove video packet range of 0 to 20 in m_videoQueueMutableArray!");
        [m_videoQueueMutableArray   removeObjectsInRange:NSMakeRange(0, 20)];
    }
    [m_videoQueueMutableArray   addObject:videoPacket];
    [m_readWriteVideoDataLock   unlock];
}

-(int)getAudioData:(NSMutableData *)data senderid:(int)playID PlayCount:(int *)playCount
{

    RECV_STREAMING_Log(@"audio packet count:%i", [m_audioQueueMutableArray    count]);
    
    bzero(m_decodeAudio, AUDIOPACKET/2);
    
    if(m_auidoPlayedBitCount > 682/* AUDIOPACKET/6 */  || *playCount >= 30)
    {
        RECV_STREAMING_Log(@"getAudioData:remove range of 0 to 30 in m_audioQueueMutableArray");
        pthread_mutex_lock(&rw_audio_data_mutex);
        if ([m_audioQueueMutableArray count] >= *playCount) {
            [m_audioQueueMutableArray removeObjectsInRange:NSMakeRange(0, *playCount)];
        } else {
            [m_audioQueueMutableArray removeAllObjects];
        }
        pthread_mutex_unlock(&rw_audio_data_mutex);
        *playCount = 0;
        m_auidoPlayedBitCount = 0;
    }
    
    
    pthread_mutex_lock(&rw_audio_data_mutex);
    if((int)([m_audioQueueMutableArray count] - *playCount) > 0 && [[m_audioQueueMutableArray objectAtIndex:*playCount] length] > 682)
    {
        int readAudioLength = (int)[[m_audioQueueMutableArray objectAtIndex:*playCount] length];
        memcpy(m_decodeAudio, (char *)[[m_audioQueueMutableArray objectAtIndex:*playCount] bytes], readAudioLength);
        (*playCount)++;
        
        RECV_STREAMING_Log(@"*playCount = %d", *playCount);
        
        for (int i=0; i<readAudioLength/2; i++)
        {
            m_decodeAudio[i] = ((m_decodeAudio[i] & 0x00ff) << 8) | ((m_decodeAudio[i] & 0xff00) >> 8);
        }
        
        [data appendBytes:m_decodeAudio length:readAudioLength];
        
        m_auidoPlayedBitCount += readAudioLength;
        RECV_STREAMING_Log(@"readAudioLength = %i, playCount = %i", readAudioLength, *playCount);
        
    }else{
        RECV_STREAMING_Log(@"************have no audio packet**************");
        memset(m_decodeAudio, 0, AUDIOPACKET/6);
        [data appendBytes:m_decodeAudio length:AUDIOPACKET/6];
        
    }
    pthread_mutex_unlock(&rw_audio_data_mutex);

    return 1;
}

-(int)getVideoData:(NSMutableData *)data{
    if([m_videoQueueMutableArray count] == 0)return 0;
    [m_readWriteVideoDataLock lock];
    NSMutableData *video_frame_data = [m_videoQueueMutableArray    objectAtIndex:0];
    
    [data appendBytes:[video_frame_data bytes] length:[video_frame_data length]];
    
    [m_videoQueueMutableArray   removeObjectAtIndex:0];
    [m_readWriteVideoDataLock   unlock];
    
    return 1;
}

-(BOOL)hasAudioData{
    pthread_mutex_lock(&rw_audio_data_mutex);
    NSInteger audioQueueSize = [m_audioQueueMutableArray count];
    pthread_mutex_unlock(&rw_audio_data_mutex);
    if(audioQueueSize > 0){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(int)getAudioQueueSize{
    pthread_mutex_lock(&rw_audio_data_mutex);
    int audio_queue_size = (int)[m_audioQueueMutableArray count];
    pthread_mutex_unlock(&rw_audio_data_mutex);
    return audio_queue_size;
}

-(void)stopPlay{
    [mutiAudioPlayControl Stop];
    [self releaseData];
    _isPlaying = FALSE;
}
    
-(void)resetReceiveDataState{
    m_hasDataReceived = FALSE;
}

-(BOOL)getReceiveDataState{
    if(m_hasDataReceived)
        return TRUE;
    else
        return FALSE;
}

-(void)clearStreamingDataQueue{
    RECV_STREAMING_Log(@"clear streaming data queue ......");
    [m_readWriteVideoDataLock   lock];
    if([m_videoQueueMutableArray    count] > 0){
        [m_videoQueueMutableArray   removeAllObjects];
    }
    [m_readWriteVideoDataLock   unlock];
    

    pthread_mutex_lock(&rw_audio_data_mutex);
    if([m_audioQueueMutableArray    count] > 0){
        [m_audioQueueMutableArray   removeAllObjects];
    }
    pthread_mutex_unlock(&rw_audio_data_mutex);

}

+(void)freeInstance{
    if(nil != shareReceiveStreamingData){
        [shareReceiveStreamingData stopPlay];
    }
    shareReceiveStreamingData = nil;
}

@end
