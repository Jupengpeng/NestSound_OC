//
//  NSWriteMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "NSWriteMusicViewController.h"
#import "NSDrawLineView.h"
#import "NSLyricView.h"
#import "NSOptimizeMusicViewController.h"
#import "NSImportLyricViewController.h"
#import "XHSoundRecorder.h"
#import "NSAccommpanyListModel.h"
#import "NSPlayMusicTool.h"
#import "DeviceMusicWave.h"
#import <AVFoundation/AVFoundation.h>
#import "NSPublicLyricViewController.h"
#import "NSTunMusicModel.h"
#import "NSLoginViewController.h"
#import "NSWaveformView.h"
#import "NSPlayMusicViewController.h"
#import "NSDownloadProgressView.h"
#import "NSLoginViewController.h"
#import "AFHTTPSessionManager.h"
#import "lame.h"
#import "MBProgressHUD.h"
#import "HudView.h"


CGFloat count;

Boolean plugedHeadset;
static CGFloat timerNum=0;

@interface CenterLine : UIView

@end

@implementation CenterLine

#pragma mark -override drawRect
-(void)drawRect:(CGRect)rect {
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    
    [path addLineToPoint:CGPointMake(self.width, self.height)];
    
    [path setLineWidth:self.width];
    
    [[UIColor hexColorFloat:@"ff833f"] setStroke];
    
    [[UIColor hexColorFloat:@"ff833f"] setFill];
    
    [path stroke];
}

@end


@interface NSWriteMusicViewController () <UIScrollViewDelegate, ImportLyric, AVAudioPlayerDelegate,UIAlertViewDelegate, AVAudioRecorderDelegate> {
    
    UILabel *totalTimeLabel;
    float timerNumRecorder;
    float timerNumRecorder_temp;
    float timerNumPlay;
    float timerNumPlay_temp;
    int clickValue;
    CGFloat timerNumTemp;
    CGFloat speed;

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
    NSUInteger drawNum;

    BOOL stopScroll;
    NSDownloadProgressView *ProgressView;//BoxDismiss
    
}

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

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *player2;
@property (nonatomic, strong) AVAudioPlayer *player3;
@property (nonatomic, strong) NSMutableArray *playerArray;

@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, weak)  UIBarButtonItem *next;

@property (nonatomic, copy) NSString *mp3Path;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *wavFilePath;
@property (nonatomic, strong)NSPublicLyricViewController* public;
@property (nonatomic, strong) NSWaveformView *waveform;

@property (nonatomic, strong)AppDelegate* appDelete;
@property (nonatomic, assign) int lineNum;
@property (nonatomic, assign) int lineNum2;
@property (nonatomic, assign) NSTimeInterval playerTime;

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, assign) BOOL isPlay2;

@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic,strong) UIAlertController *alertView;

@property (nonatomic, strong) UIView *maskView;
@end

@implementation NSWriteMusicViewController

////////以下为录音begin///

- (AVAudioRecorder *)newRecorder {
    
    NSDictionary *settings = @{AVSampleRateKey : @(44100.0), AVNumberOfChannelsKey : @(1)};
    
    /*NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                                                            [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                                                           [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                                                            [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                                                           nil];*/
    
    if (!_recorder) {
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        
        NSString * currentTimeString = [formatter stringFromDate:date];
        
        self.fileName = currentTimeString;
        
        NSString *wavPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        
        wavPath = [wavPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",currentTimeString]];
        
        self.wavFilePath = wavPath;
        NSURL *url = [NSURL URLWithString:wavPath];
        NSError *error = nil;
        
        
        AVAudioSession* session = [AVAudioSession sharedInstance];
        
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        
        [session setActive:YES error:nil];
        
        if(error){
            
            NSLog(@"录音错误说明%@", [error description]);
        }
        
        
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
        
        _recorder.meteringEnabled = YES;
        
        _recorder.delegate = self;
    }
    
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
        
        NSFileManager* f = [NSFileManager defaultManager];
        long long l = [[f attributesOfItemAtPath:self.wavFilePath error:nil] fileSize];
        
    }
    
}

//暂停录音
- (void)pauseRecorder {
    
    if ([self.recorder isRecording])
    {
        
        [self.recorder pause];
        
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
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
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
    if (self.player) {
        [self.player pause];
    }
    if (self.recorder) {
        [self.recorder pause];
    }
    
    
}

//分贝数
- (CGFloat)decibels {
    /*
    [self.recorder updateMeters];
    
    self.recorder.meteringEnabled = YES;
//    CGFloat decibels = [self.recorder peakPowerForChannel:0];
    CGFloat decibels = [self.recorder averagePowerForChannel:0];

    return  decibels;
    */
    [self.recorder updateMeters];
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -60.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [self.recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = -0.0f;
        
        NSLog(@"AAAAAA%f",decibels);
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
        
        NSLog(@"BBBBBB%f",decibels);
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        NSLog(@"CCCCCCCCC%f",decibels);
        level = powf(adjAmp, 1.0f / root);
    }
    return level * 60;
}

- (CGFloat)playerDecibels:(AVAudioPlayer*)player {
    /*
    [player updateMeters];
    
    self.recorder.meteringEnabled = YES;
    
    CGFloat decibels = [player peakPowerForChannel:0];
    
    return decibels;
     */
    [player updateMeters];
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -60.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [player peakPowerForChannel:0];
    
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


//伴奏播放完毕的回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    timerNum=0;

    UIButton* btn = self.btns[1];
    if (player == self.player) {
        btn.selected = NO;
        [self.link setPaused:YES];
        timerNumRecorder=0;
        timerNumRecorder_temp=0;
        [self stopPlaysound:player];
        [self.waveLink setPaused:YES];


        
    }
    if (player == self.player3 || (player == self.player2)) {
        btn.selected = NO;

        timerNumPlay_temp=0;
        timerNumPlay=0;
        curtime3=0;
        curtime2=0;
        [self.waveLink setPaused:YES];
        [self.link setPaused:YES];
        self.waveform.timeScrollView.userInteractionEnabled=YES;

        
        [self stopPlaysound:self.player3];
        [self stopPlaysound:self.player2];
        
        
    }
    
   [self.waveform.timeScrollView setContentOffset:CGPointMake(timerNumTemp*speed, 0) animated:NO];
    
}

//播放被打断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([self.player isPlaying]||[self.player2 isPlaying]||[self.player3 isPlaying]) {
        return;
    }

    CGFloat distant = [[change objectForKey:@"new"] floatValue];

    if (distant> distantKeyPath) {
        [self.waveform.timeScrollView setContentOffset:CGPointMake(speed*timerNumTemp, 0) animated:NO];
        
    }
    
    [self changeScrollViewColor];

   
    if ([self.waveform.timeScrollView isDragging]) {
        [self changeScrollViewColor];
    }
}

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
- (void)recorderFileToMp3WithType:(Type)type filePath:(NSString *)filePath  {
    NSFileManager *manager = [NSFileManager defaultManager];
    long long l = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    if (!filePath ||l==0) {
        return;
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
        self.mp3Path = mp3FilePath;
        long long l1  = [[ manager attributesOfItemAtPath:filePath error:nil] fileSize];
        long long l2  = [[ manager attributesOfItemAtPath:mp3FilePath error:nil] fileSize];
        
        NSLog(@"%@转换前＝%lld,%@转换MP3后＝%lld",filePath,l1,mp3FilePath,l2);
        
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



- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelete = [[UIApplication sharedApplication] delegate];
    self.session = [AVAudioSession sharedInstance];
    self.wavFilePath = nil;
    self.mp3Path=nil;
    timerNum=0;
    drawCount=0;
    stopScroll=NO;
     timerNumRecorder=0;
     timerNumRecorder_temp=0;
     timerNumPlay=0;
     timerNumPlay_temp=0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextStep:) name:NextStep object:nil];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick:)];
    
    self.navigationItem.rightBarButtonItem = next;
    
    
//    UIBarButtonItem *importLyric = [[UIBarButtonItem alloc] initWithTitle:@"导入歌词" style:UIBarButtonItemStylePlain target:self action:@selector(importLyricClick:)];
    
//    NSArray *array = @[next, importLyric];
    
//    self.navigationItem.rightBarButtonItems = array;
    
    [self setupUI];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBackClick:)];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    [self.view addGestureRecognizer:tap];
    
    [self addLink];
    [self.link setPaused:YES];
    
    [self addWaveLink];
    [self.waveLink setPaused:YES];

    self.waveform.timeScrollView.delegate =self;
  
    
    [self initMusicWave];

    [self addObserver:self forKeyPath:@"distantKeyPathTemp" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    speed = self.waveform.rect.size.width/SECOND_LONG;

}



- (void)tapClick:(UIGestureRecognizer *)tap {
    
    [lyricView.lyricText resignFirstResponder];
    
    [titleText resignFirstResponder];
}
    
-(void)viewWillAppear:(BOOL)animated
{
    

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //timerNumRecorder=0;
    //timerNumRecorder_temp=0;
    timerNumPlay=0;
    timerNumPlay_temp=0;
    mp3URL=nil;
    
    //stop the music
    self.clickedValue = 0;
    NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
    
    playVC.playOrPauseBtn.selected = NO;
    
    [playVC.player pause];
    [self resetButton];
    
    [self downloadAccompanyWithUrl:hotMp3Url];
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
            
            ProgressView.downloadDic = @{@"title":@"温馨提示",@"message":@"带上耳机，效果更佳哦～",@"loading":@"正在努力加载，请稍候..."};
            
            [ProgressView.cancelBtn addTarget:self action:@selector(removeProgressView) forControlEvents:UIControlEventTouchUpInside];
            
            [self.navigationController.view addSubview:ProgressView];
            
            [[NSHttpClient client] downLoadWithFileURL:urlStr completionHandler:^{
                
                [self removeProgressView];
                
            }];
        } else {
            
            
        }
    }
}
- (void)removeProgressView {
    
    [self.maskView removeFromSuperview];
    
    [ProgressView removeFromSuperview];
}
- (void)leftBackClick:(UIBarButtonItem *)back {
    
    WS(wSelf);
  
    UIButton *btn =  self.btns[2];
    if (self.wavFilePath || self.mp3Path || btn.selected) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请确认操作" message:@"是否放弃当前录音？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [wSelf removeLink];
            [wSelf stopPlaysound:self.player];
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

#pragma mark - setupUI
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
    
    
    int num = 5;
    
    CGFloat btnW = ScreenWidth / 5;
    
    for (int i = 0; i < num; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * i, 0, btnW, btnW)];
        
        btn.selected=NO;

        NSString *imageStr = [NSString stringWithFormat:@"2.0_writeMusic_btn%02d",i];
        
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        
//        if (i == 0 || i == 4) {
//            
//            btn.hidden = YES;
//        }
        
        if (i == 1) {
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_btn01"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_play"] forState:UIControlStateNormal];
            
        }
        
        if (i == 2) {
            
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_recording"] forState:UIControlStateSelected];
        }
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btns addObject:btn];
        
        [bottomView addSubview:btn];
    }
    
    
    self.waveform = [[NSWaveformView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 220, ScreenWidth, 84)];
    
    self.waveform.backgroundColor = [UIColor whiteColor];
    
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
    
    lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
    
    lyricView.lyricText.showsVerticalScrollIndicator = NO;
    
    
    [self.view addSubview:lyricView];

 
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    timerNum=scrollView.contentOffset.x/speed;
    timerNumPlay_temp = timerNum;
    curtime3 =timerNum;
    curtime2 =timerNum;

    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
    
}

- (void)btnClick:(UIButton *)btn {

    self.appDelete = [UIApplication sharedApplication].delegate;
    
     clickValue = [self buttonClickedValue:btn];
    if (btn.tag == 0) {
        
        //next song
        if (self.urlStrArr.count != 0) {
            if (self.accompanyId == self.urlStrArr.count - 1) {
                hotMp3Url  = [self.urlStrArr firstObject];
                self.accompanyId = 0;
            }else{
                self.accompanyId = self.accompanyId + 1;
                hotMp3Url   = self.urlStrArr[self.accompanyId];
            }
            [self downloadAccompanyWithUrl:hotMp3Url];
            
        }else{
            
            
        }
        
        
    } else if (btn.tag == 2) {
        
        self.waveform.timeScrollView.userInteractionEnabled=NO;

        if (self.player.currentTime == 0) {
            [self.waveform.waveView removeAllPath];
        }
        
       
        [self.waveLink setPaused:NO];

        if ([self.player3 isPlaying] || [self.player2 isPlaying]) {
            [[NSToastManager manager ] showtoast:@"先暂停试听"];

            //[HudView showView:self.navigationController.view string:@"先暂停试听"];
            return;
        }
        btn.selected = !btn.selected;
        
        if (btn.selected) {

            //[HudView showView:self.navigationController.view string:@"开始录音"];
            [[NSToastManager manager ] showtoast:@"开始录音"];

            self.isPlay = NO;

            timerNumRecorder =timerNumRecorder_temp;
            timerNum=   timerNumRecorder;

            [self.link setPaused:NO];
            
            if (self.appDelete.isHeadset) {
                plugedHeadset=YES;
            }else if(!self.appDelete.isHeadset){
                plugedHeadset=NO;
                
            }
            
            [self startRecorder];
            
            
            NSURL *url = [NSURL fileURLWithPath:[LocalAccompanyPath stringByAppendingPathComponent:[hotMp3Url lastPathComponent]]];
            if (!self.player) {
                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                self.player.enableRate = YES;
                self.player.rate = 1.0;
                self.player.delegate = self;
                totalTimeLabel.text = [NSString stringWithFormat:@"/%02d:%02d",(int)self.player.duration / 60, (int)self.player.duration % 60];
                self.player.meteringEnabled=YES;
                [self.player prepareToPlay];
                
            }
            
            [self.player play];
            
            
        } else {

            self.waveform.timeScrollView.userInteractionEnabled=YES;


            [self.waveLink setPaused:YES];

            timerNumRecorder_temp = self.player.currentTime;
            [self pauseRecorder];
           
            [self pausePlaysound:self.player];
            [self.link setPaused:YES];
            timerNumTemp=timerNum;
            
        }
        
         curtime3=0;
         curtime2=0;
         timerNumPlay_temp=0;
    } else if (btn.tag ==1) {

        self.waveform.timeScrollView.userInteractionEnabled=NO;

        if ([self.player isPlaying]) {
            //[HudView showView:self.navigationController.view string:@"请先停止录音"];
            [[NSToastManager manager ] showtoast:@"请先停止录音"];

            return;
        }
        if (self.wavFilePath == nil) {
            //[HudView showView:self.navigationController.view string:@"还未开始录音"];
            [[NSToastManager manager ] showtoast:@"还未开始录音"];

            return;
            
        }

        
        btn.selected = !btn.selected;//－－no
        if (btn.selected) { //回听

            [self.waveLink setPaused:NO];
            
            //[HudView showView:self.navigationController.view string:@"开始试听"];
            [[NSToastManager manager ] showtoast:@"开始试听"];

            timerNumPlay = timerNumPlay_temp;
            timerNum = timerNumPlay;
            [self.link setPaused:NO];
            
            self.isPlay = NO; //YES
            

            NSURL *url = [NSURL fileURLWithPath:[LocalAccompanyPath stringByAppendingPathComponent:[hotMp3Url lastPathComponent]]];
            
            if (plugedHeadset)
            {

                //if (!self.player2)
                {
                    self.player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                    self.player2.enableRate = YES;
                    self.player2.rate = 1.0;
                    [self.player2 setCurrentTime:curtime2];

                    [self.player2 prepareToPlay];
                    self.player2.meteringEnabled=YES;

                    self.player2.delegate =self;
                    [self.player2 play];


                }

                
            }

            [self playsound:self.wavFilePath time:curtime3];

        }else{//没回听
            self.waveform.timeScrollView.userInteractionEnabled=YES;

            curtime2=   self.player2.currentTime;
            curtime3=   self.player3.currentTime;
            timerNumPlay_temp=curtime3;
            
            [self pausePlaysound:self.player2];
            [self pausePlaysound:self.player3];
            [self.link setPaused:YES];
            [self.waveLink setPaused:YES];


            
        }
        
        
    } else if (btn.tag == 3) {//
        
        if ([self.player isPlaying]) {
          //  [HudView showView:self.navigationController.view string:@"先停止录音"];
            [[NSToastManager manager ] showtoast:@"先停止录音"];

            return;

        }
        if ([self.player2 isPlaying]||[self.player3 isPlaying]) {
            //[HudView showView:self.navigationController.view string:@"先停止试听"];
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
        
        
    } else if (btn.tag == 4) {
        
        [self importLyricClick:nil];
    }
    

}

- (void)resetButton{
    UIButton* btn1 =   self.btns[1];
    UIButton* btn2 =   self.btns[2];
    
    btn1.selected=NO;;
    btn2.selected=NO;;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self clear];
    }

}
- (void)clear{
  
    [self resetButton];

    self.timeLabel.text = @"00:00";
    timerNum=0;
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
    [self stopPlaysound:self.player];
    [self stopPlaysound:self.player2];
    [self stopPlaysound:self.player3];
    [self stopRecorder];

    self.waveform.waveView.desibelNum=0;
    [self.waveform.waveView removeAllPath];
    
    [self removeSoundRecorder];
    
}


- (void)importLyricClick:(UIBarButtonItem *)import {
    
    NSImportLyricViewController *importLyric = [[NSImportLyricViewController alloc] init];
    importLyric.delegate = self;
    [self.navigationController pushViewController:importLyric animated:YES];
    
}

- (void)showPromptView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"歌曲正在美化，请稍后...", @"HUD loading title");
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 10);//MBProgressMaxOffset);

}
- (void)nextClick:(UIBarButtonItem *)next {
    
    if ([self.player isPlaying]) {
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
        
        
        self.alertView = [UIAlertController alertControllerWithTitle:nil message:@"歌曲正在美化，请稍后..." preferredStyle:UIAlertControllerStyleAlert];
      
        
        [self presentViewController:self.alertView animated:YES completion:nil];
        
        if (JUserID) {
            
            
            
            [self uploadMusic];
            
             self.public = [[NSPublicLyricViewController alloc] initWithLyricDic:self.dict withType:NO];
            self.public.isLyric=NO;
            [self.link setPaused:YES];
            [self pauseDevides];
             
             } else
             {
             
                 NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
             
                 [self presentViewController:loginVC animated:YES completion:nil];
             }

   
    
    }
}

#pragma mark -OptionMusic
-(void)tuningMusicWithCreateType:(NSString *)createType andHotId:(long)hotId_ andUserID:(NSString *)userID_ andUseHeadSet:(BOOL)userHeadSet andMusicUrl :(NSString *)musicURl
{
    self.requestType = NO;
    int headSet = 0;
    if (userHeadSet ) {
        headSet = 1;
    }
    self.requestParams = @{@"hotid":[NSNumber numberWithLong:hotId_],
                           @"uid":JUserID,
                           @"token":LoginToken,
                           @"useheadset":[NSNumber numberWithInt:headSet],
                           @"createtype":@"hot",
                           @"musicurl":musicURl};
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
            
            [self.dict setValue:[NSString stringWithFormat:@"%ld",hotId] forKey:@"itemID"];
            [self.dict setValue:mp3URL forKey:@"mp3URL"];
            [self.dict setValue:[NSNumber numberWithBool:self.appDelete.isHeadset] forKey:@"isHeadSet"];
            NSLog(@"--------开始，mp3URL =%@",mp3URL);
            [self.public initWithLyricDic:self.dict withType:NO];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:NextStep object:self userInfo:nil];
            [self.alertView dismissViewControllerAnimated:YES completion:^{
                [wSelf.navigationController pushViewController:wSelf.public animated:YES];
            }];

            self.public.isLyric=NO;

            self.public.mp3File = self.mp3Path;
            
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
        self.link.frameInterval=4;

        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)addWaveLink {
    
    if (!self.waveLink)
    {
        
        self.waveLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTimeView)];
        
        self.waveLink.frameInterval=4;
        [self.waveLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
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

- (float)updateMeters{
    
    if ([self.recorder averagePowerForChannel:0] < -20) {
        return -45.0;
    }
    float f = [self.recorder averagePowerForChannel:0];
    return f;
}




- (void)actionTiming {
    
    timerNum += 1/15.0;
    //分贝数

    if (!self.isPlay) {
        if ([self.recorder isRecording]) {
            count = [self decibels];
        }else{
            if ([self.player isPlaying]) {
                count = [self playerDecibels:self.player];

            }
//            else if([self.player2 isPlaying]) {
//                count = [self playerDecibels:self.player2];
//                
//            }
            else if([self.player3 isPlaying]) {
                count = [self playerDecibels:self.player3];
                
            }

        }
//        self.lineNum++;
        
//        if (self.lineNum % 3 == 0) { //3
            self.waveform.waveView.desibelNum =(fabs(count));
            dispatch_async(dispatch_get_main_queue(), ^{
//
                [self.waveform.waveView drawLine];
                
                [self.waveform.waveView setNeedsDisplay];
            });
            
//        }
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
    
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
        [self.descibelDictionary  setValue:[arrWave objectAtIndex:i] forKey:[NSString stringWithFormat:@"%ld",key]];


    }
    
}

- (void)disPlayTimeLabel{
    
}
//- (void)actionTiming {
//    
//    // drawCount++;
//    timerNum += 1/60.0;
//    
////    count = [self decibels];
//    
//    if (!self.isPlay) {
//        if ([self.recorder isRecording]) {
//            count = [self decibels];
//        }else{
//            if ([self.player isPlaying]) {
//                count = [self playerDecibels:self.player];
//                
//            }else if([self.player2 isPlaying]) {
//                count = [self playerDecibels:self.player2];
//                
//            }else if([self.player3 isPlaying]) {
//                count = [self playerDecibels:self.player3];
//                
//            }
//            
//        }
////        int keyValue = (int)count;
//        
////        NSString* keyStr = [NSString stringWithFormat:@"%d",(int)abs(keyValue)];
////        NSInteger i = [[self.descibelDictionary valueForKey:keyStr] integerValue];
//        //(fabs(count))*11/40;//(fabs(count)*2)/5;
//        
////        if (count<-10) {
//            self.waveform.waveView.desibelNum =(fabs(count))*11/40;
//            
////        }else{
////            self.waveform.waveView.desibelNum =i;
////            
////        }
//        
////        if (![self.player3 isPlaying] && self.player.currentTime>0) {
//        
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [self.waveform.waveView drawLine];
//                
//                [self.waveform.waveView setNeedsDisplay];
//            });
//            
////        }
//        self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
//        
//    }
// 
//    
// 
// }






#pragma mark -setter && getter
-(void)setAccompanyModel:(NSAccommpanyModel *)accompanyModel
{
    _accompanyModel = accompanyModel;

}

- (void)selectLyric:(NSString *)lyrics withMusicName:(NSString *)musicName {
    
    lyricView.lyricText.text = lyrics;
    
    titleText.text = musicName;
}

- (void)uploadMusic{

    //后台执行mp3转换和上传
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self recorderFileToMp3WithType:TrueMachine filePath:self.wavFilePath];
        NSData *data = [NSData dataWithContentsOfFile:self.mp3Path];
        self.data=data;
        
        NSArray *array = [self.mp3Path componentsSeparatedByString:@"/"];
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
            
            [self tuningMusicWithCreateType:nil andHotId:hotId andUserID:JUserID andUseHeadSet:self.appDelete.isHeadset andMusicUrl:dict[@"data"][@"mp3URL"]];
            
            //self.wavFilePath = nil;
            
            
            
            
        } failure:^void(NSURLSessionDataTask * task, NSError * error) {
            // 请求失败
            
            [[NSToastManager manager] hideprogress];
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


- (int)buttonClickedValue:(UIButton*)btn{
    if (btn == self.btns[1]) {
        return 1;
    }else if(btn == self.btns[2]){
        return 2;
    }else if(btn == self.btns[3]){
        return 3;
    }
    return -1;
}



- (void)nextStep:(NSNotification*)userInfo{
    [self.alertView dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController pushViewController:self.public animated:YES];

    
}

- (void)scrollTimeView{

    self.waveform.waveView.waveDistance =speed*timerNum;
    if ([self.player isPlaying]) {
        distantKeyPath=self.waveform.timeScrollView.contentOffset.x;
    }
        [self.waveform.timeScrollView setContentOffset:CGPointMake(self.waveform.waveView.waveDistance, 0) animated:NO];
    drawNum++;
    
    [self changeScrollViewColor];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.distantKeyPathTemp = scrollView.contentOffset.x;


}





- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (decelerate) {
        
    }else{
        timerNum=scrollView.contentOffset.x/speed;
        timerNumPlay_temp = timerNum;
        curtime3 =timerNum;
        curtime2 =timerNum;

        self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
        

    }


}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

}


- (void)changeScrollViewColor{
    
    if (self.waveform.waveView.waveArray.count == 0) {
        return;
    }
    UIView* view = (UIView*)self.waveform.waveView.waveArray[0];
    CGFloat f=  self.waveform.timeScrollView.contentOffset.x+view.frame.origin.x;
    for (UIView* view in self.waveform.waveView.waveArray) {
        if (view.frame.origin.x<f) {
            view.backgroundColor = [UIColor hexColorFloat:@"ffd33f"];
        }
        else{
            view.backgroundColor = [UIColor lightGrayColor];

        }
    }
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NextStep object:nil];
    [self.timer invalidate];
    self.timer = nil;
    
    [self removeObserver:self forKeyPath:@"distantKeyPathTemp" context:nil];
}
@end
