//
//  NSSoundEffectViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/16.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSoundEffectViewController.h"
#import "NSPublicLyricViewController.h"
//#import "NSWaveformView.h"
#import "NSTunMusicModel.h"
#import <AVFoundation/AVFoundation.h>
@interface NSSoundEffectViewController ()<UIAlertViewDelegate>
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
}
@property (nonatomic, strong) NSWaveformView *waveform;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) AVPlayerItem *musicItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIAlertView *alertView;
@end

@implementation NSSoundEffectViewController
- (UIAlertView *)alertView {
    if (!_alertView) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"歌曲正在美化,请稍后..." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    }
    return _alertView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
    effectId = 0;
    num = [self.musicTime floatValue];
    speed = 2.4 * self.waveArray.count/[self.musicTime floatValue];
    [self setupSoundEffectUI];
}
#pragma mark -fetchData
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
    
    _waveform.timeScrollView.scrollEnabled = NO;
    
    _waveform.layer.borderWidth = 1;
    
    _waveform.layer.borderColor = [[UIColor hexColorFloat:@"ffd00b"] CGColor];
    
    _waveform.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_waveform];
    for (int i = 0; i < self.waveArray.count; i++) {
        UIView *waveView = [UIView new];
        UIView *view = self.waveArray[i];
        waveView.backgroundColor = [UIColor lightGrayColor];
        waveView.x = _waveform.middleLineV.x + i*2;
        waveView.y = _waveform.waveView.centerY -view.size.height/2 - 0.2;
        waveView.height = view.size.height;
        waveView.width = 1.0;
        
        [_waveform.timeScrollView addSubview:waveView];
    }
    
    totalTimeLabel = [[UILabel alloc] init];
    
    totalTimeLabel.font = [UIFont systemFontOfSize:10];
    
    totalTimeLabel.text = [NSString stringWithFormat:@"/%@",self.musicTime];
    [totalTimeLabel setTextColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:totalTimeLabel];
    
    [totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_waveform.mas_right).offset(-5);
        
        make.bottom.equalTo(_waveform.mas_bottom).offset(-5);
        
    }];
    
    
    self.timeLabel = [[UILabel alloc] init];
    
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    
    self.timeLabel.text = [NSString stringWithFormat:@"00:00"];
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
    
    host = releaseHost;
    
#endif
    if (!sender.selected) {
        if (playerUrl.length) {
            
            NSString* url = [NSString stringWithFormat:@"%@%@",host,playerUrl];
            
            [self listenMp3Online:url];
            
        } else {
            
            [self fetchTuningMusic];
            return;
            
        }
        
    } else {
        
        [self.player pause];
        
    }
    sender.selected = !sender.selected;
}
- (void)listenMp3Online:(NSString*)mp3Url{
    //NSString* urlString = @"http://api.yinchao.cn/uploadfiles2/2016/07/22/20160722165746979_out.mp3";
    
    NSURL* url = [NSURL URLWithString:mp3Url];
    
    if (!self.musicItem||!self.player) {
        self.musicItem = [AVPlayerItem playerItemWithURL:url];
        self.player = [AVPlayer playerWithPlayerItem:self.musicItem];
    }
    timer = [NSTimer timerWithTimeInterval:0.25 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [self.player play];
    
}
- (void)timerAction {
    num--;
    a ++;
    [self.waveform.timeScrollView setContentOffset:CGPointMake(-a * speed, 0) animated:NO];
    
    if (num == 0) {
        
        num = [self.musicTime floatValue];
        
        [timer invalidate];
    }
}
- (void)endPlaying {
    [self.waveform.timeScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    auditionBtn.selected = NO;
    self.musicItem = nil;
    [self.player pause];
    self.player =nil;
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
- (void)dealloc{
    
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
