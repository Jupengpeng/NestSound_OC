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
static CGFloat timerNum=0;
static CGFloat timerNum_temp=0;

static CGFloat durationRecord=0;
static CGFloat count =0;
extern NSString* path;
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

@property (nonatomic, assign) CGFloat timerNum2;
@property (nonatomic, assign) CGFloat count2;


@property (nonatomic, strong) NSMutableArray *btns;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *player2;

@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, weak)  UIBarButtonItem *next;

@property (nonatomic, copy) NSString *mp3File;

@property (nonatomic, copy) NSString *wavFilePath;

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
    durationRecord=0;
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
    durationRecord=0;
    count=0;
    timerNum_temp=0;
    
    if (self.wavFilePath || self.mp3File) {
        
        self.next.enabled = YES;
    }
    
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
    [self.player stop];
    self.next.enabled = YES;
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
//    [self.view addSubview:listenBk];
    
    
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
            
            btn.enabled = NO;
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_play"] forState:UIControlStateSelected];
            
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
    
//    lyricView.lyricText.editable = NO;
    
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
        if (!btn.selected) { //回听
            btn2.selected=YES;
            btn2.enabled=NO;
            NSLog(@"--------path =%@",path);
            [self.waveform removeAllPath];
            self.timerNum2=0;

                [self addLink2];
            [self.link2 setPaused:NO];

                [self.waveform playerAllPath];
                
                self.isPlay2 = NO;//YES
                
                [[XHSoundRecorder sharedSoundRecorder] playsound:nil withFinishPlaying:^{
                 
                 [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
                 
                    wSelf.timerNum2=0;
                 
                 [wSelf removeLink2];
                 
                 btn.selected = YES;
                    btn2.enabled=YES;
                 }];
                //////////////////////add by liuxiangwei
                
                /*AVAudioSession *session = [AVAudioSession sharedInstance];
                
                [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
                [session setActive:YES error:nil];
                
                self.session = session;
                
                
                NSURL* url = [NSURL fileURLWithPath:path];
                
                self.player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                
                
                
                self.player2.delegate = self;
                
                [self.player2 prepareToPlay];
                
                [self.player2 play];*/
                
                //////////////////////end
            

        }else{//没回听
            //btn2.enabled=YES;
            [self removeLink2];
            [self.link2 setPaused:YES];
            [[XHSoundRecorder sharedSoundRecorder] pausePlaysound];

            //[self.player2 stop];
            //self.player2=nil;

        }
        
    } else if (btn.tag == 2) {
        btn.selected = !btn.selected;
        
        UIButton *btn1 = self.btns[1];
        
        if (btn.selected) {
            
            btn1.selected = YES;
            //timerNum = timerNum_temp;
            [self.link setPaused:NO];

            [self addLink];
            self.isPlay = NO;
            
            [[XHSoundRecorder sharedSoundRecorder] startRecorder:^(NSString *filePath) {
                
                self.wavFilePath = filePath;
                
            }];
            
            btn1.enabled = NO;
            
            
            {
                
                    self.session = [AVAudioSession sharedInstance];
                
                    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
                    [self.session setActive:YES error:nil];
                
                
                
                
                NSURL *url = [NSURL fileURLWithPath:[LocalAccompanyPath stringByAppendingPathComponent:[hotMp3Url lastPathComponent]]];
                if (!self.player) {
                    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];

                }
                
                self.player.delegate = self;
                totalTimeLabel.text = [NSString stringWithFormat:@"/%02d:%02d",(int)self.player.duration / 60, (int)self.player.duration % 60];
                
                [self.player prepareToPlay];
                
            }
            
            [self.player play];
            
            
        } else {
            
            [self.link setPaused:YES];
            [[XHSoundRecorder sharedSoundRecorder] pauseRecorder];
            [self.player pause];
            self.next.enabled = YES;
            btn1.enabled = YES;
            durationRecord = self.player.currentTime;
            count = [[XHSoundRecorder sharedSoundRecorder] decibels];
            //timerNum_temp =timerNum;

        }
        
        
    } else if (btn.tag == 3) {
        
        UIButton *btn1 = self.btns[1];
        
        btn1.selected = NO;
        
        btn1.enabled = NO;
        
        UIButton *btn2 = self.btns[2];
        
        btn2.selected = NO;
        
        btn2.enabled = YES;
        
        self.timeLabel.text = @"00:00";
        
        [self removeLink];
        [self removeLink2];

        timerNum = 0;
        self.timerNum2=0;
        count=0;
        self.wavFilePath = nil;
        
        [self.player stop];
        self.player=nil;
        [self.waveform removeAllPath];
        
        [[XHSoundRecorder sharedSoundRecorder] removeSoundRecorder];
        
        [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
        
        [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
        
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


- (void)importLyricClick:(UIBarButtonItem *)import {
    
    NSImportLyricViewController *importLyric = [[NSImportLyricViewController alloc] init];
    importLyric.delegate = self;
    [self.navigationController pushViewController:importLyric animated:YES];
    
    NSLog(@"点击了导入歌词");
}


- (void)nextClick:(UIBarButtonItem *)next {
    
    WS(wSelf);
    
    if (titleText.text.length == 0) {
        [[NSToastManager manager] showtoast:@"歌词标题不能为空"];
    }else{
        
        if (JUserID) {
            
            self.next.enabled = NO;
            
            if (self.wavFilePath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.alertView show];
                });
                //后台执行mp3转换和上传
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[XHSoundRecorder sharedSoundRecorder] recorderFileToMp3WithType:TrueMachine filePath:self.wavFilePath FilePath:^(NSString *newfilePath) {
                        
                        NSData *data = [NSData dataWithContentsOfFile:newfilePath];
                        
                        wSelf.data = data;
                        
                        wSelf.mp3File = newfilePath;
                        
                        // 1.创建网络管理者
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        //                            [[NSToastManager manager] showprogress];
                        [manager POST:[NSString stringWithFormat:@"%@/%@",[NSTool obtainHostURL],uploadMp3URL] parameters:nil constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
                            
                            [formData appendPartWithFileData:wSelf.data name:@"file" fileName:@"abc.mp3" mimeType:@"audio/mp3"];
                            
                        } success:^void(NSURLSessionDataTask * task, id responseObject) {
                            
                            NSDictionary *dict;
                            
                            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                
                                dict = [[NSHttpClient client] encryptWithDictionary:responseObject isEncrypt:NO];
                                
                            }
                            
                            [self tuningMusicWithCreateType:nil andHotId:hotId andUserID:JUserID andUseHeadSet:isHeadset andMusicUrl:dict[@"data"][@"mp3URL"]];
                            
                            self.wavFilePath = nil;
                            
                            //                            [[NSToastManager manager] hideprogress];
                            
                        } failure:^void(NSURLSessionDataTask * task, NSError * error) {
                            // 请求失败
                            [[NSToastManager manager] hideprogress];
                            self.next.enabled = YES;
                        }];
                        
                    }];
                });
                //                    [[NSToastManager manager] showprogress];
                
            } else {
                
                NSPublicLyricViewController *public = [[NSPublicLyricViewController alloc] initWithLyricDic:self.dict withType:NO];
                [self.navigationController pushViewController:public animated:YES];
            }
            
        } else {
            
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
            NSPublicLyricViewController *public = [[NSPublicLyricViewController alloc] initWithLyricDic:self.dict withType:NO];
            public.mp3File = self.mp3File;
            [self.navigationController pushViewController:public animated:YES];
        }
    }
}


/**
 *  添加定时器
 */
- (void)addLink {
    
    if (!self.link) {
        
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionTiming)];
    
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)addLink2 {
    
    if (!self.link2) {
        
        self.link2 = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionTiming2)];
        
        [self.link2 addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}


/**
 *  移除定时器
 */
- (void)removeLink {
    
    [self.link invalidate];
    
    self.link = nil;
    
}

- (void)removeLink2 {
    
    [self.link2 invalidate];
    
    self.link2 = nil;
    
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
        
        count = [[XHSoundRecorder sharedSoundRecorder] decibels];
       // NSLog(@"-2-------count=%f",count);
        self.lineNum++;
            
        if (self.lineNum % 3 == 0) {
            
            self.waveform.num = count * 0.5 + 20;
            
            [self.waveform drawLine];
            
            [self.waveform setNeedsDisplay];
        }
    }
    
    
    //计时显示
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum / 60, (NSInteger)timerNum % 60];
    
}

- (void)actionTiming2 {
    //计时数
    self.timerNum2 += 1/60.0;
    //NSLog(@"--------timerNum2=%f",self.timerNum2);

    //分贝数
    
    if (!self.isPlay2) {
        
        self.count2 = [[XHSoundRecorder sharedSoundRecorder] decibels2];
        //NSLog(@"--------count2=%f",self.count2);
        self.lineNum2++;
        
        if (self.lineNum2 % 3 == 0) {
            
            self.waveform.num = self.count2 * 0.5 + 20;
            
            [self.waveform drawLine];
            
            [self.waveform setNeedsDisplay];
        }
    }
    
    
    //计时显示
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)self.timerNum2 / 60, (NSInteger)self.timerNum2 % 60];
    
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



@end
