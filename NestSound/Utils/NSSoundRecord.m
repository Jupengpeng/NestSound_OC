//
//  NSSoundRecord.m
//  NestSound
//
//  Created by Apple on 16/5/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSoundRecord.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

@interface NSSoundRecord () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, copy) NSString *filename;

@property (nonatomic, assign) SystemSoundID soundID;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, copy) NSString *wavPath;

@property (nonatomic, copy) NSString *mp3Path;

@end

@implementation NSSoundRecord


- (void)startRecorder {
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString * currentTimeString = [formatter stringFromDate:date];
    
    self.filename = currentTimeString;
    
    NSString *wavPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    wavPath = [wavPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",currentTimeString]];
    
    self.wavPath = wavPath;
    
    NSURL *url = [NSURL URLWithString:wavPath];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    [session setCategory:AVAudioSessionCategoryRecord error:&error];
    
    if(error){
        
        NSLog(@"录音错误说明%@", [error description]);
    }
    
    if (!self.recorder) {
    
        NSDictionary *setting = [NSDictionary dictionary];
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
        
        self.recorder.meteringEnabled = YES;
        
    }
        
    [self.recorder prepareToRecord];
    
    [self.recorder record];
}

- (void)pauseRecorder {
    
    [self.recorder pause];
}

- (void)stopRecorder {
    
    [self.recorder stop];
    
    self.recorder = nil;
}

- (void)playsound {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    if(error){
        
        NSLog(@"播放错误说明%@", [error description]);
    }
    
    NSURL *url =[NSURL fileURLWithPath:self.wavPath];
    
    if (!self.player) {
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        self.player.delegate = self;
        
    }
        
    [self.player prepareToPlay];
    
    [self.player play];

    
}

- (void)pausePlaysound {
    
    [self.player pause];
}


- (void)stopPlaysound {
    
    [self.player stop];
    
    self.player = nil;
}

- (void)removeSoundRecorder {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager removeItemAtPath:self.wavPath error:nil];
}


- (CGFloat)decibels {
    
    [self.recorder updateMeters];
    
    CGFloat decibels = [self.recorder averagePowerForChannel:0];
    
    return decibels;
}

//播放器代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if ([self.delegate respondsToSelector:@selector(soundRecord:)]) {
        
        [self.delegate soundRecord:self];
    }
}

//播放被打断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    [self stopPlaysound];
}


//打断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    [self playsound];
}


//转成mp3格式的  暂时没有用

/*
- (void)audio_PCMtoMP3
{
    
   
    NSString *wavFilePath = self.wavPath;
    
    NSString *mp3FilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    mp3FilePath = [mp3FilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.filename]];
    
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([wavFilePath cStringUsingEncoding:1], "rb");//被转换的文件
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");//转换后文件的存放位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"转换完毕");
        self.mp3Path = mp3FilePath;
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        [manager removeItemAtPath:self.wavPath error:nil];
    
    }
    
}
*/

@end
