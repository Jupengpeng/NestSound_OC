//
//  RecordAVPacketDataBlock.h
//  UAnYan
//
//  Created by czhui on 15/10/15.
//  Copyright © 2015年 Wyeth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioRecord.h"

#define AUDIO_RECODER_SZY 1

#if AUDIO_RECODER_SZY
#import "AudioAACRecoder.h"
#endif

#if AUDIO_RECODER_SZY
@interface RecordAVPacketDataBlock : NSObject<AudioAACRecoderProtocol>
#else
@interface RecordAVPacketDataBlock : NSObject
#endif
{
    /**
     * audio record
     */
    NSMutableArray              *m_recordAudioPacketArray;
    NSCondition                 *m_rwRecordAudioPacketLock;
    UAudioRecord                 *m_audioRecord;
    BOOL                        m_isRecording;
    
    short                       m_decodeAudio[AUDIOPACKET/2];//audio play data
    
#if AUDIO_RECODER_SZY
    AudioAACRecoder             *aacRecoder;
#endif
}

//声波渲染协议
@property(nonatomic, retain) id audioWaveProtocol;

+(RecordAVPacketDataBlock *)shareInstance;
-(void)startRecord;
-(void)addRecordAudioPacketToQueue:(unsigned char *)data length:(int)len;
-(int)getRecordAudioPacket:(NSMutableData *)data;
-(void)clearRecordAudioQueue;
-(BOOL)hasAudioData;
-(void)stopRecord;
-(int)getInstantaneousAmplitude;
+(void)freeShareInstance;

-(int)getAudioData:(NSMutableData *)data senderid:(int)playID PlayCount:(int *)playCount;
@end
