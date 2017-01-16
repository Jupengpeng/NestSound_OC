//
//  NSWriteMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//


#define kButtonTag 160


#import <AVFoundation/AVFoundation.h>
#import "NSWriteMusicViewController.h"
#import "NSAccompanyListViewController.h"
#import "NSDrawLineView.h"
#import "NSLyricView.h"
#import "NSOptimizeMusicViewController.h"
#import "NSImportLyricViewController.h"
#import "XHSoundRecorder.h"
#import "NSAccommpanyListModel.h"
#import "NSPlayMusicTool.h"
#import "DeviceMusicWave.h"
#import "NSPublicLyricViewController.h"
#import "NSTunMusicModel.h"
#import "NSLoginViewController.h"
#import "NSWaveformView.h"
#import "NSPlayMusicViewController.h"
#import "NSDownloadProgressView.h"
#import "NSLoginViewController.h"
#import "NSSoundEffectViewController.h"
#import "AFHTTPSessionManager.h"
#import "lame.h"
#import "MBProgressHUD.h"
#import "HudView.h"
#import "NSCooperationDetailModel.h"


#import "YCMusicPlayer.h"

#import "IAYMediaPlayer.h"
#import "YCBaseEffectWrap.h"
#import "YCPcmPlayerWrap.h"
#import "AyMovieGLView.h"
#include "PCCallback.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioRecord.h"
#import "YCMp3encWrap.h"
#import "YCPlayPCMCallback.h"

CGFloat decilCount;

Boolean plugedHeadset;


@interface NSWriteMusicViewController () <UIScrollViewDelegate, ImportLyric, AVAudioPlayerDelegate,UIAlertViewDelegate, AVAudioRecorderDelegate,UITextViewDelegate,YCMusicPlayerDelegate> {
    
    UILabel *totalTimeLabel;
    float timerNumRecorder;
    float timerNumRecorder_temp;
    float timerNumPlay;
    float timerNumPlay_temp;
    int clickValue;
    CGFloat timerNumTemp;
    CGFloat speed;
    CGFloat timerNum;
    CGFloat totalTime;
    UITextField *titleText;
    UIImageView * listenBk;
    UIImageView * recordBk;
    UIImageView * reRecordBk;
    NSLyricView *lyricView;
    NSString  * hotMp3Url;
    long hotId;
    long musicTime;
    NSString * mp3URL;
    NSTimeInterval curtime;

    NSTimeInterval curtime2;
    NSTimeInterval curtime3;
    Boolean receivedData;

    CGFloat distantKeyPath;
    NSUInteger drawCount;
//    NSUInteger drawNum;
    BOOL downloadFinish;
    BOOL stopScroll;
    NSDownloadProgressView *ProgressView;//BoxDismiss
    UIView *_bottomView;
    NSTimer *timer;
    UIImageView *timerImgView;
    int num;
    int frameInterval;
    int testNum;
    
    //音频播放
    
    CBaseEffectWrap *_effectWrap;
    CYCPcmPlayerWrap *_pYCPcmPlayer;
    
//    AFHTTPSessionManager *manager;
}

@property (nonatomic,strong) YCMusicPlayer *YCPlayer;


@property (nonatomic, strong) UIImageView *slideBarImage;
@property (nonatomic, assign)CGFloat distantKeyPathTemp;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) DeviceMusicWave* DeviceMusicWaveView;

@property (nonatomic, strong)  CADisplayLink *link;
@property (nonatomic, strong)  CADisplayLink *waveLink;
;
@property (nonatomic, assign) int clickedValue;


@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) AVAudioRecorder *recorder;

//@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *player2;
@property (nonatomic, strong) AVAudioPlayer *player3;
@property (nonatomic, strong) NSMutableArray *playerArray;

@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, weak)  UIBarButtonItem *next;

@property (nonatomic, copy) NSString *mp3Path;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *wavFilePath;
@property (nonatomic, strong)NSPublicLyricViewController* publicController;
@property (nonatomic, strong) NSWaveformView *waveform;

@property (nonatomic, strong)AppDelegate* appDelete;
@property (nonatomic, assign) int lineNum;
@property (nonatomic, assign) int lineNum2;
@property (nonatomic, assign) NSTimeInterval playerTime;

//是否正在回放作品
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, assign) BOOL isPlay2;

@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic,strong) UIAlertController *alertView;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic,strong) UIButton *guideBanzouButton;

@property (nonatomic,strong) UIButton *guideDaoruButton;

@property (nonatomic, copy) NSString *accompanyPCMPath;



@end

@implementation NSWriteMusicViewController

////////以下为录音begin///

- (AVAudioRecorder *)newRecorder {
    
    NSDictionary *settings = @{AVSampleRateKey : @(88200.0),
                               AVNumberOfChannelsKey : @(1),
                               AVLinearPCMIsFloatKey:@(NO)
                               };

    
    if (!_recorder) {
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        
        NSString * currentTimeString = [formatter stringFromDate:date];
        
        self.fileName = currentTimeString;
        
        NSString *wavPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        
//        wavPath = [wavPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",currentTimeString]];
        wavPath = [wavPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",currentTimeString]];

        self.wavFilePath = wavPath;
        NSURL *url = [NSURL URLWithString:wavPath];
        NSError *error = nil;
        
        

        
        if(error){
            
            CHLog(@"录音错误说明%@", [error description]);
        }
        
        
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
        
        _recorder.meteringEnabled = YES;
        
        _recorder.delegate = self;
    }
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    [session setActive:YES error:nil];
    return _recorder;
}
/////
//开始、继续 录音
- (void)startRecorder{
    
    self.recorder = [self newRecorder];
    
    if (![self.recorder isRecording])
    {
        [self.recorder averagePowerForChannel:0];
        
        [self.recorder prepareToRecord];
        
        [self.recorder record];
        
//        NSFileManager* f = [NSFileManager defaultManager];
//        long long l = [[f attributesOfItemAtPath:self.wavFilePath error:nil] fileSize];
        
    }
    
}

//暂停录音
- (void)pauseRecorder {
    
    if ([self.recorder isRecording])
    {
        lyricView.lyricText.userInteractionEnabled = YES;
        lyricView.lyricView.scrollEnabled = YES;
        self.waveform.timeScrollView.userInteractionEnabled=YES;
        //暂停显示所有波形
        
        [self.waveform waveViewShowAllChangedColorWaves];
        
        [self.waveLink setPaused:YES];
        
        timerNumPlay_temp = timerNum;
        timerNumRecorder_temp = timerNum;
        [self.YCPlayer pause];

//        timerNumRecorder_temp = self.player.currentTime;
//        [self pausePlaysound:self.player];
        [self.link setPaused:YES];
        timerNumTemp=timerNum;
        [self.recorder pause];
        UIButton* btn = self.btns[2];
        btn.selected = NO;
    }
    
}

//停止录音
- (void)stopRecorder {
    
    if (self.recorder)
    {
        [self.recorder stop];
        self.recorder = nil;
    }
    
}

//播放
- (void)playsound:(NSString*)audioPath time:(NSTimeInterval)curTime{
    NSError* error=nil;
    
    NSURL *url=nil;;
    
        if (audioPath) {
            NSFileManager* f = [NSFileManager defaultManager];
            long long l = [[f attributesOfItemAtPath:audioPath error:nil] fileSize];
            if (l == 0) {
                [self.link setPaused:YES];
                [HudView showView:self.navigationController.view string:@"文件大小为0，无法播放"];


                return;
            }
            url = [NSURL fileURLWithPath:audioPath];
            
        }
    
        self.player3 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.player3.enableRate = YES;
        self.player3.rate = 1.0;
        self.player3.meteringEnabled=YES;
        self.player3.delegate = self;
    
        [self.player3 setCurrentTime:curTime];
    
        [self.player3 prepareToPlay];
    
        [self.player3 play];
    
}

//暂停播放
- (void)pausePlaysound:(AVAudioPlayer*) player{
    
    [player pause];
}

//停止播放
- (void)stopPlaysound:(AVAudioPlayer*) player{
    
    if (player) {
        [player stop];
        //player = nil;
    }
    
}

//删除录音
- (void)removeSoundRecorder {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (self.wavFilePath) {
        
        [manager removeItemAtPath:self.wavFilePath error:nil];
        
        self.wavFilePath = nil;
        
    }
    if (self.mp3Path){
        
        [manager removeItemAtPath:self.mp3Path error:nil];
        
        self.mp3Path = nil;
    }
    
    [self stopAllDevides];

}

- (void)stopAllDevides {
    if (self.YCPlayer) {
        [self.YCPlayer stop];
        self.YCPlayer = nil;
    }
//    if (self.player) {
//        [self.player stop];
//        self.player = nil;
//    }
    if (self.player2) {
        [self.player2 stop];
        self.player2 = nil;
    }
    if (self.player3) {
        [self.player3 stop];
        self.player3 = nil;
    }
    if (self.recorder) {
        [self.recorder stop];
        self.recorder = nil;
    }
    

}

- (void)pauseDevides {
    if (self.YCPlayer) {
        [self.YCPlayer pause];
    }
//    if (self.player) {
//        [self.player pause];
//    }
    if (self.recorder) {
        [self.recorder pause];
    }
    
    
}

- (void)setupPCMCreater{
    
    
}

//分贝数
- (CGFloat)decibels {
    
    [self.recorder updateMeters];
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -60.0f; // Or use -60dB, which I measured in a silent room.
    /**
     *  获得指定声道的分贝平均值
     */
    float   decibels    = [self.recorder averagePowerForChannel:0];
//    CHLog(@"%f",decibels);
    if (decibels < minDecibels)
    {
        level = -0.0f;
        
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
        
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        level = powf(adjAmp, 1.0f / root);

    }
    return level * 60.0;
}

- (CGFloat)playerDecibels:(AVAudioPlayer*)player {
    
    [player updateMeters];
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -60.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [player averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = -0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    return level * 60;
}


//播放结束的代理方法
/*- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.audioPlayers removeObject:player];
    
    [self stopPlaysound];

    
}*/

/*
 *  播放状态改变
 */

- (void)YCMusicPlayerChangingStatus:(YCPlayerPlayStatus)playStatus
{
    NSLog(@"playStatus %lu",(unsigned long)playStatus);
    switch (playStatus) {
        case YCPlayerPlayPrepared:
        {
        }
            break;
        case YCPlayerPlayPlaying:
        {
            timerImgView.hidden = YES;
            [self.waveLink setPaused:NO];
            [self.link setPaused:NO];
            num = 4;
            [self removeTimer];
            [self startRecorder];
            
        }
            break;
        case YCPlayerPlayStarting:
        {
            
        }
            break;
        case YCPlayerPlayPaused:
        {
            
        }
            break;
        case YCPlayerPlayStopped:
        {
            
        }
            break;
        default:
            break;
    }
}

/*
 *  播放时间变化
 */
- (void)YCMusicPlayerPlayChangingPosition:(CGFloat)position{
    
//    NSLog(@"position %f",position - 1.671);
}

/*
 *  当伴奏播放结束
 */
- (void)YCMusicPlayerPlayCompletionOfFileUrl:(NSString *)fileUrl{
    timerNum=0;
    
    lyricView.lyricText.userInteractionEnabled = YES;
    lyricView.lyricText.scrollEnabled = YES;
    UIButton* btn = self.btns[2];
    btn.selected = NO;
    btn.userInteractionEnabled = NO;
    
    timerNumRecorder=0;
    timerNumRecorder_temp=0;
    //    [self stopPlaysound:player];
    
    [self.YCPlayer stop];
    [self stopRecorder];
    [self.link setPaused:YES];
    [self.waveLink setPaused:YES];
    
}




#pragma mark -  AVAudioPlayerDelegate
//伴奏播放和录制作品完毕的回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
//    [self.waveform.timeScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//    [self.waveform.timeScrollView setContentOffset:CGPointMake(self.waveform.timeScrollView.contentSize.width, 0) animated:NO];
    
    timerNum=0;
    /*
    //录制伴奏结束
    if (player == self.player) {
        lyricView.lyricText.userInteractionEnabled = YES;
        lyricView.lyricText.scrollEnabled = YES;
        UIButton* btn = self.btns[2];
        btn.selected = NO;
        btn.userInteractionEnabled = NO;
        
        timerNumRecorder=0;
        timerNumRecorder_temp=0;
        [self stopPlaysound:player];
        [self stopRecorder];
        [self.link setPaused:YES];
        [self.waveLink setPaused:YES];

    }
     */
    //试听结束
    if (player == self.player3) {
        [self audioWorkAuditionEndProcess];
        [self.waveform.timeScrollView setContentOffset:CGPointMake([self.waveform.waveView.locationsArr.lastObject floatValue] - ScreenWidth/2.0, 0) animated:NO];

    }
    
    
}
//试听结束重新开始
- (void)audioWorkAuditionEndProcess{
    UIButton* btn = self.btns[1];
    btn.selected = NO;
    timerNumPlay_temp=0;
    timerNumPlay=0;
    curtime3=0;
    //        curtime2=0;
    [self.waveLink setPaused:YES];
    [self.link setPaused:YES];
    self.waveform.timeScrollView.userInteractionEnabled=YES;
    lyricView.lyricText.userInteractionEnabled = YES;
    [self stopPlaysound:self.player3];
    
    [self stopPlaysound:self.player2];
    
}

//播放被打断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    
//    if ([self.player isPlaying]||[self.player3 isPlaying]) {
//        return;
//    }

//    CGFloat distant = [[change objectForKey:@"new"] floatValue];

//    if (distant> distantKeyPath) {
//        [self.waveform.timeScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//        
//    }
    
//    [self changeScrollViewColor];

   
//    if ([self.waveform.timeScrollView isDragging]) {
//        [self changeScrollViewColor];
//    }
//}

//播放被打断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    //[self playsound:nil withFinishPlaying:nil];
}

//录音结束的代理
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
   /* if (self.FinishRecording) {
        
        self.FinishRecording(self.wavPath);
    }*/
}

//录音被打断时
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    
    //[self stopRecorder];
    
}

//录音被打断结束时
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
    
}


//转成mp3格式
- (NSString *)recorderFileToMp3WithType:(Type)type filePath:(NSString *)filePath  {
    NSFileManager *manager = [NSFileManager defaultManager];
    long long l = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    if (!filePath ||l==0) {
        return nil;
    }
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString * currentTimeString = [formatter stringFromDate:date];
    
    
    NSString *mp3FilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    mp3FilePath = [mp3FilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",filePath == nil ? self.fileName : currentTimeString]];
    
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");//被转换的文件
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");//转换后文件的存放位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
//        lame_set_in_samplerate(lame, type == TrueMachine ? 22050 : 44100.0);
        lame_set_in_samplerate(lame, 44100.0);

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
        CHLog(@"%@",[exception description]);
    }
    @finally {
        self.mp3Path = mp3FilePath;
        long long l1  = [[ manager attributesOfItemAtPath:filePath error:nil] fileSize];
        long long l2  = [[ manager attributesOfItemAtPath:mp3FilePath error:nil] fileSize];
//
        CHLog(@"%@转换前＝%lld,%@转换MP3后＝%lld",filePath,l1,mp3FilePath,l2);
        
    }
    return mp3FilePath;
    
}
/*
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
 */
////////以上为录音end///
- (NSMutableArray *)btns {
    
    if (!_btns) {
        
        _btns = [NSMutableArray array];
    }
    
    return _btns;
}

- (NSMutableDictionary *)dict {
    
    if (!_dict) {
        
        _dict = [NSMutableDictionary dictionary];
    }
    
    return _dict;
}


-(instancetype)initWithItemId:(long)itemID_ andMusicTime:(long)musicTime_ andHotMp3:(NSString *)hotMp3
{
    if (self = [super init]) {
        hotId = itemID_;
        hotMp3Url = hotMp3;
        musicTime = musicTime_;
    }
    return self;
}

#pragma mark - controller method

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([[NSTool getMachine] isEqualToString:@"iPhone7,1"] || [[NSTool getMachine] isEqualToString:@"iPhone8,2"]) {
//        frameInterval = 3;
//    } else {
        frameInterval = 4;
//    }
    self.appDelete = [[UIApplication sharedApplication] delegate];
    self.session = [AVAudioSession sharedInstance];
    self.wavFilePath = nil;
    self.mp3Path=nil;
    num = 4;
    timerNum=0;
    drawCount=0;
    stopScroll=NO;
    timerNumRecorder=0;
    timerNumRecorder_temp=0;
    timerNumPlay=0;
    timerNumPlay_temp=0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClearRecord:) name:@"clearRecordNotification" object:nil];
    
//    [self addObserver:self forKeyPath:@"distantKeyPathTemp" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseRecorder)
                                                 name:@"pausePlayer"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseRecorder) name:AVAudioSessionInterruptionNotification object:nil];

    
    
    [self setupUI];

    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick:)];
    
    self.navigationItem.rightBarButtonItem = next;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBackClick:)];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    [self.view addGestureRecognizer:tap];
    
    [self addLink];
    [self.link setPaused:YES];
    [self addWaveLink];
    [self.waveLink setPaused:YES];
    self.waveform.timeScrollView.delegate =self;
  
//    [self initMusicWave];

    
    speed = ScreenWidth/SECOND_LONG;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSSingleTon viewFrom].viewTag = @"";

    [UIApplication sharedApplication].idleTimerDisabled = YES;//设置不允许休眠
    self.navigationController.navigationBar.hidden = NO;
    //timerNumRecorder=0;
    //timerNumRecorder_temp=0;
    timerNumPlay=0;
    timerNumPlay_temp=0;
    mp3URL=nil;
    
   
    //如果是合作加入歌曲
    if (self.coWorkModel.lyrics.length) {
        
        [self setupCooperateContent];
    }else{
        lyricView.lyricText.editable = YES;
        titleText.userInteractionEnabled = YES;
        titleText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"recordTitle"];
        lyricView.lyricText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"recordLyric"];
        
    }
    
    //stop the music
    self.clickedValue = 0;
    NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
    
    playVC.playOrPauseBtn.selected = NO;
    downloadFinish = NO;
    [playVC pausePlayer];
    [self resetButton];
    
    //下载伴奏
    [self downloadAccompanyWithUrl:hotMp3Url];
}
- (void)viewDidDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = NO;//设置不允许休眠
    
    [super viewDidDisappear:animated];
    
    [[NSHttpClient client] cancelDownload];
}

- (void)playEndedProcess{
    
}

- (void)receiveClearRecord:(NSNotification *)notiInfo {
    [self clearRecord];
    hotId = [notiInfo.userInfo[@"accompanyId"] longValue];
    hotMp3Url = notiInfo.userInfo[@"accompanyUrl"];
    musicTime = [notiInfo.userInfo[@"accompanyTime"] longValue];
    totalTimeLabel.text = [NSString stringWithFormat:@"/%@",[NSTool stringFormatWithTimeLong:musicTime]];
}


- (void)tapClick:(UIGestureRecognizer *)tap {
    
    [lyricView.lyricText resignFirstResponder];
    
    [titleText resignFirstResponder];
}

- (void)downloadAccompanyWithUrl:(NSString *)urlStr {

    NSFileManager * fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:LocalAccompanyPath]) {
        [fm createDirectoryAtPath:LocalAccompanyPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        if (![fm fileExistsAtPath:[LocalAccompanyPath stringByAppendingPathComponent:[urlStr lastPathComponent]]]) {
            //下载进度条
            self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            
            _maskView.backgroundColor = [UIColor blackColor];
            
            _maskView.alpha = 0.5;
            
            [self.navigationController.view addSubview:_maskView];
            
            ProgressView = [[NSDownloadProgressView alloc] initWithFrame:CGRectMake(ScreenWidth/6, ScreenHeight/3, 2*ScreenWidth/3, ScreenHeight/4)];
            
            ProgressView.downloadDic = @{@"title":@"温馨提示",@"message":@"戴上耳机，效果更佳哦～",@"loading":@"正在努力加载，请稍候..."};
            
            [ProgressView.cancelBtn addTarget:self action:@selector(removeProgressView) forControlEvents:UIControlEventTouchUpInside];
            
            [self.navigationController.view addSubview:ProgressView];

            [[NSHttpClient client] downLoadWithFileURL:urlStr completionHandler:^{
                downloadFinish = YES;
                [self removeProgressView];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:LocalAccompanyListPath]) {
                    
                    [fileManager createFileAtPath:LocalAccompanyListPath contents:nil attributes:nil];
                }
                NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:LocalAccompanyListPath] ];
                if (!resultArray) {
                    resultArray = [NSMutableArray array];
                }
                if (![resultArray containsObject:self.jsonStr]) {
                    [resultArray addObject:self.jsonStr];

                }
                [resultArray writeToFile:LocalAccompanyListPath atomically:YES];
 
            }];
        } else {
            
            downloadFinish = YES;
            
        }
    }
}
- (void)removeProgressView {
    
    [self.maskView removeFromSuperview];
    
    [ProgressView removeFromSuperview];
}
- (void)leftBackClick:(UIBarButtonItem *)back {
    [NSSingleTon viewFrom].viewTag = @"";
    WS(wSelf);
  
    UIButton *btn =  self.btns[2];
    if (self.wavFilePath || self.mp3Path || btn.selected) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请确认操作" message:@"是否放弃当前录音？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSUserDefaults *recordText = [NSUserDefaults standardUserDefaults];
            [recordText removeObjectForKey:@"recordTitle"];
            [recordText removeObjectForKey:@"recordLyric"];
            [recordText synchronize];
            [wSelf removeLink];
//            [wSelf stopPlaysound:self.player];
            [wSelf.YCPlayer stop];
            [wSelf stopPlaysound:self.player2];
            [wSelf stopPlaysound:self.player3];
            [wSelf stopRecorder];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            
            [manager removeItemAtPath:self.wavFilePath error:nil];
            
            [manager removeItemAtPath:self.mp3Path error:nil];
            
            [wSelf.waveform removeAllPath];
            
            [wSelf.navigationController popViewControllerAnimated:YES];
            
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            return;
        }];
        
        [alert addAction:action1];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        [self removeSoundRecorder];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - 合作成品部分
- (void)setupCooperateContent{
    //如果是合作的歌词
        lyricView.lyricText.editable = NO;
        titleText.userInteractionEnabled = NO;
        
        NSString *contentStr = [NSString stringWithFormat:@"作曲者：%@\n作词者：%@\n%@",self.coWorkModel.wUsername,self.coWorkModel.lUsername,self.coWorkModel.lyrics];
        titleText.text = self.coWorkModel.title;
        [self setupAttributesWithTextView:lyricView.lyricText ContentStr:contentStr];

}

#pragma mark - setupUI

/**
 *  设置操作引导
 */
- (void)setupGuideView{
    
    BOOL isWriteMusicInited = [[NSUserDefaults standardUserDefaults] boolForKey:@"isWriteMusicInited"];
    if (!isWriteMusicInited) {
        [self.navigationController.view addSubview:self.guideBanzouButton];

        [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"isWriteMusicInited"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{

    }
}

- (void)setupUI {
    
    //nextAccompany
    
    //listenBk
//    listenBk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_listen_bk"]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:lineView];
    
    UIView *bottomView = [[UIView alloc] init];
    
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        
        make.height.mas_equalTo(72);
    }];
    _bottomView = bottomView;
    
    CGFloat btnW = ScreenWidth / 5;
    
    for (int i = 0; i < 5; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * i, 0, btnW, btnW)];
        
        NSString *imageStr = [NSString stringWithFormat:@"2.0_writeMusic_btn%02d",i];
        
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        
        if (i == 1) {
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_btn01"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_play"] forState:UIControlStateNormal];
            
        }
        
        if (i == 2) {
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_btn02"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_recording"] forState:UIControlStateSelected];
        }
        
        btn.tag = i + kButtonTag;
        
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btns addObject:btn];
        
        [bottomView addSubview:btn];
    }
    
    
    self.waveform = [[NSWaveformView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 220, ScreenWidth, 84)];
    
    self.waveform.backgroundColor = [UIColor whiteColor];
    self.waveform.timeScrollView.userInteractionEnabled = NO;
    [self.view addSubview:self.waveform];
    
    /*self.DeviceMusicWaveView = [[DeviceMusicWave alloc] initWithFrame:CGRectMake(0, ScreenHeight - 200, ScreenWidth, 64)];
    self.DeviceMusicWaveView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.DeviceMusicWaveView];*/
    
   /* self.slideBarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_writeMusic_slideBar"]];
    
    self.slideBarImage.frame = CGRectMake(self.view.width * 0.5 - 3, self.waveform.y - 2, 6, 69);
    
    [self.view addSubview:self.slideBarImage];*/
    
    
    totalTimeLabel = [[UILabel alloc] init];
    
    totalTimeLabel.font = [UIFont systemFontOfSize:10];
    
    totalTimeLabel.text = [NSString stringWithFormat:@"/%@",[NSTool stringFormatWithTimeLong:musicTime]];
    [totalTimeLabel setTextColor:[UIColor lightGrayColor]];

    [self.view addSubview:totalTimeLabel];
    
    [totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-5);
        
        make.bottom.equalTo(bottomView.mas_top).offset(-5);
        
    }];
    
    
    self.timeLabel = [[UILabel alloc] init];
    
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    
    self.timeLabel.text = [NSString stringWithFormat:@"00:00"];
    [self.timeLabel setTextColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(totalTimeLabel.mas_left);
        
        make.bottom.equalTo(bottomView.mas_top).offset(-5);
        
    }];
    
    
    titleText = [[UITextField alloc] init];
    
    titleText.textAlignment = NSTextAlignmentCenter;
    
//    titleText.enabled = NO;
    
    [self.view addSubview:titleText];
    
    [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(15);
        
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.width.mas_equalTo(self.view.width - 100);
    }];
    
    NSDrawLineView *dashed = [[NSDrawLineView alloc] init];
    
    [self.view addSubview:dashed];
    
    [dashed mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleText.mas_bottom).offset(10);
        
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.width.mas_equalTo(self.view.width - 100);
        
        make.height.mas_equalTo(1);
    }];
    
    
    lyricView = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 50, self.view.width, self.view.height - 280)];
    
    lyricView.lyricText.autoAdaptKeyboard = YES;
    
    lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
    
    lyricView.lyricText.delegate = self;
    
    lyricView.lyricText.showsVerticalScrollIndicator = NO;
    
    
    [self.view addSubview:lyricView];

    //设置引导页
    [self setupGuideView];
    
    timerImgView = [UIImageView new];
    
    timerImgView.width = ScreenWidth/4.0f;
    
    timerImgView.height = ScreenWidth/4.0f;
    
    timerImgView.x = ScreenWidth/2-timerImgView.width/2.0 ;
    
    timerImgView.centerY = self.view.height/3;
    
    
    [self.view addSubview:timerImgView];
    
}


#pragma mark - 五个按钮点击
- (void)bottomBtnClick:(UIButton *)btn {

    self.appDelete = [UIApplication sharedApplication].delegate;
    UIButton *recordBtn = self.btns[2];
//     clickValue = [self buttonClickedValue:btn];
    if (btn.tag == kButtonTag + 0) {
        /*
        if ([self.player isPlaying]) {
            //[HudView showView:self.navigationController.view string:@"请先停止录音"];
            [[NSToastManager manager ] showtoast:@"请先停止录音"];
            
            return;
        }
         */
        if (self.YCPlayer.playStatus == YCPlayerPlayPlaying) {
            [[NSToastManager manager ] showtoast:@"请先停止录音"];
            
            return;
        }
        NSUserDefaults *recordText = [NSUserDefaults standardUserDefaults];
        [recordText setObject:titleText.text forKey:@"recordTitle"];
        [recordText setObject:lyricView.lyricText.text forKey:@"recordLyric"];
        [recordText synchronize];
        NSAccompanyListViewController *accompanyList = [[NSAccompanyListViewController alloc] init];
        [NSSingleTon viewFrom].viewTag = @"writeView";
        
        [self.navigationController pushViewController:accompanyList animated:YES];
        
        
    } else if (btn.tag == kButtonTag + 2) {
        
        self.waveform.timeScrollView.userInteractionEnabled=NO;

//        if (self.player.currentTime == 0) {
//            [self.waveform.waveView removeAllPath];
//        }
        if (![NSTool canRecord]) {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"未获取麦克风权限" message:@"请进入 设置-隐私-麦克风，获取麦克风权限后重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
            [alertview show];
            return;
        }
        
//        [self.waveLink setPaused:NO];

        if ([self.player3 isPlaying] ) {
            [[NSToastManager manager ] showtoast:@"先暂停试听"];

            //[HudView showView:self.navigationController.view string:@"先暂停试听"];
            return;
        }
        
        if (!btn.selected) {
            
            NSURL *url = [NSURL fileURLWithPath:[LocalAccompanyPath stringByAppendingPathComponent:[hotMp3Url lastPathComponent]]];
            if (downloadFinish) {
                if (!self.YCPlayer) {
                    self.YCPlayer = [[YCMusicPlayer alloc] init];;
                    self.YCPlayer.delegate = self;
                    totalTimeLabel.text = [NSString stringWithFormat:@"/%02d:%02d",(int)self.YCPlayer.duration / 60, (int)self.YCPlayer.duration % 60];
                    self.accompanyPCMPath = [self.YCPlayer setPcmFilePath:@"AccompanyPCM/accompany.pcm"];
                    
                }
                /*
                if (!self.player) {
                    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                    self.player.enableRate = YES;
                    self.player.rate = 1.0;
                    self.player.delegate = self;
                    totalTimeLabel.text = [NSString stringWithFormat:@"/%02d:%02d",(int)self.player.duration / 60, (int)self.player.duration % 60];
                    [self.player prepareToPlay];
                    
                }
                 */
//                lyricView.lyricView.scrollEnabled = NO;
//                lyricView.lyricText.userInteractionEnabled = NO;
                [self addTimer];
                
                self.isPlay = NO;
                
                timerNumRecorder =timerNumRecorder_temp;
                timerNum=   timerNumRecorder;
                
                if (self.appDelete.isHeadset) {
                    
                    plugedHeadset=YES;
                    
                }else if(!self.appDelete.isHeadset){
                    
                    plugedHeadset=NO;
                    
                }
                
                btn.selected = !btn.selected;
            } else {
                
                [[NSToastManager manager] showtoast:@"正在初始化..."];
            }
            
        } else {
            
            [self pauseRecorder];
            
        }
        
         curtime3=0;
         curtime2=0;
         timerNumPlay_temp=0;
        
        
    } else if (btn.tag == kButtonTag + 1) {

        self.waveform.timeScrollView.userInteractionEnabled=NO;
        
        if (recordBtn.selected) {
            
            [[NSToastManager manager ] showtoast:@"请先停止录音"];
            
            return;
        }
        if (self.wavFilePath == nil) {
            
            [[NSToastManager manager ] showtoast:@"还未开始录音"];
            
            return;
            
        }
        
        if (!btn.selected) { //回听
            
            [self.waveLink setPaused:NO];
            [self.link setPaused:NO];
            
            [[NSToastManager manager ] showtoast:@"开始试听"];
            
            timerNumPlay = timerNumPlay_temp;
            timerNum = timerNumPlay;
            
            self.isPlay = YES; //YES
            
             NSURL *url = [NSURL fileURLWithPath:[LocalAccompanyPath stringByAppendingPathComponent:[hotMp3Url lastPathComponent]]];
            /**
             *  有耳机播放伴奏
             */
            if (plugedHeadset) {
                [self playAccompanyWithUrl:url withTime:curtime3];
            }
            lyricView.lyricView.scrollEnabled = NO;
            lyricView.lyricText.userInteractionEnabled = NO;
            [self playsound:self.wavFilePath time:curtime3];

        }else{//没回听
            self.waveform.timeScrollView.userInteractionEnabled=YES;
            lyricView.lyricText.userInteractionEnabled = YES;
            lyricView.lyricView.scrollEnabled = YES;
//            curtime2=   self.player2.currentTime;
            curtime3=   self.player3.currentTime;
            timerNumPlay_temp=curtime3;
            
            [self pausePlaysound:self.player2];
            [self pausePlaysound:self.player3];
            [self.link setPaused:YES];
            [self.waveLink setPaused:YES];
            self.waveform.waveView.drawRectStyle = WaveViewDrawRectStyleChangeColor;
            [self.waveform.waveView setNeedsDisplay];
            
        }
        btn.selected = !btn.selected;//－－no
        
    } else if (btn.tag == kButtonTag + 3) {//
        
        if (recordBtn.selected) {

            [[NSToastManager manager ] showtoast:@"先停止录音"];

            return;

        }
        if ([self.player3 isPlaying]) {

            [[NSToastManager manager ] showtoast:@"先停止试听"];

            return;
            
        }

        if (self.wavFilePath == nil) {
           // [HudView showView:self.navigationController.view string:@"还未开始录音"];
            [[NSToastManager manager ] showtoast:@"还未开始录音"];


        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请确认操作" message:@"请确认是否重新录音？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新录音", nil];
            
            [alert show];
        }
        
        
    } else if (btn.tag == kButtonTag + 4) {
        if (recordBtn.selected) {
            //[HudView showView:self.navigationController.view string:@"请先停止录音"];
            [[NSToastManager manager ] showtoast:@"请先停止录音"];
            
            return;
        }
        [self importLyricClick:nil];
    }
    
}

- (void)resetButton{
    UIButton* btn1 =   self.btns[1];
    UIButton* btn2 =   self.btns[2];
    
    btn1.selected=NO;;
    btn2.selected=NO;;
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self clearRecord];
        UIButton* btn = self.btns[2];
        btn.userInteractionEnabled = YES;
    }

}
- (void)playAccompanyWithUrl:(NSURL *)url withTime:(NSTimeInterval)time{
//    if (!self.player2) {
        self.player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.player2.currentTime = time;
        self.player2.enableRate = YES;
        self.player2.rate = 1.0;
        self.player2.delegate = self;
        totalTimeLabel.text = [NSString stringWithFormat:@"/%02d:%02d",(int)self.YCPlayer.duration  / 60, (int)self.YCPlayer.duration  % 60];
        //                self.player.meteringEnabled=YES;
        [self.player2 prepareToPlay];
        
//    }
    [self.player2 play];
}
- (void)clearRecord{
    [self resetButton];
    self.timeLabel.text = @"00:00";
    timerNum=0;
    totalTime = 0;
    timerNumRecorder=0;
    timerNumRecorder_temp=0;
    timerNumPlay=0;
    timerNumPlay_temp=0;
    curtime2=0;
    curtime3=0;

    [self.waveform.timeScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.waveform.waveView.waveDistance=0;
    self.wavFilePath = nil;
    [self.link setPaused:YES];
    [self.waveLink setPaused:YES];
//    [self stopPlaysound:self.player];
    [self.YCPlayer stop];
    [self stopPlaysound:self.player2];
    [self stopPlaysound:self.player3];
    [self stopRecorder];

    self.waveform.waveView.desibelNum=0;
    [self.waveform.waveView removeAllPath];
    
    [self removeSoundRecorder];
    
}


- (void)importLyricClick:(UIBarButtonItem *)import {
    
    if (self.coWorkModel.lyrics.length) {
        [[NSToastManager manager] showtoast:@"合作歌曲不能使用歌词模板哦 ~"];
        return;
    }
    
    NSImportLyricViewController *importLyric = [[NSImportLyricViewController alloc] init];
    importLyric.delegate = self;
    [self.navigationController pushViewController:importLyric animated:YES];
    
}
/*
- (void)showPromptView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"歌曲正在上传，请稍后...", @"HUD loading title");
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 10);//MBProgressMaxOffset);

}
 */
- (void)nextClick:(UIBarButtonItem *)next {
    UIButton *recordBtn = self.btns[2];
    if ([self.player3 isPlaying] ||[self.player2 isPlaying]) {
        [self bottomBtnClick:[self.view viewWithTag:kButtonTag +1]];
        [self.player2 stop];
        [self.player3 stop];
    }
    
    if (recordBtn.selected) {
        [HudView showView:self.navigationController.view  string:@"请先停止录音"];
        return;
    }

    if (self.wavFilePath == nil) {
        [HudView showView:self.navigationController.view  string:@"还未开始录音"];
        return;
    }
    
    if (titleText.text.length == 0) {
        [HudView showView:self.navigationController.view string:@"歌词标题不能为空"];
    }else{
        
        

        
        if (JUserID) {
            
            //戴耳机了
            if (plugedHeadset) {
                NSSoundEffectViewController *soundEffectVC = [[NSSoundEffectViewController alloc] init];
                NSDictionary *dict;
                
                mp3URL = dict[@"data"][@"mp3URL"];
                [self.dict setValue:titleText.text forKey:@"lyricName"];
                [self.dict setValue:lyricView.lyricText.text forKey:@"lyric"];
                [self.dict setValue:[NSString stringWithFormat:@"%ld",hotId] forKey:@"hotID"];
                [self.dict setValue:[NSNumber numberWithBool:plugedHeadset] forKey:@"isHeadSet"];
                
                soundEffectVC.parameterDic = self.dict;
                //波形图的高度和位置
                soundEffectVC.locationArr = [NSMutableArray arrayWithArray: self.waveform.waveView.locationsArr];
                soundEffectVC.heightArray = self.waveform.waveView.heightArr;
                soundEffectVC.musicTime = totalTime;
                soundEffectVC.isLyric = NO;
                soundEffectVC.mp3URL = dict[@"data"][@"mp3URL"];
                soundEffectVC.mp3File = self.mp3Path;
                
                NSUserDefaults *recordText = [NSUserDefaults standardUserDefaults];
                [recordText setObject:titleText.text forKey:@"recordTitle"];
                [recordText setObject:lyricView.lyricText.text forKey:@"recordLyric"];
                [recordText synchronize];
                soundEffectVC.coWorkModel = self.coWorkModel;
                
                //传入录音和伴奏（如果插了耳机） 链接
                soundEffectVC.accompanyPCMPath = self.accompanyPCMPath;
                soundEffectVC.recordPCMPath = self.wavFilePath;
                [self.navigationController pushViewController:soundEffectVC animated:YES];
            }else{
                
                //没戴耳机直接上传服务器 然后跳转发布
                self.alertView = [UIAlertController alertControllerWithTitle:nil message:@"歌曲正在上传，请稍后..." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    return;
                }];
                
                [self.alertView addAction:action1];
                [self presentViewController:self.alertView animated:YES completion:nil];
                
                [self.link setPaused:YES];
                //            [self pauseDevides];
                
                [self uploadMusic];
                
            }
            
//             self.public = [[NSPublicLyricViewController alloc] initWithLyricDic:self.dict withType:NO];
//            self.public.isLyric=NO;
            
             
             } else {
             
                 NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
             
                 [self presentViewController:loginVC animated:YES completion:nil];
             }

   
    
    }
}

#pragma mark -OptionMusic
-(void)tuningMusicWithCreateType:(NSString *)createType andHotId:(long)hotId_  andUseHeadSet:(BOOL)userHeadSet andMusicUrl :(NSString *)musicURl
{
    self.requestType = NO;
    
    self.requestParams = @{
                           @"hotid":[NSNumber numberWithLong:hotId_],
                           @"uid":JUserID,
                           @"token":LoginToken,
                           @"useheadset":[NSNumber numberWithInt:userHeadSet],
                           @"createtype":createType,
                           @"musicurl":musicURl,
                           @"effect":@(0)};
    self.requestURL = tunMusicURL;

}

#pragma mark -overriderActionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    WS(wSelf);
    //    [self.maskView removeFromSuperview];
//    [ProgressView removeFromSuperview];
    if (!parserObject.success) {
        if ([operation.urlTag isEqualToString:tunMusicURL]) {
            NSTunMusicModel * tunMusic = (NSTunMusicModel *)parserObject;
            mp3URL = tunMusic.tunMusicModel.MusicPath;
            
            [self.dict setValue:titleText.text forKey:@"lyricName"];
            
            [self.dict setValue:lyricView.lyricText.text forKey:@"lyric"];
            
            [self.dict setValue:[NSString stringWithFormat:@"%ld",hotId] forKey:@"hotID"];
            [self.dict setValue:mp3URL forKey:@"mp3URL"];
            [self.dict setValue:@(plugedHeadset) forKey:@"isHeadSet"];
            self.publicController = [[NSPublicLyricViewController alloc] initWithLyricDic:self.dict withType:NO];
            self.publicController.mp3URL = mp3URL;
            self.publicController.mp3File = self.mp3Path;

            if (self.aid.length) {
                self.publicController.aid = self.aid;
            }
            NSUserDefaults *recordText = [NSUserDefaults standardUserDefaults];
            [recordText setObject:titleText.text forKey:@"recordTitle"];
            [recordText setObject:lyricView.lyricText.text forKey:@"recordLyric"];
            [recordText synchronize];
            [self.alertView dismissViewControllerAnimated:YES completion:^{
                wSelf.publicController.coWorkModel = wSelf.coWorkModel;
                [wSelf.navigationController pushViewController:wSelf.publicController animated:YES];
//
            }];

//            self.public.isLyric=NO;
//
//            self.public.mp3File = self.mp3Path;
            
        }
    }
}
//倒计时
- (void)addTimer {
    
    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    
    [timer invalidate];
    
    timer = nil;
}

- (void)timerAction {
    timerImgView.hidden = NO;
    num--;
    timerImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"2.0_%d",num]];
    
    if (num == -1) {
        /*
        timerImgView.hidden = YES;
        [self.waveLink setPaused:NO];
        [self.link setPaused:NO];
        [self.player play];
        [self startRecorder];
        num = 4;
        [self removeTimer];
         */
        if (self.YCPlayer.playStatus == YCPlayerPlayPaused) {
            [self.YCPlayer resume];
            
        }else{
            NSString *url = [LocalAccompanyPath stringByAppendingPathComponent:[hotMp3Url lastPathComponent]];
            [self.YCPlayer playWithUrl:url];
        }
    }
}

/**
 *  添加定时器
 */
- (void)addLink {
    
    if (!self.link)
    {
        
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionTiming)];
        
        self.link.frameInterval=frameInterval;

        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)addWaveLink { 
    
    if (!self.waveLink)
    {
        
        self.waveLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTimeView)];
        
        self.waveLink.frameInterval=frameInterval;
        [self.waveLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}


/**
 *  移除定时器
 */
- (void)removeLink {
    
    if (self.link) {
        [self.link invalidate];
        self.link = nil;
    }
}
- (void)removeWaveLink {
    
    if (self.waveLink) {
        [self.waveLink invalidate];
        self.waveLink = nil;
    }
    
}


- (void)stopLink{
    [self.link setPaused:YES];

}

//- (float)updateMeters{
//    
//    if ([self.recorder averagePowerForChannel:0] < -20) {
//        return -45.0;
//    }
//    float f = [self.recorder averagePowerForChannel:0];
//    return f;
//}

- (void)actionTiming {

    
    timerNum += frameInterval/60.0;
//    NSLog(@"time : %f",timerNum);
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
    

    //分贝数
    if (!self.isPlay) {
        
        decilCount = [self decibels];
        if (isnan(decilCount)) {
            return;
        }
        //如果count是nan则不添加波形
        totalTime += frameInterval/60.0;

            dispatch_async(dispatch_get_main_queue(), ^{

                
                [self.waveform waveViewCreateNewWaves];
            });
    }else{

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.waveform waveViewChangingWavesColor];
            
        });
    }
}
- (void)scrollTimeView{
    
    self.waveform.waveView.waveDistance =speed*timerNum;
    self.waveform.waveView.desibelNum =(fabs(decilCount));

//    if ([self.player isPlaying]) {
//        distantKeyPath=self.waveform.timeScrollView.contentOffset.x;
//    }
    if (self.YCPlayer.playStatus == YCPlayerPlayPlaying) {
        distantKeyPath=self.waveform.timeScrollView.contentOffset.x;
        
    }
    [self.waveform.timeScrollView setContentOffset:CGPointMake(self.waveform.waveView.waveDistance, 0) animated:NO];
//    drawNum++;
}

- (void)changeColor{
    
    
}

- (void)initMusicWave{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:161];
    NSMutableArray* arrWave = [NSMutableArray arrayWithCapacity:161];
    self.descibelArray = [NSArray array];
    
    for (NSUInteger i=0; i<161; i++) {
        [arr addObject:[NSNumber numberWithInteger:i]];
        CGFloat j = i*20/160;
        [arrWave addObject:[NSNumber numberWithFloat:j]];
    }
    self.descibelArray = [[arr reverseObjectEnumerator] allObjects];
    self.descibelDictionary = [NSMutableDictionary dictionaryWithCapacity:161];
    
    for (int i=0; i<161; ++i) {
        NSUInteger key =[[self.descibelArray objectAtIndex:i] integerValue];
        [self.descibelDictionary  setValue:[arrWave objectAtIndex:i] forKey:[NSString stringWithFormat:@"%ld",(unsigned long)key]];

    }
    
}

- (void)disPlayTimeLabel{
    
}

#pragma mark -setter && getter
//-(void)setAccompanyModel:(NSAccommpanyModel *)accompanyModel
//{
//    _accompanyModel = accompanyModel;
//
//}

- (void)selectLyric:(NSString *)lyrics withMusicName:(NSString *)musicName {
    
    NSUserDefaults *recordText = [NSUserDefaults standardUserDefaults];
    [recordText setObject:musicName forKey:@"recordTitle"];
    [recordText setObject:lyrics forKey:@"recordLyric"];
    [recordText synchronize];
}

#pragma mark - 上传音频
- (void)uploadMusic{
    WS(wSelf);
    //后台执行mp3转换和上传
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self recorderFileToMp3WithType:TrueMachine filePath:self.wavFilePath];
//        NSData *data = [NSData dataWithContentsOfFile:self.mp3Path];
        self.data=[NSData dataWithContentsOfFile:[self recorderFileToMp3WithType:TrueMachine filePath:self.wavFilePath]];
        
//        NSArray *array = [self.mp3Path componentsSeparatedByString:@"/"];
        // 1.创建网络管理者
       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString* url =[NSString stringWithFormat:@"%@/%@",[NSTool obtainHostURL],uploadMp3URL];
        [manager POST:url parameters:nil constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:self.data name:@"file" fileName:@"abc.mp3" mimeType:@"audio/mp3"];
            
        } success:^void(NSURLSessionDataTask * task, id responseObject) {
            
            NSDictionary *dict;
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                dict = [[NSHttpClient client] encryptWithDictionary:responseObject isEncrypt:NO];
                
            }
            if ([dict[@"code"] integerValue] == 200) {
                if (!plugedHeadset) {
                    [self tuningMusicWithCreateType:@"hot" andHotId:hotId andUseHeadSet:plugedHeadset andMusicUrl:dict[@"data"][@"mp3URL"]];
                } else {
                    
                    [self.alertView dismissViewControllerAnimated:YES completion:^{
                        NSSoundEffectViewController *soundEffectVC = [[NSSoundEffectViewController alloc] init];
                        
                        mp3URL = dict[@"data"][@"mp3URL"];
                        [self.dict setValue:titleText.text forKey:@"lyricName"];
                        [self.dict setValue:lyricView.lyricText.text forKey:@"lyric"];
                        [self.dict setValue:[NSString stringWithFormat:@"%ld",hotId] forKey:@"hotID"];
                        [self.dict setValue:[NSNumber numberWithBool:plugedHeadset] forKey:@"isHeadSet"];
                        
                        soundEffectVC.parameterDic = self.dict;
                        //波形图的高度和位置
                        soundEffectVC.locationArr = [NSMutableArray arrayWithArray: self.waveform.waveView.locationsArr];
                        soundEffectVC.heightArray = self.waveform.waveView.heightArr;
                        soundEffectVC.musicTime = totalTime;
                        soundEffectVC.isLyric = NO;
                        soundEffectVC.mp3URL = dict[@"data"][@"mp3URL"];
                        soundEffectVC.mp3File = self.mp3Path;
                        
                        NSUserDefaults *recordText = [NSUserDefaults standardUserDefaults];
                        [recordText setObject:titleText.text forKey:@"recordTitle"];
                        [recordText setObject:lyricView.lyricText.text forKey:@"recordLyric"];
                        [recordText synchronize];
                        soundEffectVC.coWorkModel = self.coWorkModel;
                        [wSelf.navigationController pushViewController:soundEffectVC animated:YES];
                    }];
                }
            } else {
                [self.alertView dismissViewControllerAnimated:YES completion:^{
                    [[NSToastManager manager] showtoast:@"上传失败"];
                }];
            }
            //self.wavFilePath = nil;
        } failure:^void(NSURLSessionDataTask * task, NSError * error) {
            // 请求失败
            [self.alertView dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            //self.next.enabled = YES;
        }];
        
        
        
    });

}


- (void)doSomeWork {
    // Simulate by just waiting.
    static int i=0;
    while (1) {
        ++i;
        if (mp3URL || (i == 8000)) {
            break;
        }
    }
    //sleep(7.);
}


//- (int)buttonClickedValue:(UIButton*)btn{
//    if (btn == self.btns[1]) {
//        return 1;
//    }else if(btn == self.btns[2]){
//        return 2;
//    }else if(btn == self.btns[3]){
//        return 3;
//    }
//    return -1;
//}



- (void)nextStep:(NSNotification*)userInfo{
    
    [self.alertView dismissViewControllerAnimated:NO completion:nil];
    self.publicController.coWorkModel = self.coWorkModel;
    [self.navigationController pushViewController:self.publicController animated:YES];

}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.waveform.timeScrollView) {
        timerNum=scrollView.contentOffset.x/speed;
        timerNumPlay_temp = timerNum;
        curtime3 =timerNum;
        curtime2 =timerNum;
        self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
        
        self.waveform.waveView.waveDistance = scrollView.contentOffset.x;
        [self.waveform waveViewChangingWavesColor];
        
        if (scrollView.contentOffset.x >= ([self.waveform.waveView.locationsArr.lastObject floatValue] - self.waveform.middleLineV.x)) {
            [self audioWorkAuditionEndProcess];
            
        }
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.waveform.timeScrollView) {
        
        //只有在手动滑动的时候波形图动态变化
        UIButton *playBtn = self.btns[1];
        UIButton *recordBtn = self.btns[2];
        if (!recordBtn.selected && !playBtn.selected) {
            self.waveform.waveView.waveDistance = scrollView.contentOffset.x;
            
            [self.waveform waveViewChangingWavesColor];
            
            
        }
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.waveform.timeScrollView) {
        if (decelerate) {
            
        }else{
            timerNum=scrollView.contentOffset.x/speed;
            timerNumPlay_temp = timerNum;
            curtime3 =timerNum;
            //        curtime2 =timerNum;
            
            self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
            self.waveform.waveView.waveDistance = scrollView.contentOffset.x;
            [self.waveform waveViewChangingWavesColor];
            
            //滑动到最后设置为播放完
            if (scrollView.contentOffset.x >= ([self.waveform.waveView.locationsArr.lastObject floatValue] - self.waveform.middleLineV.x)) {
                [self audioWorkAuditionEndProcess];
                
            }
            
        }
    }
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView

{
    // 计算字数
    UITextRange *selectedRange = [textView markedTextRange];
    // 获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    // 如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSRange beforeRange = textView.selectedRange;

    [self setupAttributesWithTextView:textView ContentStr:textView.text];
    
    NSRange afterRange = textView.selectedRange;
    if (afterRange.location != beforeRange.location) {
        textView.selectedRange = beforeRange;
    }
    
}


- (void)setupAttributesWithTextView:(UITextView *)textView ContentStr:(NSString *)contentStr{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.paragraphSpacing = 8;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:contentStr attributes:attributes];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
    
}
/**
 *  抠圆
 */
- (void)setupRoundMaskToButton:(UIButton *)button withPoint:(CGPoint)point radius:(CGFloat)radius{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path = path.CGPath;
    
    [button.layer setMask:shapeLayer];
}
#pragma mark - lazy init

- (UIButton *)guideBanzouButton{
    if (!_guideBanzouButton) {
        _guideBanzouButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            btn.backgroundColor = [UIColor colorWithRed:8/255.0 green:4/255.0 blue:3/255.0 alpha:0.6];
            UIButton *banzouButton = [_bottomView viewWithTag:1 + kButtonTag];
            CGFloat imagePointX = banzouButton.imageView.width/2.0 + banzouButton.imageView.x;
            CGFloat imageCenterY = banzouButton.centerY + ScreenHeight - 72 ;
            [self setupRoundMaskToButton:btn withPoint:CGPointMake(imagePointX, imageCenterY) radius:23];
            
            CGFloat imageWidth = (210/375.0) * ScreenWidth;
            CGFloat imageHeight = imageWidth * 438/419;
            CGFloat imageMinX = banzouButton.imageView.width + banzouButton.imageView.x + 5;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageMinX, ScreenHeight - 38 - imageHeight, imageWidth, imageHeight)];
            imageView.image = [UIImage imageNamed:@"guide_banzou"];
            [btn addSubview:imageView];

        } action:^(UIButton *btn) {
            [btn removeFromSuperview];
            [self.navigationController.view addSubview:self.guideDaoruButton];
        }];
    }
    return _guideBanzouButton;
}

- (UIButton *)guideDaoruButton{
    if (!_guideDaoruButton) {
        _guideDaoruButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            btn.backgroundColor = [UIColor colorWithRed:8/255.0 green:4/255.0 blue:3/255.0 alpha:0.6];
            UIButton *daoruButton = [_bottomView viewWithTag:4 + kButtonTag];
            CGFloat imagePointX = ScreenWidth*4.0/5.0f + daoruButton.imageView.width/2.0 + daoruButton.imageView.x;
            CGFloat imageCenterY = daoruButton.centerY + ScreenHeight - 72 ;

            [self setupRoundMaskToButton:btn withPoint:CGPointMake(imagePointX, imageCenterY) radius:23];
            
            CGFloat imageWidth = (220/375.0) * ScreenWidth
            /**
             根据图片比例计算
             
             */;
            CGFloat imageHeight = imageWidth * 439/433;
            CGFloat imageMaxX = (ScreenWidth/5.0f - daoruButton.imageView.x + 5);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - imageMaxX - imageWidth, ScreenHeight - 38 - imageHeight, imageWidth, imageHeight)];
            imageView.image = [UIImage imageNamed:@"guide_geci"];
            [btn addSubview:imageView];
            
            
        } action:^(UIButton *btn) {
            [btn removeFromSuperview];
            [self downloadAccompanyWithUrl:hotMp3Url];
        }];
    }
    return _guideDaoruButton;
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"pausePlayer"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"clearRecordNotification"];
    [self removeObserver:self forKeyPath:@"distantKeyPathTemp" context:nil];
    [self removeObserver:self forKeyPath:AVAudioSessionInterruptionNotification context:nil];
}
@end
