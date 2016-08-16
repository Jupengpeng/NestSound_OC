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
@interface NSSoundEffectViewController ()
{
    UILabel *totalTimeLabel;
}
@property (nonatomic, strong) NSWaveformView *waveform;

@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation NSSoundEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSoundEffectUI];
}

- (void)setupSoundEffectUI {
    
    self.title = @"音效";
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick:)];
    
    self.navigationItem.rightBarButtonItem = next;
    
    UIButton *auditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
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
    
    CGFloat btnW = ScreenWidth / 4;
    
    for (int i = 0; i < 2; i++) {
        
        for (int j = 0; j < 4; j++) {
           
            if (i * 4 + j < 5) {
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * j, 160 + btnW * i, btnW, btnW)];
                
                NSString *imageStr = [NSString stringWithFormat:@"2.0_audition_btn%d",i * 4 + j];
                
                [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
                
                [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
                
                btn.tag = i;
                
//                [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //        [self.btns addObject:btn];
                
                [self.view addSubview:btn];
            }
            
        }
        
    }
    
}
- (void)playAudition:(UIButton *)sender {
    
}
- (void)nextClick:(UIButton *)sender {
    
    NSPublicLyricViewController *publicVC = [[NSPublicLyricViewController alloc] initWithLyricDic:self.parameterDic withType:NO];
    
    publicVC.isLyric=NO;
    
    publicVC.mp3File = self.mp3File;
    
    [self.navigationController pushViewController:publicVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
