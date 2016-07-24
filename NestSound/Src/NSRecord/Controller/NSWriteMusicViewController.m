//
//  NSWriteMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSWriteMusicViewController.h"
#import "NSDrawLineView.h"
#import "NSLyricView.h"
#import "NSOptimizeMusicViewController.h"
#import "NSImportLyricViewController.h"
#import "XHSoundRecorder.h"
#import "NSAccommpanyListModel.h"
#import "NSPlayMusicTool.h"
#import <AVFoundation/AVFoundation.h>
#import "NSPublicLyricViewController.h"
#import "NSTunMusicModel.h"
#import "NSLoginViewController.h"
#import "NSWaveformView.h"
#import "NSPlayMusicViewController.h"
#import "NSDownloadProgressView.h"
#import "lame.h"

static CGFloat timerNum=0;
static CGFloat timerNum_temp=0;

static CGFloat count =0;
extern NSString* path;
extern NSString* pathMp3;

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


@interface NSWriteMusicViewController () <UIScrollViewDelegate, ImportLyric, AVAudioPlayerDelegate> {
    
    UILabel *totalTimeLabel;
    
    UITextField *titleText;
    UIImageView * listenBk;
    UIImageView * recordBk;
    UIImageView * reRecordBk;
    NSLyricView *lyricView;
    BOOL isHeadset;
    NSString  * hotMp3Url;
    long hotId;
    long musicTime;
    NSString * mp3URL;
    NSDownloadProgressView *ProgressView;
}

@property (nonatomic, strong) UIImageView *slideBarImage;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong)  CADisplayLink *link;
@property (nonatomic, strong)  CADisplayLink *link2;

@property (nonatomic, assign) CGFloat count2;


@property (nonatomic, strong) NSMutableArray *btns;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *player2;

@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, weak)  UIBarButtonItem *next;

@property (nonatomic, copy) NSString *mp3File;

@property (nonatomic, copy) NSString *wavFilePath;
@property (nonatomic, strong)NSPublicLyricViewController* public;
@property (nonatomic, strong) NSWaveformView *waveform;

@property (nonatomic, assign) int lineNum;
@property (nonatomic, assign) int lineNum2;

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, assign) BOOL isPlay2;

@property (nonatomic, weak) AVAudioSession *session;

@property (nonatomic,strong) UIAlertView *alertView;

@property (nonatomic, strong) UIView *maskView;
@end

@implementation NSWriteMusicViewController

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
- (UIAlertView *)alertView {
    if (!_alertView) {
        self.alertView =[ [UIAlertView alloc] initWithTitle:@"温馨提示" message:@"歌曲正在美化，请稍候..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    }
    return _alertView;
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
    
    
    timerNum=0;
    count=0;
    timerNum_temp=0;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //addObserver for UserHeadset
    [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    
    AVAudioSessionRouteDescription * route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription * desc in [route outputs]) {
        if([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]){
            isHeadset = YES;
        }else{
            isHeadset = NO;
        }
    }
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick:)];
    
    next.enabled = NO;
    
    self.next = next;
    
    UIBarButtonItem *importLyric = [[UIBarButtonItem alloc] initWithTitle:@"导入歌词" style:UIBarButtonItemStylePlain target:self action:@selector(importLyricClick:)];
    
    NSArray *array = @[next, importLyric];
#import "NSLoginViewController.h"
#import "AFHTTPSessionManager.h"
    
    self.navigationItem.rightBarButtonItems = array;
    
    [self setupUI];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBackClick:)];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    [self.view addGestureRecognizer:tap];
    
    [self addLink];
    [self.link setPaused:YES];
    
}

- (void)tapClick:(UIGestureRecognizer *)tap {
    
    [lyricView.lyricText resignFirstResponder];
    
    [titleText resignFirstResponder];
}
    
-(void)viewWillAppear:(BOOL)animated
{
    WS(wSelf);
    [super viewWillAppear:animated];
    timerNum=0;
    count=0;
    timerNum_temp=0;
    
   /* if (self.wavFilePath || self.mp3File) {
        
        self.next.enabled = YES;
    }*/
    
    //stop the music
    NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
    
    playVC.playOrPauseBtn.selected = NO;
    
    [playVC.player pause];
    
    NSString * fileURL = hotMp3Url;
    NSFileManager * fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:LocalAccompanyPath]) {
        [fm createDirectoryAtPath:LocalAccompanyPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        if (![fm fileExistsAtPath:[LocalAccompanyPath stringByAppendingPathComponent:[fileURL lastPathComponent]]]) {
            //下载进度条
            self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            
            _maskView.backgroundColor = [UIColor blackColor];
            
            _maskView.alpha = 0.5;
            
            [self.navigationController.view addSubview:_maskView];
            
            ProgressView = [[NSDownloadProgressView alloc] initWithFrame:CGRectMake(ScreenWidth/6, ScreenHeight/3, 2*ScreenWidth/3, ScreenHeight/4)];
            
            ProgressView.downloadDic = @{@"title":@"温馨提示",@"message":@"带上耳机，效果更佳哦～",@"loading":@"正在努力加载，请稍候..."};
            
            [ProgressView.cancelBtn addTarget:self action:@selector(removeProgressView) forControlEvents:UIControlEventTouchUpInside];
            
            [self.navigationController.view addSubview:ProgressView];
            
            [[NSHttpClient client] downLoadWithFileURL:fileURL completionHandler:^{
                
                [self removeProgressView];
                
                UIButton *btn2 = wSelf.btns[2];
                
                btn2.enabled = YES;
            }];
        } else {
            
            UIButton *btn2 = wSelf.btns[2];
            
            btn2.enabled = YES;
        }
    }
    
    if (self.mp3File) {
        
        UIButton *btn2 = wSelf.btns[2];
        
        btn2.enabled = NO;
    }

}
//移除进度条
- (void)removeProgressView {
    
    [self.maskView removeFromSuperview];
    
    [ProgressView removeFromSuperview];
}
- (void)leftBackClick:(UIBarButtonItem *)back {
    
    WS(wSelf);
    
    [self removeLink];
    [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
    [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
    if (self.player) {
        [self.player stop];
    }
    UIButton *btn =  self.btns[2];
    if (self.wavFilePath || self.mp3File || btn.selected) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定放弃?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSFileManager *manager = [NSFileManager defaultManager];
            
            [manager removeItemAtPath:self.wavFilePath error:nil];
            
            [manager removeItemAtPath:self.mp3File error:nil];
            
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
        
        [[XHSoundRecorder sharedSoundRecorder] removeSoundRecorder];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark -userHeadSet
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:

            NSLog(@"Headphone/Line plugged in");
            
            isHeadset = YES;
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"Headphone/Line was pulled. Stopping player....");
            [self.session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            isHeadset = NO;
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark - setupUI
- (void)setupUI {
    
    //listenBk
    listenBk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_listen_bk"]];
    
    
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
        
        NSString *imageStr = [NSString stringWithFormat:@"2.0_writeMusic_btn%02d",i];
        
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        
        if (i == 0 || i == 4) {
            
            btn.hidden = YES;
        }
        
        if (i == 1) {
            btn.selected=YES;
            btn.enabled = NO;
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_btn01"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_play"] forState:UIControlStateNormal];

            
        }
        
        if (i == 2) {
            
            btn.enabled = NO;
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_recording"] forState:UIControlStateSelected];
        }
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btns addObject:btn];
        
        [bottomView addSubview:btn];
    }
    
    
    self.waveform = [[NSWaveformView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 200, ScreenWidth, 64)];
    
    self.waveform.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.waveform];
    
    
    self.slideBarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_writeMusic_slideBar"]];
    
    self.slideBarImage.frame = CGRectMake(self.view.width * 0.5 - 3, self.waveform.y - 2, 6, 69);
    
    [self.view addSubview:self.slideBarImage];
    
    
    totalTimeLabel = [[UILabel alloc] init];
    
    totalTimeLabel.font = [UIFont systemFontOfSize:10];
    
    totalTimeLabel.text = [NSString stringWithFormat:@"/%@",[NSTool stringFormatWithTimeLong:musicTime]];
    
    [self.view addSubview:totalTimeLabel];
    
    [totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.bottom.equalTo(bottomView.mas_top).offset(-10);
        
    }];
    
    
    self.timeLabel = [[UILabel alloc] init];
    
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    
    self.timeLabel.text = [NSString stringWithFormat:@"00:00"];
    
    [self.view addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(totalTimeLabel.mas_left);
        
        make.bottom.equalTo(bottomView.mas_top).offset(-10);
        
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
    
    
    lyricView = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 50, self.view.width, self.view.height - 260)];
    
    lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
    
    lyricView.lyricText.showsVerticalScrollIndicator = NO;
    
    
    [self.view addSubview:lyricView];
    
 
    
}

- (void)btnClick:(UIButton *)btn {

    WS(wSelf);
    
    if (btn.tag == 0) {
        
        NSImportLyricViewController *importLyric = [[NSImportLyricViewController alloc] init];
        importLyric.delegate = self;
        [self.navigationController pushViewController:importLyric animated:YES];
        
        
    } else if (btn.tag == 1) {
        UIButton *btn2 = self.btns[2];
        btn.selected = !btn.selected;//－－no
        if (btn.selected) { //回听

            btn2.selected=YES;
            btn2.enabled=NO;
            [self.waveform removeAllPath];
            timerNum=0;
            [self.link setPaused:NO];

                //[self.waveform playerAllPath];
                
                self.isPlay2 = NO; //YES
            
                [[XHSoundRecorder sharedSoundRecorder] playsound:nil withFinishPlaying:^{
                 
                 [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
                 
                    timerNum=0;
                    
                    btn.selected = NO;
                    btn2.enabled=YES;
                    btn2.selected=NO;

                    [wSelf.link setPaused:YES];
                 }];
            

        }else{//没回听
            [self.link setPaused:YES];
            [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];


        }
        
    } else if (btn.tag == 2) {

        btn.selected = !btn.selected;
        
        UIButton *btn1 = self.btns[1];
        
        if (btn.selected) {
            
            btn1.selected=NO;

            btn1.enabled=NO;

            self.isPlay = NO;
             timerNum=timerNum_temp;
            [self.link setPaused:NO];

            [[XHSoundRecorder sharedSoundRecorder] startRecorder:^(NSString *filePath) {
                
                self.wavFilePath = filePath;
                
            }];
            
        
            if (!self.session) {
                AVAudioSession *session = [AVAudioSession sharedInstance];
                
                [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
                [session setActive:YES error:nil];
                
                self.session = session;
            }
            
                
                NSURL *url = [NSURL fileURLWithPath:[LocalAccompanyPath stringByAppendingPathComponent:[hotMp3Url lastPathComponent]]];
                if (!self.player) {
                    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                    self.player.meteringEnabled=YES;
                    self.player.delegate = self;
                    totalTimeLabel.text = [NSString stringWithFormat:@"/%02d:%02d",(int)self.player.duration / 60, (int)self.player.duration % 60];
                    [self.player prepareToPlay];

                }
            
                [self.player play];

            
        } else {
            
            [self.link setPaused:YES];
            [[XHSoundRecorder sharedSoundRecorder] pauseRecorder];
            [self.player pause];
            btn1.selected=NO;
            btn1.enabled=YES;

            self.next.enabled = YES;
            timerNum_temp =timerNum;

        }
        
        
    } else if (btn.tag == 3) {
        [[NSToastManager manager] showtoast:@"您已清空录音"];

        [self clear];
        
    } else {
        
        btn.selected = !btn.selected;
        
        if (btn.selected) {
            
            titleText.enabled = YES;
            
            lyricView.lyricText.editable = YES;
            

        } else {
            
            titleText.enabled = NO;
            
            lyricView.lyricText.editable = NO;
            
        }
        
    }
}

- (void)clear{
    UIButton *btn1 = self.btns[1];
    
    btn1.enabled = NO;
    btn1.selected=NO;
    UIButton *btn2 = self.btns[2];
    
    btn2.enabled = YES;
    btn2.selected=NO;
    self.timeLabel.text = @"00:00";

    timerNum = 0;
    timerNum_temp=0;
    count=0;
    self.wavFilePath = nil;
    [self.link setPaused:YES];
    [self.player stop];
    self.player=nil;
    [self.waveform removeAllPath];
    
    [[XHSoundRecorder sharedSoundRecorder] removeSoundRecorder];
    
    [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
    
    [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
}


- (void)importLyricClick:(UIBarButtonItem *)import {
    
    NSImportLyricViewController *importLyric = [[NSImportLyricViewController alloc] init];
    importLyric.delegate = self;
    [self.navigationController pushViewController:importLyric animated:YES];
    
    NSLog(@"点击了导入歌词");
}


- (void)nextClick:(UIBarButtonItem *)next {
    //[self removeLink];
    [self.link setPaused:YES];
    [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
    [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
    if (titleText.text.length == 0) {
        [[NSToastManager manager] showtoast:@"歌词标题不能为空"];
    }else if (lyricView.lyricText.text.length == 0)
    {
            [[NSToastManager manager] showtoast:@"歌词不能为空"];
            
    }else{
        
        if (JUserID) {
            
            self.next.enabled = YES;
            
            
            [self uploadMusic];
            
            
             self.public = [[NSPublicLyricViewController alloc] initWithLyricDic:self.dict withType:NO];
            self.public.isLyric=NO;

             [self.navigationController pushViewController:self.public animated:YES];
            
             
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
   [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
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
            [self.dict setValue:[NSNumber numberWithBool:isHeadset] forKey:@"isHeadSet"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotitionDictionaryData object:self userInfo:self.dict];
            self.public.isLyric=NO;
            self.public.mp3File = self.mp3File;
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
        self.link.frameInterval=2;

        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}




/**
 *  移除定时器
 */
- (void)removeLink {
    
   /* if (self.link) {
        [self.link invalidate];
        self.link = nil;
    }*/
    
    
}



- (void)stopLink{
    [self.link setPaused:YES];

}

/**
 *  定时器执行
 */
- (void)actionTiming {
    //NSLog(@"---------timerNum=%f",timerNum);
    //计时数
    timerNum += 1/60.0;
    
    //分贝数
    
    if (!self.isPlay) {
        //count = [[XHSoundRecorder sharedSoundRecorder] decibels];
        count = [self decibels];

      //  NSLog(@"-2-------count=%f",count);
        self.lineNum++;
            
        if (self.lineNum % 3 == 0) {
            
            self.waveform.num = count * 0.25 + 20;
            
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.waveform drawLine];
            [self.waveform setNeedsDisplay];

        });
            
        }
    }
    

    //计时显示
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum / 60, (NSInteger)timerNum % 60];
    
}




//伴奏播放完毕的回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [self removeLink];
    [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
    [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
    [self.player stop];
    self.next.enabled = YES;
    UIButton *btn2 = self.btns[2];
    UIButton *btn1 = self.btns[1];
    btn2.enabled = NO;
    btn2.selected = NO;
    btn1.enabled = YES;
    
}

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
    WS(wSelf);
    //后台执行mp3转换和上传
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[XHSoundRecorder sharedSoundRecorder] recorderFileToMp3WithType:TrueMachine filePath:self.wavFilePath FilePath:^(NSString *newfilePath) {
            
            NSData *data = [NSData dataWithContentsOfFile:newfilePath];
            
            wSelf.data = data;
            
            wSelf.mp3File = newfilePath;
            NSArray *array = [newfilePath componentsSeparatedByString:@"/"];

            NSUInteger count = array.count;
            NSString* fileName = array[count-1];
            
            // 1.创建网络管理者
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSString* url =[NSString stringWithFormat:@"%@/%@",[NSTool obtainHostURL],uploadMp3URL];
            [manager POST:url parameters:nil constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
                
                [formData appendPartWithFileData:wSelf.data name:@"file" fileName:@"abc.mp3" mimeType:@"audio/mp3"];//audio/mp3／／audio/x-mpeg
                
            } success:^void(NSURLSessionDataTask * task, id responseObject) {
                NSLog(@"------------MP3音频上传成功！");
                NSDictionary *dict;
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    dict = [[NSHttpClient client] encryptWithDictionary:responseObject isEncrypt:NO];
                    
                }
                
                [self tuningMusicWithCreateType:nil andHotId:hotId andUserID:JUserID andUseHeadSet:isHeadset andMusicUrl:dict[@"data"][@"mp3URL"]];
                
                //self.wavFilePath = nil;
                
                
            } failure:^void(NSURLSessionDataTask * task, NSError * error) {
                // 请求失败
                NSLog(@"------------MP3音频上传失败！");

                [[NSToastManager manager] hideprogress];
                //self.next.enabled = YES;
            }];
            
        }];
    });

}

//分贝数
- (CGFloat)decibels {
    
    
    CGFloat decibels = [self.player averagePowerForChannel:1];
    [self.player updateMeters];
    
    return decibels;
}


////////////////////////////////////////////////////测试代码begin,后期稳定了可删除
/*
- (void)cafToMp3:(NSString *)filePath{
    
    NSString *wavFilePath;
    
    if (filePath == nil) {
        NSLog(@"没有要转的文件");
        
    } else {
        
        wavFilePath = filePath;
    }
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString * currentTimeString = [formatter stringFromDate:date];
    
    
    NSString *mp3FilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    mp3FilePath = [mp3FilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",currentTimeString]];
    
    @try {
        int write,read;
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        //source 被转换的音频文件位置
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");
        //output 输出生成的Mp3文件位置
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");
        
        fseek(pcm, 4*1024, SEEK_CUR);
        NSLog(@"caf:%@",filePath);
        NSLog(@"mp3:%@",mp3FilePath);
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
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
        NSLog(@"MP3生成成功: %@",mp3FilePath);
        
        NSFileManager *f = [NSFileManager defaultManager];
        
        long long l = [[f attributesOfItemAtPath:filePath error:nil] fileSize];
        long long l2 = [[f attributesOfItemAtPath:mp3FilePath error:nil] fileSize];
        
        NSLog(@"-----------转化前caf = %lld",l);
        NSLog(@"-----------转化后mp3 = %lld",l2);
        //[self testMp3:filePath];

        [self testMp3:mp3FilePath];
        
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

- (void)xxx:(UIButton*)sended{
    NSLog(@"123 = %@",path);
    
    //[self cafToMp3:path toMp3Path:<#(NSString *)#>];
    //[self toMp3:TrueMachine filePath:path];
    //[self testMp3:path];
    //[self cafToMp3:path];
    [[XHSoundRecorder sharedSoundRecorder] recorderFileToMp3WithType:TrueMachine filePath:path FilePath:nil];


}*/

///////测试代码end


@end
