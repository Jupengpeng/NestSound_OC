//
//  NSSoundEffectViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/16.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSoundEffectViewController.h"
#import "NSPublicLyricViewController.h"
#import "NSWaveformView.h"
#import "NSTunMusicModel.h"
#import <AVFoundation/AVFoundation.h>
@interface NSSoundEffectViewController ()
{
    UILabel *totalTimeLabel;
    
    UIButton *auditionBtn;
    
    NSString *playerUrl;
}
@property (nonatomic, strong) NSWaveformView *waveform;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) AVPlayerItem *musicItem;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation NSSoundEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
    
    [self setupSoundEffectUI];
}
#pragma mark -fetchData
- (void)fectTuningMusic {
    
    self.requestType = NO;
    
    self.requestParams = @{@"createtype":@"HOT",@"hotid":self.parameterDic[@"hotID"],@"uid":JUserID,@"recordingsize":@(1),@"bgmsize":@(1),@"useheadset":@(1),@"musicurl":self.mp3URL,@"effect":@(0),@"token":LoginToken};
    self.requestURL = tunMusicURL;
    
}
#pragma mark --override action fetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:tunMusicURL]) {
                NSTunMusicModel * tunMusic = (NSTunMusicModel *)parserObject;
                playerUrl = tunMusic.tunMusicModel.MusicPath;
                
            }
            
        }
    }
}
- (void)setupSoundEffectUI {
    
    self.title = @"音效";
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick:)];
    
    self.navigationItem.rightBarButtonItem = next;
    
    auditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    auditionBtn.frame = CGRectMake(10, 20, 84, 84);
    
    auditionBtn.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
    
    [auditionBtn setImage:[UIImage imageNamed:@"2.0_audition_play"] forState:UIControlStateNormal];
    
    [auditionBtn setImage:[UIImage imageNamed:@"2.0_audition_pause"] forState:UIControlStateSelected];
    
    [auditionBtn addTarget:self action:@selector(playAudition:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:auditionBtn];
    
    self.waveform = [[NSWaveformView alloc] initWithFrame:CGRectMake(94, 20, ScreenWidth-104, 84)];
    
    self.waveform.layer.borderWidth = 0.5;
    
    self.waveform.layer.borderColor = [[UIColor hexColorFloat:@"ffd00b"] CGColor];
    
    self.waveform.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.waveform];
    
    totalTimeLabel = [[UILabel alloc] init];
    
    totalTimeLabel.font = [UIFont systemFontOfSize:10];
    
    totalTimeLabel.text = [NSString stringWithFormat:@"/%@",self.musicTime];
    [totalTimeLabel setTextColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:totalTimeLabel];
    
    [totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.waveform.mas_right).offset(-5);
        
        make.bottom.equalTo(self.waveform.mas_bottom).offset(-5);
        
    }];
    
    
    self.timeLabel = [[UILabel alloc] init];
    
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    
    self.timeLabel.text = [NSString stringWithFormat:@"00:00"];
    [self.timeLabel setTextColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(totalTimeLabel.mas_left);
        
        make.bottom.equalTo(self.waveform.mas_bottom).offset(-5);
        
    }];
    
    UILabel *auditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, ScreenWidth, 20)];
    
    auditionLabel.textAlignment = NSTextAlignmentCenter;
    
    auditionLabel.text = @"音效";
    
    auditionLabel.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:auditionLabel];
    
    NSArray *titles = @[@"原声",@"唱将",@"卡拉OK",@"魔音",@"专业"];
    
    CGFloat btnW = ScreenWidth / 4;
    
    for (int i = 0; i < 2; i++) {
        
        for (int j = 0; j < 4; j++) {
           
            if (i * 4 + j < 5) {
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * j, 160 + btnW * i, btnW, btnW)];
                
                NSString *imageStr = [NSString stringWithFormat:@"2.0_audition_btn%d",i * 4 + j];
                NSString *imgStrSelect = [NSString stringWithFormat:@"2.0_audition_btn%d_select",i * 4 + j];
                [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
                
                [btn setImage:[UIImage imageNamed:imgStrSelect] forState:UIControlStateSelected];
                
                btn.tag = 170 + i * 4 + j;
                
                [btn addTarget:self action:@selector(auditionBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.btns addObject:btn];
                
                [self.view addSubview:btn];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btnW * j, 150 + btnW * (i + 1), btnW, 20)];
                
                label.text = titles[i * 4 + j];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                [self.view addSubview:label];
            }
            
        }
        
    }
    
}
- (void)auditionBtn:(UIButton *)sender {
    for (int i = 0; i < 5; i++) {
        UIButton *btn = self.btns[i];
        if (sender.tag - 170 == i) {
            
            sender.selected = !sender.selected;
        } else {
            
            btn.selected = NO;
        }
    }
    
    switch (sender.tag) {
        case 170:
        {
            
        }
            break;
         case 171:
        {
            
        }
            break;
            case 172:
        {
            
        }
            break;
            case 173:
        {
            
        }
            break;
            case 174:
        {
            
        }
            break;
        default:
            break;
    }
    
}
- (void)playAudition:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    NSString *host;
    
#ifdef DEBUG
    
    host = debugHost;
    
#else
    
    host = releaseHost;
    
#endif
    
    if (sender.selected) {
        if (playerUrl.length) {
            
            NSString* url = [NSString stringWithFormat:@"%@%@",host,playerUrl];
            
            [self listenMp3Online:url];
        } else {
            
            [self fectTuningMusic];
            [[NSToastManager manager] showtoast:@"歌曲正在合成,请稍后..."];
        }
        
    } else {
        
        [self.player pause];
        
    }
    
}
- (void)listenMp3Online:(NSString*)mp3Url{
    //NSString* urlString = @"http://api.yinchao.cn/uploadfiles2/2016/07/22/20160722165746979_out.mp3";
    
    NSURL* url = [NSURL URLWithString:mp3Url];
    
    if (!self.musicItem||!self.player) {
        self.musicItem = [AVPlayerItem playerItemWithURL:url];
        self.player = [AVPlayer playerWithPlayerItem:self.musicItem];
    }
    
    [self.player play];
    
}
- (void)endPlaying {
    
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
        
        [self fectTuningMusic];
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
