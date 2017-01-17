//
//  NSSoundEffectViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/16.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSoundEffectViewController.h"
#import "NSPublicLyricViewController.h"
#import "NSTunMusicModel.h"
#import <AVFoundation/AVFoundation.h>
#import "NSCooperationDetailModel.h"


#import "IAYMediaPlayer.h"
#import "YCBaseEffectWrap.h"
#import "YCPcmPlayerWrap.h"
#import "AyMovieGLView.h"
#include "PCCallback.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioRecord.h"
#import "YCMp3encWrap.h"
#import "YCPlayPCMCallback.h"

char *input_path ;
char *output_path;
@interface NSSoundEffectViewController ()<UIAlertViewDelegate,AVAudioPlayerDelegate,UIScrollViewDelegate>
{
    UILabel *totalTimeLabel;
    
    UIButton *auditionBtn;
    
    NSString *_playerUrl;
    
    //原声
    NSString *_tuningUrl0;
    //专业
    NSString *_tuningUrl1;
    //唱将
    NSString *_tuningUrl2;
    //魔音
    NSString *_tuningUrl3;
    //卡拉ok
    NSString *_tuningUrl4;
    
    NSTimer *timer;
    
    CGFloat num, a,speed;
    
    long _effectId;
    
    BOOL decelerate;
    
    CGFloat timerNum;
    
    CBaseEffectWrap *_effectWrap;
    CYCPcmPlayerWrap *_pYCPcmPlayer;
}


@property (nonatomic, strong) NSWaveformView *waveform;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) AVPlayerItem *musicItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong)  CADisplayLink *link;
@property (nonatomic, strong)  CADisplayLink *waveLink;
@property (nonatomic, strong) NSMutableArray *waveViewArr;


@property (nonatomic, copy) NSString *encMP3UploadUrl;
@property (nonatomic, copy) NSString *encMP3FilePath;
@property (nonatomic, strong) NSData *data;


@end

@implementation NSSoundEffectViewController
- (UIAlertView *)alertView {
    if (!_alertView) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"歌曲正在美化,请稍后..." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    }
    return _alertView;
}
- (NSMutableArray *)waveViewArr {
    if (!_waveViewArr) {
        self.waveViewArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _waveViewArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AVAudioSession * session =[ AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    decelerate = YES;
    _effectId = 0;
    speed = ScreenWidth/10.0;
    
    [self setupSoundEffectUI];
    [self setupOutputPaths];
    [self addLink];
    [self addWaveLink];
    [self.link setPaused:YES];
    [self.waveLink setPaused:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlaying)
                                                 name:@"pausePlayer"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlaying) name:AVAudioSessionInterruptionNotification object:nil];
    [self addObserver:self forKeyPath:@"soundEffectPlay" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self endPlaying];
}
#pragma mark -fetchData
//获取合成音频
- (void)fetchTuningMusic {
    
    
    
    
//    [self.alertView show];
    
    self.requestType = NO;
    
    self.requestParams = @{@"createtype":@"HOT",@"hotid":self.parameterDic[@"hotID"],@"uid":JUserID,@"recordingsize":@(1),@"bgmsize":@(1),@"useheadset":@(0),@"musicurl":self.encMP3UploadUrl,@"effect":@(_effectId),@"token":LoginToken};
    self.requestURL = tunMusicURL;
    
    
}
#pragma mark --override action fetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        [[NSToastManager manager] showtoast:@"系统繁忙"];
    } else {
        if (!parserObject.success) {
            [[NSToastManager manager] showtoast:@"上传成功"];

            [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
            if ([operation.urlTag isEqualToString:tunMusicURL]) {
                NSTunMusicModel * tunMusic = (NSTunMusicModel *)parserObject;
                

//                [self setupMusicUrlWithId:_effectId path:tunMusic.tunMusicModel.MusicPath];
                
                self.waveform.timeScrollView.userInteractionEnabled=YES;
                NSPublicLyricViewController *publicVC = [[NSPublicLyricViewController alloc] initWithLyricDic:self.parameterDic withType:NO];
                
                publicVC.isLyric=NO;
                publicVC.mp3URL = self.encMP3UploadUrl;
                publicVC.mp3File = self.encMP3FilePath;
                if (self.coWorkModel.lyrics.length) {
                    publicVC.coWorkModel = self.coWorkModel;
                }
                
                
                [self.navigationController pushViewController:publicVC animated:YES];
  
            }
        }
    }
}

- (void)setupMusicUrlWithId:(NSInteger)myEffectId path:(NSString *)path{
    
    switch (myEffectId) {
        case 0:
            _tuningUrl0 = path;
            break;
        case 1:
            _tuningUrl1 = path;
            break;
        case 2:
            _tuningUrl2 = path;
            break;
        case 3:
            _tuningUrl3 = path;
            break;
        case 4:
            _tuningUrl4 = path;;
        default:
            break;
    }
}

- (NSString *)setupOutputPaths{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *pcmFilePath = [NSString stringWithFormat:@"%@/EffectPath",docPath];
    if (![[NSFileManager defaultManager]  fileExistsAtPath:pcmFilePath]) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager createDirectoryAtPath:pcmFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        
    }
    _tuningUrl0 = [NSString stringWithFormat:@"%@/%@",pcmFilePath,@"original.pcm"];
    _tuningUrl1 = [NSString stringWithFormat:@"%@/%@",pcmFilePath,@"pfofissional.pcm"];
    _tuningUrl2 = [NSString stringWithFormat:@"%@/%@",pcmFilePath,@"singer.pcm"];
    _tuningUrl3 = [NSString stringWithFormat:@"%@/%@",pcmFilePath,@"magical.pcm"];
    _tuningUrl4 = [NSString stringWithFormat:@"%@/%@",pcmFilePath,@"ktv.pcm"];

    return pcmFilePath;

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
//            [[NSHttpClient client] cancelRequest];
//            [[NSToastManager manager] showtoast:@"美化失败"];
            break;
            
        default:
            break;
    }
}

- (void)setupSoundEffectUI {
    
    self.title = @"音效";
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick:)];
    
    self.navigationItem.rightBarButtonItem = next;
    
    auditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    auditionBtn.frame = CGRectMake(15, 20, 84, 84);
    
    auditionBtn.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
    
    [auditionBtn setImage:[UIImage imageNamed:@"2.0_audition_play"] forState:UIControlStateNormal];
    
    [auditionBtn setImage:[UIImage imageNamed:@"2.0_audition_pause"] forState:UIControlStateSelected];
    
    [auditionBtn addTarget:self action:@selector(playAudition:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:auditionBtn];
    
    self.waveform = [[NSWaveformView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(auditionBtn.frame), 20, ScreenWidth-114, 84)];
    
    self.waveform.timeScrollView.userInteractionEnabled=NO;
    
    _waveform.timeScrollView.delegate = self;
    
    _waveform.layer.borderWidth = 1;
    
    _waveform.layer.borderColor = [[UIColor hexColorFloat:@"ffd00b"] CGColor];
    
    _waveform.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_waveform];
    
    _waveform.waveView.heightArr = [NSMutableArray arrayWithArray:self.heightArray];
    for (int i = 0; i < self.locationArr.count; i++) {
        CGFloat location = [self.locationArr[i] floatValue];

        location = location - ScreenWidth/2.0 + self.waveform.middleLineV.x;

        [self.locationArr replaceObjectAtIndex:i withObject:@(location)];

    }
//    NSLog(@"self.locationArr  %@",self.locationArr);

    _waveform.waveView.locationsArr = [NSMutableArray arrayWithArray:self.locationArr];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.waveform waveViewShowAllChangedColorWaves];
        
        
    });


    
    totalTimeLabel = [[UILabel alloc] init];
    
    totalTimeLabel.font = [UIFont systemFontOfSize:10];
    
    totalTimeLabel.text = [NSString stringWithFormat:@"/%02zd:%02zd",(NSInteger)self.musicTime/60, (NSInteger)self.musicTime % 60];
    [totalTimeLabel setTextColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:totalTimeLabel];
    
    [totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_waveform.mas_right).offset(-5);
        
        make.bottom.equalTo(_waveform.mas_bottom).offset(-5);
        
    }];
    
    
    self.timeLabel = [[UILabel alloc] init];
    
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    
    self.timeLabel.text = @"00:00";
    [self.timeLabel setTextColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(totalTimeLabel.mas_left);
        
        make.bottom.equalTo(_waveform.mas_bottom).offset(-5);
        
    }];
    
    UILabel *auditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_waveform.frame) + 20, ScreenWidth, 20)];
    
    auditionLabel.textAlignment = NSTextAlignmentCenter;
    
    auditionLabel.text = @"音效";
    
    auditionLabel.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:auditionLabel];
    
    NSArray *titles = @[@"原声",@"专业",@"唱将",@"魔音",@"卡拉OK"];
    
    CGFloat btnW = ScreenWidth / 4;
    
    for (int i = 0; i < 2; i++) {
        
        for (int j = 0; j < 4; j++) {
           
            if (i * 4 + j < 5) {
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * j, CGRectGetMaxY(auditionLabel.frame) + 10 + (btnW + 20) * i, btnW, btnW)];
                
                NSString *imageStr = [NSString stringWithFormat:@"2.0_audition_btn%d",i * 4 + j];
                NSString *imgStrSelect = [NSString stringWithFormat:@"2.0_audition_btn%d_select",i * 4 + j];
                [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
                
                [btn setImage:[UIImage imageNamed:imgStrSelect] forState:UIControlStateSelected];
                
                btn.tag = 170 + i * 4 + j;
                
                [btn addTarget:self action:@selector(auditionBtn:) forControlEvents:UIControlEventTouchUpInside];
                if (i * 4 + j == 0) {
                    
                    btn.selected = YES;
                    
                }
                [self.btns addObject:btn];
                
                [self.view addSubview:btn];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btnW * j, CGRectGetMaxY(btn.frame)-10, btnW, 20)];
                
                label.text = titles[i * 4 + j];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                [self.view addSubview:label];
            }
            
        }
        
    }
    
}
- (void)auditionBtn:(UIButton *)sender {
    
    [self.alertView show];
    
    [self endPlaying];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = self.btns[i];
        if (sender.tag - 170 == i) {
            sender.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    _effectId = sender.tag - 170;
    int YCEffectId = 0;
    switch (sender.tag) {
        case 170:
            if (_tuningUrl0.length) {
                _playerUrl = self.recordPCMPath;
                YCEffectId = YC_EFFECTS_NORMAL;
/*
                [self fetchTuningMusic];
            } else {
                _playerUrl = _tuningUrl0;
            }
 */
            }
            break;
         case 171:
            if (_tuningUrl1.length) {
                _playerUrl = _tuningUrl1;
                YCEffectId = YC_EFFECTS_PROFEESSION;
            }
            break;
        case 172:
            if (_tuningUrl2.length) {
                _playerUrl = _tuningUrl2;
                YCEffectId = YC_EFFECTS_SINGER;
            }
            break;
        case 173:
            if (_tuningUrl3.length) {
                _playerUrl = _tuningUrl3;
                YCEffectId = YC_EFFECTS_MAGIC;
            }
            break;
        case 174:
            if (_tuningUrl4.length) {
                _playerUrl = _tuningUrl4;
                YCEffectId = YC_EFFECTS_KTV;
            }
            break;
        default:
            break;
    }
    [self doEffectWithEffectWithEffectId:YCEffectId OutPutPath:_playerUrl];
    
    
    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (_pYCPcmPlayer) {
        //先跳到原来位置 播放
        _pYCPcmPlayer->seek(timerNum*1000);
        _pYCPcmPlayer->resume();
    }
    [self.waveform.timeScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)doEffectWithEffectWithEffectId:(int)eYcEffect OutPutPath:(NSString *)outputPath{
    
    
    double sampleRate = 44100 ;
    int channels = 1;
    int sampleBit = 16 ;
    
    _effectWrap = new CBaseEffectWrap(sampleRate,channels,sampleBit);
//    NSString *outputPath = @"/Users/jupeng/Desktop/EffectFile/magicEffect.pcm";
    output_path = (char *)[outputPath UTF8String];
    
    input_path = (char *)[self.recordPCMPath UTF8String];
    _effectWrap->setEffectParams(eYcEffect, input_path, output_path);
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    _effectWrap->doEffect();
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"effect do cost time is  %0.3f", end - start);
    _effectWrap->destroy();
}

- (void)playAudition:(UIButton *)sender {
    
    NSString *host;
    
#ifdef DEBUG
    host = debugHost;
#else
    host = releasePort;
#endif
    /**
     *  测试lame转换的mp3
     */
//    if (!sender.selected) {
//        self.waveform.timeScrollView.userInteractionEnabled=NO;
//
//        NSString *url = [NSString stringWithFormat:@"%@%@",host,self.mp3URL];
//        [self listenMp3Online: url ];
//
//    }else{
//        [self pausePlaying];
//
//    }
//
//    return;
    //开始未被选中
    if (!sender.selected) {
        
        self.waveform.timeScrollView.userInteractionEnabled=NO;
        if (!_playerUrl.length) {
            
            _playerUrl = self.recordPCMPath;
        }
        
        if (_pYCPcmPlayer) {
            _pYCPcmPlayer->resume();

        }else{
            [self newPlayWithRecordUrl:_playerUrl AccompanyUrl:self.accompanyPCMPath withTIme:-1];

        }
        /*
        if (playerUrl.length) {
            
            NSString* url = [NSString stringWithFormat:@"%@%@",host,playerUrl];
            
            [self listenMp3Online:url];
            
        } else {
            
            [self fetchTuningMusic];
            
            return;
           
        }
         */
        
    } else {
        
        [self pausePlaying];
    }
    sender.selected = !sender.selected;
}

- (void)newPlayWithRecordUrl:(NSString *)recordUrl AccompanyUrl:(NSString *)accompanyUrl withTIme:(NSTimeInterval)time{
    dispatch_async ( dispatch_get_global_queue ( DISPATCH_QUEUE_PRIORITY_DEFAULT , 0 ), ^{
        //Fire api
        AyMovieGLView *playWindow = [[AyMovieGLView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 240.0)];
        
        YCCallback *pYCcallback = new YCCallback();
        
        CYCPcmPlayerWrap *pYCPcmPlayer = new CYCPcmPlayerWrap((__bridge void *)playWindow, pYCcallback);
        YCPlayPCMCallback *PCMCallBack = [YCPlayPCMCallback sharedPlayMusic];
        PCMCallBack.PCMPlayerBlock = ^(NSString *statusStr){
            NSLog(@"%@",statusStr);
            
            if ([statusStr isEqualToString:@"finish"]) {
                
                [self endPlaying];
                

            }else if ([statusStr isEqualToString:@"PREPARED"]){
                
            }else if ([statusStr isEqualToString:@"start"]){
                [self.waveLink setPaused:NO];
                [self.link setPaused:NO];
                
            }else if([statusStr isEqualToString:@"stop"]){
                
                [self endPlaying];

                
            }else if ([statusStr isEqualToString:@"pause"]){
                
            }else if ([statusStr isEqualToString:@"resume"]){
                [self.waveLink setPaused:NO];
                [self.link setPaused:NO];
            }
        };
        AYMediaAudioFormat recordFormat;
        recordFormat.nSamplesPerSec=44100;
        recordFormat.nChannels =2;
        recordFormat.wBitsPerSample =16;
        
        //        sleep(3);
        
        AYMediaAudioFormat backGroudFormat;
        backGroudFormat.nSamplesPerSec=44100;
        backGroudFormat.nChannels =2;
        backGroudFormat.wBitsPerSample =16;
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        
        NSString *fullPath = [NSString stringWithFormat:@"%@/record.pcm", bundlePath];
        
        //        NSString *fullPath = [NSString stringWithFormat:@"%@/11.pcm", bundlePath];
        
        
        char *bgmFullPath = NULL;
        
        
        if (accompanyUrl) {
            NSString *path2 = accompanyUrl;
            //        [[NSBundle mainBundle] pathForResource:@"accompany" ofType:@"pcm"];
            
            bgmFullPath= (char *)[path2 UTF8String];
        }
        
        NSString *wavPath = recordUrl;
        
        char *recordFileFullPath = (char *)[wavPath UTF8String]; ;
        
        _pYCPcmPlayer = pYCPcmPlayer;
        
        pYCPcmPlayer->setVolume(0, 50);
        pYCPcmPlayer->setVolume(1,60);
        pYCPcmPlayer->setDataSourece(recordFileFullPath,recordFormat,bgmFullPath,backGroudFormat);
        //        0 录音 1是伴奏

        sleep(600);
    });
}

- (void)audioWorkAuditionEndProcess{
    
}

- (void)listenMp3Online:(NSString*)mp3Url{
//    NSString* urlString = @"http://api.yinchao.cn/uploadfiles2/2016/07/22/20160722165746979_out.mp3";
    
    NSURL* url = [NSURL URLWithString:mp3Url];
    if (!self.musicItem||!self.player) {
        
        self.musicItem = [AVPlayerItem playerItemWithURL:url];
        
        self.player = [AVPlayer playerWithPlayerItem:self.musicItem];
    }
//    //重新计算时长和速度
    NSLog(@" CMTimeGetSeconds(self.musicItem.asset.duration %f",CMTimeGetSeconds(self.musicItem.asset.duration));
    self.musicTime = CMTimeGetSeconds(self.musicItem.asset.duration);
    totalTimeLabel.text = [NSString stringWithFormat:@"/%02zd:%02zd",(NSInteger)self.musicTime/60, (NSInteger)self.musicTime % 60];
    if (self.musicTime) {
        speed = ([self.locationArr.lastObject floatValue] - self.waveform.middleLineV.x)/ self.musicTime;
    }
    [self.player play];
    [self.waveLink setPaused:NO];
    [self.link setPaused:NO];
}
- (void)pausePlaying {
    
    decelerate = YES;
    
    [self.waveLink setPaused:YES];
    
    [self.link setPaused:YES];
    
//    [self.player pause];
    _pYCPcmPlayer->pause();
    
    self.waveform.timeScrollView.userInteractionEnabled=YES;
    [self.waveform waveViewShowAllChangedColorWaves];

    
}
- (void)endPlaying {
    
    
    decelerate = YES;
    
    timerNum = 0;
    
//    self.timeLabel.text = @"00:00";
    
    [self.link setPaused:YES];
    
    [self.waveLink setPaused:YES];
    
    auditionBtn.selected = NO;
    
//    [self.player pause];
    if (_pYCPcmPlayer) {
        _pYCPcmPlayer->pause();
        _pYCPcmPlayer = nil;

    }
    
    self.musicItem = nil;
    
    self.player =nil;
    
    self.waveform.timeScrollView.userInteractionEnabled=NO;
}
- (void)nextClick:(UIButton *)sender {

    
    [self processPCMToMp3];
    [NSTool checkNetworkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"notReachable"] || [networkStatus isEqualToString:@"unKnown"]) {
            //无网络
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            [self uploadMusic];
            
        }
    }];
    

    /*
    if (_playerUrl.length) {
        
        NSPublicLyricViewController *publicVC = [[NSPublicLyricViewController alloc] initWithLyricDic:self.parameterDic withType:NO];
        
        publicVC.isLyric=NO;
        publicVC.mp3URL = _playerUrl;
        publicVC.mp3File = self.mp3File;
        if (self.coWorkModel.lyrics.length) {
            publicVC.coWorkModel = self.coWorkModel;
        }
        
        
        [self.navigationController pushViewController:publicVC animated:YES];
        
    } else {
        
        [self fetchTuningMusic];
    }
    */
    

}

- (void)processPCMToMp3{
    self.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"歌曲正在合成,请稍后..." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];

    [self.alertView show];

    //生成MP3
    AYMediaAudioFormat recordFormat;
    recordFormat.nSamplesPerSec=44100;
    recordFormat.nChannels =2;
    recordFormat.wBitsPerSample =16;
    
    AYMediaAudioFormat backGroudFormat;
    backGroudFormat.nSamplesPerSec=44100;
    backGroudFormat.nChannels =2;
    backGroudFormat.wBitsPerSample =16;
    
    
    NSString *mp3FilePath = LocalEncMp3Path;
    if (![[NSFileManager defaultManager]  fileExistsAtPath:mp3FilePath]) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager createDirectoryAtPath:mp3FilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmm"];
    NSString *createTime = [dateFormatter stringFromDate:date];
    self.encMP3FilePath = [NSString stringWithFormat:@"%@/%@.mp3",mp3FilePath,createTime];
    NSString *path = self.encMP3FilePath;
    //    @"/Users/jupeng/Desktop/savedFile/output.MP3" ;
    char *outputPath = (char *)[path UTF8String];
    //    (char *)[mp3FilePath UTF8String];
    if (!_playerUrl.length) {
        _playerUrl = self.recordPCMPath;
    }
    
    //    NSString *localPath = @"/Users/jupeng/Desktop/JuPengMusic.caf";
    char *input_recordPath = (char *)[_playerUrl UTF8String];
    char *input_bgmPath = (char *)[self.accompanyPCMPath UTF8String];
    
    
    CYCMp3encWrap *wrap = new CYCMp3encWrap(input_recordPath,recordFormat,100,input_bgmPath,backGroudFormat,50);
    
    
    
    wrap->saveMp3(outputPath);
    
    //    sleep(600);
    
    
    //合成MP3完成  作品信息保存
    /*
     * [self.dict setValue:titleText.text forKey:@"lyricName"];
     [self.dict setValue:lyricView.lyricText.text forKey:@"lyric"];
     [self.dict setValue:[NSString stringWithFormat:@"%ld",hotId] forKey:@"hotID"];
     [self.dict setValue:[NSNumber numberWithBool:plugedHeadset] forKey:@"isHeadSet"];
     
     soundEffectVC.parameterDic = self.dict;
     
     */
    //生成 MP3路径保存
    [self.parameterDic setValue:self.encMP3FilePath forKey:@"encMP3FilePath"];
    
    NSString *jsonStr = [NSTool transformTOjsonStringWithObject:self.parameterDic];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:LocalFinishMusicWorkListKey]) {
        
        [fileManager createFileAtPath:LocalFinishMusicWorkListKey contents:nil attributes:nil];
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:LocalFinishMusicWorkListKey] ];
    if (!resultArray) {
        resultArray = [NSMutableArray array];
    }
    if (![resultArray containsObject:jsonStr]) {
        [resultArray addObject:jsonStr];
        
    }
    //写入
    [resultArray writeToFile:LocalFinishMusicWorkListKey atomically:YES];
    
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
}

#pragma mark - 上传音频
- (void)uploadMusic{
    WS(wSelf);


    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"歌曲正在上传,请稍后..." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [self.alertView show];

    //后台执行mp3转换和上传
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        

        //        NSData *data = [NSData dataWithContentsOfFile:self.mp3Path];
        self.data=[NSData dataWithContentsOfFile:self.encMP3FilePath];
        
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
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];

                self.encMP3UploadUrl = dict[@"data"][@"mp3URL"];
                [self fetchTuningMusic];
            } else {
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                    [[NSToastManager manager] showtoast:@"上传失败"];
            }
            //self.wavFilePath = nil;
        } failure:^void(NSURLSessionDataTask * task, NSError * error) {
            // 请求失败
            [self.alertView dismissWithClickedButtonIndex:0 animated:YES];


            
            //self.next.enabled = YES;
        }];
        
        
        
    });
    
}
#pragma mark -OptionMusic


- (void)addLink {
    
    if (!self.link)
    {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionTiming)];
        
        self.link.frameInterval=4;
        
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)addWaveLink {
    
    if (!self.waveLink)
    {
        self.waveLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTimeView)];
        
        self.waveLink.frameInterval = 4;
        
        [self.waveLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}
- (void)actionTiming {
    
    /*
    CGFloat currentSecond = self.musicItem.currentTime.value/self.musicItem.currentTime.timescale;
    if (self.musicItem.currentTime.value) {
        self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
        
        timerNum += 1/15.0;
        [self changeScrollViewColor];
    }
     */
    timerNum += 1/15.0;
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];



}
- (void)scrollTimeView{

    /*
    if (self.musicItem.currentTime.value) {
        decelerate = NO;
        
        [self.waveform.timeScrollView setContentOffset:CGPointMake(speed*timerNum, 0) animated:NO];
        
    }
     */
    self.waveform.waveView.waveDistance =speed*timerNum;
    

    [self.waveform.timeScrollView setContentOffset:CGPointMake(self.waveform.waveView.waveDistance, 0) animated:NO];
    
}

- (void)changeScrollViewColor{
    dispatch_async(dispatch_get_main_queue(), ^{

        self.waveform.waveView.waveDistance = self.waveform.timeScrollView.contentOffset.x ;

        [self.waveform waveViewChangingWavesColor];

        
        
    });
}

#pragma mark - UIScrollViewDelegate





- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (decelerate) {
       
        timerNum = scrollView.contentOffset.x/speed;

        //获取到有多少个  1/15 单位时间坐标
        NSInteger timeScaleCount = round(timerNum /(1/15.0));
        CMTime ctime = CMTimeMake(timeScaleCount, 15);
        //实际时间
        timerNum = timeScaleCount/15.0;
        
        [self.musicItem seekToTime:ctime];
        self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
        
        [self changeScrollViewColor];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (decelerate) {
        
        timerNum = scrollView.contentOffset.x/speed;
        
        //获取到有多少个  1/15 单位时间坐标
        NSInteger timeScaleCount = round(timerNum /(1/15.0));
        CMTime ctime = CMTimeMake(timeScaleCount, 15);
        //实际时间
        timerNum = timeScaleCount/15.0;
        
        [self.musicItem seekToTime:ctime];
        NSLog(@"nowTime %f CMTimeMake %lld  time %f",ctime.value/(ctime.timescale*1.0),ctime.value,timerNum);
        self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
        
        [self changeScrollViewColor];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [self changeScrollViewColor];
}

- (void)dealloc{
    
    [self removeObserver:self forKeyPath:@"soundEffectPlay" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
}
- (NSMutableArray *)btns {
    if (!_btns) {
        self.btns = [NSMutableArray arrayWithCapacity:5];
    }
    return _btns;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
