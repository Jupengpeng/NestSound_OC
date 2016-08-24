//
//  NSDownloadProgressView.m
//  NestSound
//
//  Created by 李龙飞 on 16/7/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDownloadProgressView.h"

@interface  NSDownloadProgressView()<NSHttpClientDelegate>

@end

@implementation NSDownloadProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [NSHttpClient client].delegate = self;
        
        self.layer.cornerRadius = 5;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI {
    
    //标题
    self.titleLab = [UILabel new];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];
    
    //取消按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"2.0_cross"] forState:UIControlStateNormal];
    [self addSubview:_cancelBtn];
    
    //中间提示
    self.messageLab = [UILabel new];
    _messageLab.font = [UIFont systemFontOfSize:15];
    _messageLab.textColor = [UIColor darkGrayColor];
    _messageLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLab];
    
    //进度值
    self.numberLab = [UILabel new];
    _numberLab.text = @"0%";
    _numberLab.font = [UIFont systemFontOfSize:14];
    _numberLab.textAlignment = NSTextAlignmentRight;
    _numberLab.textColor = [UIColor lightGrayColor];
    [self addSubview:_numberLab];
    
    //进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _progressView.progress = 0.0;
//    _progressView.trackTintColor = [UIColor hexColorFloat:@"#ffeda5"];
//    _progressView.progressTintColor = [UIColor hexColorFloat:@"#ffd323"];
    _progressView.trackTintColor = [UIColor colorWithRed:1.0 green:231.0/255 blue:134.0/255 alpha:1.0];
    _progressView.progressTintColor = [UIColor colorWithRed:1.0 green:211.0/255 blue:35.0/255 alpha:1.0];
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    [_progressView setProgress:0.0 animated:YES];
    [self addSubview:_progressView];
    
    //下面loading文字
    self.bottomLab = [UILabel new];
    _bottomLab.font = [UIFont systemFontOfSize:15];
    _bottomLab.textColor = [UIColor darkGrayColor];
    _bottomLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_bottomLab];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).with.offset(15);
        make.height.mas_offset(20);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(5);
        make.right.equalTo(self).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(20);
    }];
    
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.progressView.mas_top).with.offset(-5);
        make.right.equalTo(self.progressView.mas_right).with.offset(0);
        make.height.mas_offset(15);
        make.width.mas_offset(40);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomLab.mas_top).with.offset(-10);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.height.mas_offset(0);
    }];
    
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(20);
    }];
}
- (void)setDownloadDic:(NSDictionary *)downloadDic {
    self.titleLab.text            = downloadDic[@"title"];
    self.messageLab.text = downloadDic[@"message"];
    self.bottomLab.text    = downloadDic[@"loading"];
}

- (void)passProgressValue:(NSHttpClient *)httplient {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = httplient.progress;
        self.numberLab.text = [NSString stringWithFormat:@"%.f%%" , httplient.progress * 100];
    });
    
    CHLog(@"进度%lf",httplient.progress);
}
@end
