

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
//#import "blockPacket.h"
#import "AVComType.h"


@interface AudioPlay : NSObject
{
    struct AQPlayerState aqData;
    int playID;
    int playCount;
    NSMutableData *dataBuffer;
    
    AudioFormat         m_audioPlayFormat;
}


//+ (AudioPlay *)Instance;
//+ (void)FreeAudioPlay;
//-(void) DeriveBufferSize:(AudioStreamBasicDescription *)ASBDesc PacketSize:(UInt32) maxPacketSize Second:(Float64)seconds OutBufSize:(UInt32*)outBufferSize OutNumPack:(UInt32*)outNumPacketsToRead;
-(void) audioQueueOutputWithQueue:(AudioQueueRef)audioQueue queueBuffer:(AudioQueueBufferRef)audioQueueBuffer;

-(void)setAudioPlayFormat:(AudioFormat)format;
-(void) StartPlay;
-(bool) LoudSpeaker:(bool)bOpen;
-(void) StopPlay;
-(BOOL) SetVolume:(Float32) Volume;
-(void)SetPlayID:(int) audioPlayID;
@end
