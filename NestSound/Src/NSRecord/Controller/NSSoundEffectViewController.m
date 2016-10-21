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
@interface NSSoundEffectViewController ()<UIAlertViewDelegate,AVAudioPlayerDelegate,UIScrollViewDelegate>
{
    UILabel *totalTimeLabel;
    
    UIButton *auditionBtn;
    
    NSString *playerUrl;
    
    NSString *tuningUrl0;
    
    NSString *tuningUrl1;
    
    NSString *tuningUrl2;
    
    NSString *tuningUrl3;
    
    NSString *tuningUrl4;
    
    NSTimer *timer;
    
    int num, a,speed;
    
    long effectId;
    
    BOOL decelerate;
    
    CGFloat timerNum;
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
    effectId = 0;
    speed = ScreenWidth/10.0;
    
    [self setupSoundEffectUI];
    
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
    
    [self.alertView show];
    
    self.requestType = NO;
    
    self.requestParams = @{@"createtype":@"HOT",@"hotid":self.parameterDic[@"hotID"],@"uid":JUserID,@"recordingsize":@(1),@"bgmsize":@(1),@"useheadset":@(1),@"musicurl":self.mp3URL,@"effect":@(effectId),@"token":LoginToken};
    self.requestURL = tunMusicURL;
    
}
#pragma mark --override action fetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        [[NSToastManager manager] showtoast:@"系统繁忙"];
    } else {
        if (!parserObject.success) {
            [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
            if ([operation.urlTag isEqualToString:tunMusicURL]) {
                NSTunMusicModel * tunMusic = (NSTunMusicModel *)parserObject;
                
                playerUrl = tunMusic.tunMusicModel.MusicPath;

                
                self.waveform.timeScrollView.userInteractionEnabled=YES;
                
                switch (effectId) {
                    case 0:
                        tuningUrl0 = tunMusic.tunMusicModel.MusicPath;
                        break;
                    case 1:
                        tuningUrl1 = tunMusic.tunMusicModel.MusicPath;
                        break;
                    case 2:
                        tuningUrl2 = tunMusic.tunMusicModel.MusicPath;
                        break;
                    case 3:
                        tuningUrl3 = tunMusic.tunMusicModel.MusicPath;
                        break;
                    case 4:
                        tuningUrl4 = tunMusic.tunMusicModel.MusicPath;;
                    default:
                        break;
                }
            }
        }
    }
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
    _waveform.waveView.locationsArr = [NSMutableArray arrayWithArray:self.locationArr];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.waveform.waveView.drawRectStyle = WaveViewDrawRectStyleShowAll;
        [self.waveform.waveView setNeedsDisplay];
        
    });
//    for (int i = 0; i < self.waveArray.count; i++) {
//        UIView *waveView = [UIView new];
//        UIView *view = self.waveArray[i];
//        waveView.backgroundColor = [UIColor lightGrayColor];
//        waveView.x = view.x - ScreenWidth/2 + self.waveform.middleLineV.x;
//        waveView.y = _waveform.waveView.centerY -view.size.height/2.0 - 0.2;
//        waveView.height = view.size.height;
//        waveView.width = 1.0;
//        [self.waveViewArr addObject:waveView];
//        CHLog(@"第%d个%@",i,view);
//        [_waveform.timeScrollView addSubview:waveView];
//    }

    
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
    
    [self endPlaying];
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = self.btns[i];
        if (sender.tag - 170 == i) {
            sender.selected = YES;
        } else {
            
            btn.selected = NO;
        }
    }
    effectId = sender.tag - 170;
    switch (sender.tag) {
        case 170:
            if (!tuningUrl0.length) {
                [self fetchTuningMusic];
            } else {
                playerUrl = tuningUrl0;
            }
            break;
         case 171:
            if (!tuningUrl1.length) {
                [self fetchTuningMusic];
            } else {
                playerUrl = tuningUrl1;
            }
            break;
        case 172:
            if (!tuningUrl2.length) {
                [self fetchTuningMusic];
            } else {
                playerUrl = tuningUrl2;
            }
            break;
        case 173:
            if (!tuningUrl3.length) {
                [self fetchTuningMusic];
            } else {
                playerUrl = tuningUrl3;
            }
            break;
        case 174:
            if (!tuningUrl4.length) {
                [self fetchTuningMusic];
            } else {
                playerUrl = tuningUrl4;
            }
            break;
        default:
            break;
    }
    
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
    if (!sender.selected) {
        
        self.waveform.timeScrollView.userInteractionEnabled=NO;
        
        if (playerUrl.length) {
            
            NSString* url = [NSString stringWithFormat:@"%@%@",host,playerUrl];
            
            [self listenMp3Online:url];
            
        } else {
            
            [self fetchTuningMusic];
            
            return;
           
        }
        
    } else {
        
        [self pausePlaying];
    }
    sender.selected = !sender.selected;
}
- (void)listenMp3Online:(NSString*)mp3Url{
//    NSString* urlString = @"http://api.yinchao.cn/uploadfiles2/2016/07/22/20160722165746979_out.mp3";
    
    NSURL* url = [NSURL URLWithString:mp3Url];
    if (!self.musicItem||!self.player) {
        
        self.musicItem = [AVPlayerItem playerItemWithURL:url];
        
        self.player = [AVPlayer playerWithPlayerItem:self.musicItem];
    }
    
    [self.player play];
    [self.waveLink setPaused:NO];
    [self.link setPaused:NO];
}
- (void)pausePlaying {
    
    decelerate = YES;
    
    [self.waveLink setPaused:YES];
    
    [self.link setPaused:YES];
    
    [self.player pause];
    
    self.waveform.timeScrollView.userInteractionEnabled=YES;
    self.waveform.waveView.drawRectStyle = WaveViewDrawRectStyleShowChangedAll;
    [self.waveform.waveView setNeedsDisplay];
}
- (void)endPlaying {
    
    
    decelerate = YES;
    
    timerNum = 0;
    
//    self.timeLabel.text = @"00:00";
    
    [self.link setPaused:YES];
    
    [self.waveLink setPaused:YES];
    
    auditionBtn.selected = NO;
    
    [self.player pause];
    
    self.musicItem = nil;
    
    self.player =nil;
    
    self.waveform.timeScrollView.userInteractionEnabled=NO;
}
- (void)nextClick:(UIButton *)sender {
    if (playerUrl.length) {
        
        NSPublicLyricViewController *publicVC = [[NSPublicLyricViewController alloc] initWithLyricDic:self.parameterDic withType:NO];
        
        publicVC.isLyric=NO;
        publicVC.mp3URL = playerUrl;
        publicVC.mp3File = self.mp3File;
        
        [self.navigationController pushViewController:publicVC animated:YES];
        
    } else {
        
        [self fetchTuningMusic];
    }
    
}
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
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)timerNum/60, (NSInteger)timerNum % 60];
    [self changeScrollViewColor];


}
- (void)scrollTimeView{

    if (self.player.status == AVPlayerStatusReadyToPlay) {
        decelerate = NO;
        
        [self.waveform.timeScrollView setContentOffset:CGPointMake(speed*timerNum, 0) animated:NO];

        
      
        timerNum += 1/15.0;

    }

    
}

- (void)changeScrollViewColor{
    dispatch_async(dispatch_get_main_queue(), ^{
        //-8 的作用是修正 原因暂时未知

        self.waveform.waveView.waveDistance =self.waveform.timeScrollView.contentOffset.x - 8;
        self.waveform.waveView.drawRectStyle = WaveViewDrawRectStyleChangeColor;
        [self.waveform.waveView setNeedsDisplay];
        
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (decelerate) {
       
        timerNum = scrollView.contentOffset.x/speed;

        CMTime ctime = CMTimeMake(scrollView.contentOffset.x/speed, 1);
        
        [self.musicItem seekToTime:ctime];
        
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
