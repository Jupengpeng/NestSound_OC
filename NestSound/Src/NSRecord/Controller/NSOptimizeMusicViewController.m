//
//  NSOptimizeMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSOptimizeMusicViewController.h"
#import "NSDrawLineView.h"
#import "NSLyricView.h"

@interface Line1 : UIView

@end

@implementation Line1

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


@interface NSOptimizeMusicViewController () {
    
    UIImageView *slideBarImage;
    
    UILabel *timeLabel;
    
    UITextField *titleText;
    
    NSLyricView *lyricView;
}

@end

@implementation NSOptimizeMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    
    [self setupUI];
    
}

- (void)setupUI {
    
    
    UIView *bottomView = [[UIView alloc] init];
    
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        
        make.height.mas_equalTo(72);
    }];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_play_beautify"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
    }];
    
    [bottomView addSubview:playBtn];
    
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bottomView.mas_top).offset((72 - 24) / 3 + 6);
        
        make.left.equalTo(bottomView.mas_left).offset(15);
    }];
    
    UILabel *playLabel = [[UILabel alloc] init];
    
    playLabel.text = @"播放";
    
    playLabel.font = [UIFont systemFontOfSize:12];
    
    [bottomView addSubview:playLabel];
    
    [playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(playBtn.mas_centerX);
        
        make.bottom.equalTo(bottomView.mas_bottom).offset(-(72 - 24) / 3);
    }];
    
    
    UIButton *optimizeBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
       
        [btn setImage:[UIImage imageNamed:@"Switch_off"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"Switch_on"] forState:UIControlStateSelected];
        
        [btn setAdjustsImageWhenHighlighted:NO];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
    }];
    
    
    [bottomView addSubview:optimizeBtn];
    
    [optimizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(playBtn.mas_centerY);
        
        make.left.equalTo(playBtn.mas_right).offset(30);
    }];

    
    UILabel *optimizeLabel = [[UILabel alloc] init];
    
    optimizeLabel.text = @"一键美化";
    
    optimizeLabel.font = [UIFont systemFontOfSize:12];
    
    [bottomView addSubview:optimizeLabel];
    
    [optimizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(optimizeBtn.mas_centerX);
        
        make.centerY.equalTo(playLabel.mas_centerY);
    }];

    
    //人声
    UILabel *voiceLabel = [[UILabel alloc] init];
    
    voiceLabel.font = [UIFont systemFontOfSize:12];
    
    voiceLabel.text = @"人声";
    
    [bottomView addSubview:voiceLabel];
    
    [voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo((72 - 24) / 3);
        
        make.left.equalTo(optimizeBtn.mas_right).offset(30);
        
    }];
    
    //伴奏
    UILabel *accompanyLabel = [[UILabel alloc] init];
    
    accompanyLabel.font = [UIFont systemFontOfSize:12];
    
    accompanyLabel.text = @"伴奏";
    
    [bottomView addSubview:accompanyLabel];
    
    [accompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(bottomView.mas_bottom).offset(-(72 - 24) / 3);
        
        make.left.equalTo(optimizeBtn.mas_right).offset(30);
        
    }];
    
    //人声大小
    UISlider *voiceSlider = [[UISlider alloc] init];
    
    [voiceSlider setThumbImage:[UIImage imageNamed:@"2.0_writeMusic_round"] forState:UIControlStateNormal];
    
    voiceSlider.minimumTrackTintColor = [UIColor hexColorFloat:@"ffd705"];
    
    voiceSlider.value = 0.5;
    
    [bottomView addSubview:voiceSlider];
    
    [voiceSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(voiceLabel.mas_centerY);
        
        make.left.equalTo(voiceLabel.mas_right).offset(10);
        
        make.right.equalTo(bottomView.mas_right).offset(-15);
    }];
    
    //伴奏大小
    UISlider *accompanySlider = [[UISlider alloc] init];
    
    [accompanySlider setThumbImage:[UIImage imageNamed:@"2.0_writeMusic_round"] forState:UIControlStateNormal];
    
    accompanySlider.minimumTrackTintColor = [UIColor hexColorFloat:@"ffd705"];
    
    accompanySlider.value = 0.5;
    
    [bottomView addSubview:accompanySlider];
    
    [accompanySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(accompanyLabel.mas_centerY);
        
        make.left.equalTo(accompanyLabel.mas_right).offset(10);
        
        make.right.equalTo(bottomView.mas_right).offset(-15);
    }];
    
    
    
    Line1 * bottomLine = [[Line1 alloc] init];
    
    [self.view addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    Line1 * upLine = [[Line1 alloc] init];
    
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
        
        make.centerX.equalTo(self.view.mas_centerX);
        
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
    
    titleText.enabled = NO;
    
    titleText.text = self.titleStr;
    
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
    
    lyricView.lyricText.text = self.lyricStr;
    
    [self.view addSubview:lyricView];
    
}


- (void)rightClick:(UIBarButtonItem *)right {
}


@end






