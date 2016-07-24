    //
//  XHSoundRecorder.m
//  XHSoundRecorder
//
//  Created by Apple on 16/6/7.
//  Copyright © 2016年 张轩赫. All rights reserved.
//

#import "XHSoundRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
NSString *mp3PathTTest=nil;;
@interface XHSoundRecorder () <AVAudioPlayerDelegate, AVAudioRecorderDelegate>


@property (nonatomic, strong)AVAudioSession *session;
@property (nonatomic, strong)AVAudioSession *session2;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) SystemSoundID soundID;


@property (nonatomic, copy) NSString *wavPath;

@property (nonatomic, copy) NSString *mp3Path;

@property (nonatomic, copy) void (^FinishPlaying)();

@property (nonatomic, copy) void (^FinishRecording)(NSString *);
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *player2;


@end

static id _instance;
NSString * path = nil;;
NSString * pathMp3 = nil;;

@implementation XHSoundRecorder

+ (instancetype)sharedSoundRecorder {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

/*+ (instancetype)alloc {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super alloc] init];
    });
    
    return _instance;
}*/

- (AVAudioRecorder *)recorder {
    
    if (!_recorder) {
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        
        NSString * currentTimeString = [formatter stringFromDate:date];
        
        self.fileName = currentTimeString;
        
        NSString *wavPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        
        wavPath = [wavPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",currentTimeString]];
        
        self.wavPath = wavPath;
        path=self.wavPath;
        NSURL *url = [NSURL URLWithString:wavPath];
        NSError *error = nil;

        
        AVAudioSession* session = [AVAudioSession sharedInstance];
        
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        [session setActive:YES error:nil];
        
        if(error){
            
            NSLog(@"录音错误说明%@", [error description]);
        }
        
        
        NSDictionary *settings = [NSDictionary dictionary];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
        
        _recorder.meteringEnabled = YES;
        
        _recorder.delegate = self;
    }
    
    return _recorder;
}

//开始、继续 录音
- (void)startRecorder:(void (^)(NSString *filePath))FinishRecording {
    
    
    if (![self.recorder isRecording]) {
        [self.recorder averagePowerForChannel:0];

        [self.recorder prepareToRecord];
        
        [self.recorder record];
        NSFileManager* f = [NSFileManager defaultManager];
        long long l = [[f attributesOfItemAtPath:self.wavPath error:nil] fileSize];
        NSLog(@"录制---------%@,%lld",self.wavPath,l);
        
        //self.FinishRecording = FinishRecording;
        FinishRecording(self.wavPath);

    }
    
}

//暂停录音
- (void)pauseRecorder {
    
    if ([self.recorder isRecording]) {
        
        [self.recorder pause];
        
    }
    
}

//停止录音
- (void)stopRecorder {
    
    if (self.recorder) {
        [self.recorder stop];
        self.recorder = nil;
    }
   
}

//播放
- (void)playsound:(NSString *)filePath withFinishPlaying:(void (^)())FinishPlaying {
    
        AVAudioSession* session = [AVAudioSession sharedInstance];
        
        [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        [session setActive:YES error:nil];
        
        
                
        NSURL *url=nil;;
        
        if (filePath == nil) {
            
            if (self.wavPath) {
                
                url = [NSURL fileURLWithPath:self.wavPath];
                NSFileManager* f = [NSFileManager defaultManager];
                long long l = [[f attributesOfItemAtPath:self.wavPath error:nil] fileSize];
                NSLog(@"回放----------%@,%lld",self.wavPath,l);
            } else if (self.mp3Path) {
                
                url = [NSURL fileURLWithPath:self.mp3Path];
            } else {
                
                return;
            }
            
        } else {
            
            url = [NSURL fileURLWithPath:filePath];;
        }
        
    //if (!self.player)
    {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        self.player.delegate = self;
        
        [self.player prepareToPlay];
    }
    
    
      [self.player play];
    
    self.FinishPlaying = FinishPlaying;
    
}

//暂停播放
- (void)pausePlaysound {
    
    [self.player pause];
}

//停止播放
- (void)stopPlaysound {
    
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    
}

//删除录音
- (void)removeSoundRecorder {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (self.wavPath) {
        
        [manager removeItemAtPath:self.wavPath error:nil];
        
        self.wavPath = nil;
        
    }
    if (self.mp3Path){
        
        [manager removeItemAtPath:self.mp3Path error:nil];
        
        self.mp3Path = nil;
    }
    
    self.recorder = nil;
    
    self.player = nil;
    
}

//分贝数
- (CGFloat)decibels {
    
    
    CGFloat decibels = [self.recorder averagePowerForChannel:0];
    [self.recorder updateMeters];

    return decibels;
}


//播放结束的代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (self.FinishPlaying) {
        
        self.FinishPlaying();
    }
    
    self.player = nil;
}

//播放被打断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    [self stopPlaysound];
}


//播放被打断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    [self playsound:nil withFinishPlaying:nil];
}

//录音结束的代理
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    if (self.FinishRecording) {
        
        self.FinishRecording(self.wavPath);
    }
}

//录音被打断时
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    
    [self stopRecorder];
    
}

//录音被打断结束时
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
    
}


//转成mp3格式
- (void)recorderFileToMp3WithType:(Type)type filePath:(NSString *)filePath FilePath:(void (^)(NSString *newfilePath))newFilePath {
    
    
    
    NSString *wavFilePath;
    
    if (filePath == nil) {
        
        if (self.wavPath == nil) {
            
            NSLog(@"没有要转的文件");
            
            return;
        }
        
        wavFilePath = self.wavPath;
        
    } else {
        
        wavFilePath = filePath;
    }
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString * currentTimeString = [formatter stringFromDate:date];
   
    
    NSString *mp3FilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    mp3FilePath = [mp3FilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",filePath == nil ? self.fileName : currentTimeString]];
    
    
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
        lame_set_in_samplerate(lame, type == TrueMachine ? 22050 : 44100.0);
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
        pathMp3 =mp3FilePath;
        mp3PathTTest=mp3FilePath;
        NSFileManager *manager = [NSFileManager defaultManager];
        long long l1  = [[ manager attributesOfItemAtPath:filePath error:nil] fileSize];
        long long l2  = [[ manager attributesOfItemAtPath:mp3FilePath error:nil] fileSize];

        NSLog(@"%@转换前＝%lld,%@转换MP3后＝%lld",filePath,l1,mp3FilePath,l2);
        
        
       /* [manager removeItemAtPath:self.wavPath error:nil];
        self.wavPath = nil;*/
        
        
        if (newFilePath) {
            newFilePath(mp3FilePath);
        }
    }
    
}

- (void)testMp3:(NSString*)file{
    
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    [session setActive:YES error:nil];
    
    
    
    
    NSURL *url = [NSURL fileURLWithPath:file];
    NSError* err=nil;
    self.player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    
    
    self.player2.delegate = self;
    
    [self.player2 prepareToPlay];
    
    [self.player2 play];
    
    
    
}


@end





