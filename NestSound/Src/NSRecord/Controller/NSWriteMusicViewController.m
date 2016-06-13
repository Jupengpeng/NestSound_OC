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


@interface NSWriteMusicViewController () <UIScrollViewDelegate> {
    
    UILabel *totalTimeLabel;
    
    UITextField *titleText;
    
    NSLyricView *lyricView;
}

@property (nonatomic, strong) UIImageView *slideBarImage;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong)  CADisplayLink *link;

@property (nonatomic, assign) CGFloat timerNum;

@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation NSWriteMusicViewController

- (NSMutableArray *)btns {
    
    if (!_btns) {
        
        _btns = [NSMutableArray array];
    }
    
    return _btns;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    
    [self setupUI];
    
    
}




- (void)setupUI {
    
    
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
        
        if (i == 1) {
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_play"] forState:UIControlStateSelected];
        }
        
        if (i == 2) {
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_recording"] forState:UIControlStateSelected];
        }
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btns addObject:btn];
        
        [bottomView addSubview:btn];
    }
    
    //150为伴奏的时长
//    CGFloat scrollW = 150 * 60 + 40;
//    
//    self.waveform = [[NSWaveformScrollView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 200, ScreenWidth, 64)];
//    
//    self.waveform.backgroundColor = [UIColor whiteColor];
//    
//    self.waveform.contentSize = CGSizeMake(scrollW, 64);
//    
//    self.waveform.showsHorizontalScrollIndicator = NO;
//    self.waveform.delegate = self;
//    self.waveform.bounces = NO;
//    
////    self.waveform.userInteractionEnabled = NO;
//    
//    [self.view addSubview:self.waveform];
    
    
//    self.slideBarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_writeMusic_slideBar"]];
    
//    self.slideBarImage.frame = CGRectMake(self.view.width * 0.5 - 3, self.waveform.y, 6, 64);
    
//    [self.view addSubview:self.slideBarImage];
    
    
    totalTimeLabel = [[UILabel alloc] init];
    
    totalTimeLabel.font = [UIFont systemFontOfSize:10];
    
    totalTimeLabel.text = [NSString stringWithFormat:@"/%@",[NSTool stringFormatWithTimeLong:_accompanyModel.mp3Times]];
    
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
    
    titleText.text = @"我的天空";
    
    titleText.enabled = NO;
    
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
    
    lyricView.lyricText.editable = NO;
    
    lyricView.lyricText.text = @"再见我的爱";
    
    [self.view addSubview:lyricView];
    
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn.tag == 0) {
        
        NSImportLyricViewController *importLyric = [[NSImportLyricViewController alloc] init];
        
        [self.navigationController pushViewController:importLyric animated:YES];
        
        NSLog(@"点击了导入歌词");
        
    } else if (btn.tag == 1) {
        
        btn.selected = !btn.selected;
        
        if (btn.selected) {
            
            [self removeLink];
            
            [[XHSoundRecorder sharedSoundRecorder] pausePlaysound];
            
            
        } else {
            
            [self addLink];
            
            [[XHSoundRecorder sharedSoundRecorder] playsound:nil withFinishPlaying:^{
                
                
            }];
        }
        
        NSLog(@"点击了暂停和播放");
        
    } else if (btn.tag == 2) {
        
        btn.selected = !btn.selected;
        
        if (btn.selected) {
            
            UIButton *btn1 = self.btns[1];
            
            btn1.selected = YES;
            
            [self addLink];
            
            [[XHSoundRecorder sharedSoundRecorder] startRecorder:^(NSString *filePath) {
                
                
            }];
            
        } else {
            
            [self removeLink];
            
            [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
            
        }
        
         NSLog(@"点击了录制");
        
    } else if (btn.tag == 3) {
        
        UIButton *btn2 = self.btns[2];
        
        btn2.selected = NO;
        
        self.timeLabel.text = @"00:00";
        
        NSLog(@"点击了重唱");
    } else {
        
        btn.selected = !btn.selected;
        
        if (btn.selected) {
            
            titleText.enabled = YES;
            
            lyricView.lyricText.editable = YES;
            
            NSLog(@"点击了编辑");
        } else {
            
            titleText.enabled = NO;
            
            lyricView.lyricText.editable = NO;
            
            NSLog(@"点击了保存");
        }
        
    }
}


- (void)rightClick:(UIBarButtonItem *)right {
    
    NSOptimizeMusicViewController *optimize = [[NSOptimizeMusicViewController alloc] init];
    
    optimize.titleStr = titleText.text;
    
    optimize.lyricStr = lyricView.lyricText.text;
    
    [self.navigationController pushViewController:optimize animated:YES];
    
    NSLog(@"点击了下一步");
}



/**
 *  添加定时器
 */
- (void)addLink {
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionTiming)];
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}


/**
 *  移除定时器
 */
- (void)removeLink {
    
    [self.link invalidate];
    
    self.link = nil;
    
}

/**
 *  定时器执行
 */
- (void)actionTiming {
    
    //计时数
    self.timerNum += 1/60.0;
    
    //分贝数
    CGFloat count = [[XHSoundRecorder sharedSoundRecorder] decibels];
    
    
    //计时显示
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)self.timerNum / 60, (NSInteger)self.timerNum % 60];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

#pragma mark -setter && getter
-(void)setAccompanyModel:(NSAccommpanyModel *)accompanyModel
{
    _accompanyModel = accompanyModel;

}

@end
