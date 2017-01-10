

#import <Foundation/Foundation.h>
#import "AVComType.h"
#import "MutiAudioPlay.h"
#include <pthread.h>

@interface ReceiveStreamingData : NSObject{
    BOOL                        isinitFinish;

    NSMutableArray              *m_videoQueueMutableArray;
    NSMutableArray              *m_audioQueueMutableArray;
    
    short                       m_decodeAudio[AUDIOPACKET/2];//audio play data
    MutiAudioPlay               *mutiAudioPlayControl;
    unsigned short int          mutiAudioPlayCount;
    
    pthread_mutex_t             rw_audio_data_mutex;//pthread_mutex_t 要比 NSLock 更实时
    
    NSCondition                 *m_readWriteVideoDataLock;
    BOOL                        m_hasDataReceived;
    AudioFormat                 m_audioFormat;
    unsigned int                m_auidoPlayedBitCount;
}

@property (nonatomic, readonly)BOOL isPlaying;

+(ReceiveStreamingData *)getInstance;
-(void)setAudioFormat:(AudioFormat)format;
-(void)startPlay;
-(BOOL)setAudioVolume:(Float32)volume;
-(void)addAudioPacketToQueue:(NSMutableData *)audioPacket;
-(void)addVideoPacketToQueue:(NSMutableData *)videoPacket;
-(int)getAudioData:(NSMutableData *)data senderid:(int)playID PlayCount:(int *)playCount;
-(int)getVideoData:(NSMutableData *)data;
-(BOOL)hasAudioData;
-(int)getAudioQueueSize;
-(void)stopPlay;
-(void)resetReceiveDataState;
-(BOOL)getReceiveDataState;
-(void)clearStreamingDataQueue;
+(void)freeInstance;

@end
