
#import <Foundation/Foundation.h>
#import "AVComType.h"

@interface UAudioRecord : NSObject
{
    struct AQRecorderState aqData; 
    BOOL micOff;
}

+ (UAudioRecord *)Instance;
+ (void)FreeAudioRecord;
- (void) DeriveBufferSize:(AudioQueueRef)audioQueue audioDescription:(AudioStreamBasicDescription *)ASBDescription second:(Float64)seconds outBufSize:(UInt32 *)outBufferSize;
- (OSStatus) SetMagicCookieForFile:(AudioQueueRef) inQueue aFileID:(AudioFileID) inFile;
- (void) SetRecordAudio:(float)mSampleRate;
- (void) StartRecord;
- (void) StopRecord;
- (BOOL) GetMicState;
- (BOOL) SetMicState;
- (BOOL) hasMicphone;
@end
