//
//  NSTableHeaderView.m
//  NestSound
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSTableHeaderView.h"

@interface NSTableHeaderView () {
    
    UIImageView *_backgroundImage;
    
    UIView *_line1;
    
    UIView *_line2;
    
    UIView *_line3;
    
    UIView *_line4;
}

@end

@implementation NSTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
        
        
    }
    
    return self;
}

- (void)setupUI {
    
    _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_backgroundImage"]];
    
    _backgroundImage.frame = CGRectMake(0, 0, ScreenWidth, self.height * 0.5);
    
    [self addSubview:_backgroundImage];
    
    self.iconView = [[UIImageView alloc] init];
    
    self.iconView.layer.cornerRadius = 50;
    
    self.iconView.clipsToBounds = YES;
    
    [self addSubview:self.iconView];
    
    
    self.userName = [[UILabel alloc] init];
    
    self.userName.textAlignment = NSTextAlignmentCenter;
    
    self.userName.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.userName];
    
    
    self.introduction = [[UILabel alloc] init];
    
    self.introduction.textAlignment = NSTextAlignmentCenter;
    
    self.introduction.font = [UIFont systemFontOfSize:14];
    
    self.introduction.textColor = [UIColor hexColorFloat:@"999999"];
    
    [self addSubview:self.introduction];
    
    
    _line1 = [[UIView alloc] init];
    
    _line1.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_line1];
    
    
    self.followBtn = [[UIButton alloc] init];
    
    [self.followBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.followBtn];
    
    
    _line2 = [[UIView alloc] init];
    
    _line2.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_line2];
    
    
    self.fansBtn = [[UIButton alloc] init];
    
    [self.fansBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.fansBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.fansBtn];
    
    
    _line3 = [[UIView alloc] init];
    
    _line3.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_line3];
    
    
    _line4 = [[UIView alloc] init];
    
    _line4.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self addSubview:_line4];
    
}


-(void)layoutSubviews {
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        
        make.centerY.equalTo(self.mas_centerY).offset(-25);
        
        make.width.height.mas_equalTo(100);
        
    }];
    
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        
        make.top.equalTo(self.iconView.mas_bottom).offset(10);
        
        make.left.equalTo(self.mas_left).offset(20);
        
        make.right.equalTo(self.mas_right).offset(-20);
        
    }];
    
    
    [self.introduction mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        
        make.top.equalTo(self.userName.mas_bottom).offset(10);
        
        make.left.equalTo(self.mas_left).offset(20);
        
        make.right.equalTo(self.mas_right).offset(-20);
        
    }];
    
    
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.introduction.mas_bottom).offset(10);
        
        make.width.equalTo(self.mas_width);
        
        make.height.mas_equalTo(1);
        
    }];
    
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_line1.mas_bottom);
        
        make.left.equalTo(self.mas_left);
        
        make.width.mas_equalTo(self.width * 0.5);
        
        make.height.mas_equalTo(44);
        
    }];
    
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        
        make.centerY.equalTo(self.followBtn.mas_centerY);
        
        make.width.mas_equalTo(1);
        
        make.height.equalTo(self.followBtn.mas_height).multipliedBy(0.8);
        
    }];

    
    [self.fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_line1.mas_bottom);
        
        make.left.equalTo(_line2.mas_right);
        
        make.right.equalTo(self.mas_right);
        
        make.height.mas_equalTo(44);
        
    }];
    
    
    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.followBtn.mas_bottom);
        
        make.left.right.equalTo(self);
        
        make.height.mas_equalTo(1);
        
    }];
    
    
    [_line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_line3.mas_bottom);
        
        make.left.right.bottom.equalTo(self);
        
    }];

    
}

@end









