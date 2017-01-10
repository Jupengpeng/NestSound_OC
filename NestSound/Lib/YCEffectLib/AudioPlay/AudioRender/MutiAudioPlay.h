

#import <Foundation/Foundation.h>
#import "AudioPlay.h"

@interface MutiAudioPlay : NSObject{
     AudioFormat                 m_audioFormat;
}

-(void)setAudioFormat:(AudioFormat)format;

-(bool)AddNode:(int) playID;
-(bool)DeleNode:(int) playID;
-(void)ReleaseList;
-(bool)setVolume:(Float32)volume;
-(void)Stop;

@end
