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

@interface Line : UIView

@end

@implementation Line

#pragma mark -override drawRect
-(void)drawRect:(CGRect)rect {
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    
    [path addLineToPoint:CGPointMake(self.width, 0)];
    
    [path setLineWidth:self.width];
    
    [[UIColor hexColorFloat:@"ffd507"] setStroke];
    
//    [[UIColor hexColorFloat:@"ffd507"] setFill];
    
    [path stroke];
}

@end

@interface NSWriteMusicViewController () {
    
    UIImageView *slideBarImage;
    
    UILabel *timeLabel;
    
    UITextField *titleText;
    
    NSLyricView *lyricView;
}

@end

@implementation NSWriteMusicViewController

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
        
        [bottomView addSubview:btn];
    }
    
    
    
    Line * bottomLine = [[Line alloc] init];
    
    [self.view addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    Line * upLine = [[Line alloc] init];
    
    [self.view addSubview:upLine];
    
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLine.mas_top).offset(-61);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
        
    }];
    
    
    slideBarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_writeMusic_slideBar"]];
    
    [self.view addSubview:slideBarImage];
    
    [slideBarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(20);
        
        make.bottom.equalTo(bottomLine.mas_top).offset(3);
        
    }];
    
    
    timeLabel = [[UILabel alloc] init];
    
    timeLabel.font = [UIFont systemFontOfSize:10];
    
    timeLabel.text = [NSString stringWithFormat:@"00:00/02:32"];
    
    [self.view addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.bottom.equalTo(bottomLine.mas_top).offset(-10);
        
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
        
        NSLog(@"点击了导入歌词");
        
    } else if (btn.tag == 1) {
        
        NSLog(@"点击了导入暂停");
    } else if (btn.tag == 2) {
        
        btn.selected = !btn.selected;
        
         NSLog(@"点击了导入录制");
    } else if (btn.tag == 3) {
        
         NSLog(@"点击了导入重唱");
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

@end
