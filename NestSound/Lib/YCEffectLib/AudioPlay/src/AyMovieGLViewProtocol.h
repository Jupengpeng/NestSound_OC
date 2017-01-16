#import <UIKit/UIKit.h>
#import "IAYMediaPlayer.h"
@protocol AyAudioProtocol <NSObject>

- (void)SetAudioFormat:(AYMediaAudioFormat *)frame;
- (void)PlayAudio;
- (void)PauseAudio;
- (int)RenderAudio:(unsigned char *)pData with_len:(unsigned int)ulDataSize;
- (void)Stop;
@end
