//
//  RecordAVPacketDataBlock.m
//  UAnYan
//
//  Created by czhui on 15/10/15.
//  Copyright © 2015年 Wyeth. All rights reserved.
//

#import "RecordAVPacketDataBlock.h"

#if AUDIO_RECODER_SZY
#else
#import "anyan_faac_encoder.h"
#endif

#if 0
//#define RECORD_AV_PACKET_Log(fmt, ...) NSLog((@"%@ " fmt), @"##RECORD AV_PACKET##", ##__VA_ARGS__)
#define RECORD_AV_PACKET_Log(fmt, ...) printf("##RECORD AV_PACKET## %s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#define RECORD_AV_PACKET_Log(...) {}
#endif

static RecordAVPacketDataBlock    *shareRecordAVPacketDataBlock = nil;

@implementation RecordAVPacketDataBlock

+(RecordAVPacketDataBlock *)shareInstance{
    @synchronized(self){
        if(nil == shareRecordAVPacketDataBlock){
            shareRecordAVPacketDataBlock = [[self alloc] init];
            [shareRecordAVPacketDataBlock intData];
        }
    }
    return shareRecordAVPacketDataBlock;
}

-(void)intData{
    m_isRecording = FALSE;
    m_recordAudioPacketArray = [[NSMutableArray alloc] init];
    m_rwRecordAudioPacketLock = [[NSCondition    alloc]  init];
#if AUDIO_RECODER_SZY
    aacRecoder = [[AudioAACRecoder alloc] init];
#endif
}

-(void)startRecord{
    if(m_isRecording)return;
    m_isRecording = TRUE;
#if AUDIO_RECODER_SZY
    aacRecoder.audioWaveProtocol = _audioWaveProtocol;
    aacRecoder.delegate = self;
    [aacRecoder start];
#else
    m_audioRecord = [[UAudioRecord Instance] init];
    [m_audioRecord StartRecord];
#endif
}

-(void)addRecordAudioPacketToQueue:(unsigned char *)data length:(int)len{
    RECORD_AV_PACKET_Log(@"add one record audio packet to audio queue.....");
    NSMutableData *one_packet_audio_data = [[NSMutableData alloc] initWithBytes:data length:len];
    [m_rwRecordAudioPacketLock   lock];
    if([m_recordAudioPacketArray count] > 100){
        RECORD_AV_PACKET_Log(@"romove audio packet range of 0 to 20 in m_recordAudioPacketArray!");
        [m_recordAudioPacketArray   removeObjectsInRange:NSMakeRange(0, 20)];
    }
    
    [m_recordAudioPacketArray   addObject:one_packet_audio_data];
    [m_rwRecordAudioPacketLock   unlock];
    
}

#if AUDIO_RECODER_SZY
-(void)addRecordAudioPacketToQueue:(NSData *)data{
    RECORD_AV_PACKET_Log(@"szy' audio recoder add one record audio packet to audio queue.....");
    NSMutableData *one_packet_audio_data = [[NSMutableData alloc] init];
    [one_packet_audio_data appendData:data];
    [m_rwRecordAudioPacketLock   lock];
    if([m_recordAudioPacketArray count] > 100){
        RECORD_AV_PACKET_Log(@"romove audio packet range of 0 to 20 in m_recordAudioPacketArray!");
        [m_recordAudioPacketArray   removeObjectsInRange:NSMakeRange(0, 20)];
    }
    
    [m_recordAudioPacketArray   addObject:one_packet_audio_data];
    [m_rwRecordAudioPacketLock   unlock];
    
}
#endif

-(int)getRecordAudioPacket:(NSMutableData *)data{
    if([m_recordAudioPacketArray count] == 0)return 0;
    NSMutableData *rawData = [[NSMutableData alloc] init];
    [m_rwRecordAudioPacketLock lock];
    NSMutableData *audio_packet_data = [m_recordAudioPacketArray    objectAtIndex:0];
    [rawData appendBytes:[audio_packet_data bytes] length:[audio_packet_data length]];
    [m_recordAudioPacketArray   removeObjectAtIndex:0];
    [m_rwRecordAudioPacketLock   unlock];
    
#if AUDIO_RECODER_SZY
    [data appendData:rawData];
#else
    /**
     * endcord audio data
     */
    int raw_data_len = [rawData length];
    
    if(raw_data_len > 1024){
        raw_data_len = 1024;
    }
    
    void *dataBuffer = (void *)malloc(raw_data_len);
    [rawData getBytes:dataBuffer length:raw_data_len];
    
    void *outBuffer = (void *)malloc(raw_data_len);
    unsigned int outDataSize = -1;
    
    int ret = [[anyan_faac_encoder shareInstance] encodeWithInData:dataBuffer inDataLen:raw_data_len outData:outBuffer outDataLen:&outDataSize];
    RECORD_AV_PACKET_Log(@"raw data length = %d, out audio data size = %d out buffer = %p", raw_data_len, outDataSize, outBuffer);
    
    [data appendBytes:outBuffer length:outDataSize];
    
    free(dataBuffer);
    free(outBuffer);
#endif
    
    return 1;
}

-(void)clearRecordAudioQueue{
    [m_rwRecordAudioPacketLock   lock];
    [m_recordAudioPacketArray removeAllObjects];
    [m_rwRecordAudioPacketLock   unlock];
}

-(BOOL)hasAudioData{
    if([m_recordAudioPacketArray count] > 0){
        return YES;
    }else{
        return NO;
    }
}

-(void)stopRecord{
#if AUDIO_RECODER_SZY
    [aacRecoder stop];
#else
    if(!m_isRecording){
        return;
    }
    [m_audioRecord StopRecord];
#endif
    m_isRecording = FALSE;
}

-(void)releaseData{
    [self stopRecord];
    [UAudioRecord FreeAudioRecord];
    [self clearRecordAudioQueue];
}

-(int)getInstantaneousAmplitude{
    if (m_audioRecord) {
        return [aacRecoder getInstantaneousAmplitude];
    }
    
    return 0;
}

+(void)freeShareInstance{
    if(nil != shareRecordAVPacketDataBlock){
        [shareRecordAVPacketDataBlock releaseData];
        shareRecordAVPacketDataBlock = nil;
    }
}

-(int)getAudioData:(NSMutableData *)data senderid:(int)playID PlayCount:(int *)playCount
{
    
    RECORD_AV_PACKET_Log(@"audio packet count:%i", [m_recordAudioPacketArray    count]);
    
    bzero(m_decodeAudio, AUDIOPACKET/2);
    
    if(*playCount >= 30)
    {
        RECORD_AV_PACKET_Log(@"getAudioData:remove range of 0 to 30 in m_recordAudioPacketArray");
        [m_rwRecordAudioPacketLock   lock];
        [m_recordAudioPacketArray removeObjectsInRange:NSMakeRange(0, 30)];
        [m_rwRecordAudioPacketLock   unlock];
        *playCount = 0;
    }
    
    [m_rwRecordAudioPacketLock   lock];
    if((int)([m_recordAudioPacketArray count] - *playCount) > 0)
    {
        int readAudioLength = [[m_recordAudioPacketArray objectAtIndex:*playCount] length];
        memcpy(m_decodeAudio, (char *)[[m_recordAudioPacketArray objectAtIndex:*playCount] bytes], readAudioLength);
        (*playCount)++;
        
        RECORD_AV_PACKET_Log(@"*playCount = %d", *playCount);
        
        for (int i=0; i<readAudioLength/2; i++)
        {
            m_decodeAudio[i] = ((m_decodeAudio[i] & 0x00ff) << 8) | ((m_decodeAudio[i] & 0xff00) >> 8);
        }
        
        
        
        
        [data appendBytes:m_decodeAudio length:readAudioLength];
        
        RECORD_AV_PACKET_Log(@"readAudioLength = %i, playCount = %i", readAudioLength, *playCount);
    }
    else{
        RECORD_AV_PACKET_Log(@"************record audio queue has no audio data**************");
        memset(m_decodeAudio, 0, AUDIOPACKET/6);
        [data appendBytes:m_decodeAudio length:AUDIOPACKET/6];
    }
    [m_rwRecordAudioPacketLock   unlock];
    
    return 1;
}

#if AUDIO_RECODER_SZY
-(void)onRecoderComplete:(AudioAACRecoder *)recoder aacData:(NSData *)data{
    RECORD_AV_PACKET_Log(@"onRecoderComplete, data size = %ld", (unsigned long)[data length]);
    [self addRecordAudioPacketToQueue:data];
}
#endif

@end
