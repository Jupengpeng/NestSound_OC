//
//  NSLoginView.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/3.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLoginView.h"

#define KColor_Background [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1]
@implementation NSLoginView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KColor_Background;
        self.userInteractionEnabled = YES;
        [self configureApperence];
    }
    return self;
}
- (void)configureApperence {
    // 手机号
    UIImage *phoneImg = [UIImage imageNamed:@"2.0_phonenumber_icon"];
    
    UIImageView *phoneImgView = [[UIImageView alloc] initWithImage:phoneImg];
    
    phoneImgView.frame = CGRectMake(0, 0, 12, 20);
    
    self.phoneTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth -20, 30) drawingLeft:phoneImgView];
    
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _phoneTF.layer.borderColor = [[UIColor clearColor] CGColor];
    
    _phoneTF.font = [UIFont systemFontOfSize:15];
    
    _phoneTF.placeholder = @" 输入手机号码";
    
//    [oldPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_phoneTF];
    
    //输入密码
    UIImage *PwdImg = [UIImage imageNamed:@"2.0_password_icon"];
    
    UIImageView *PwdImgView = [[UIImageView alloc] initWithImage:PwdImg];
    
    PwdImgView.frame = CGRectMake(0, 0, 12, 14);
    
    self.PwdTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_phoneTF.frame) + 10, ScreenWidth - 110, 30) drawingLeft:PwdImgView];
    
    _PwdTF.secureTextEntry = YES;
    
    _PwdTF.layer.borderColor = [[UIColor clearColor] CGColor];
    
    _PwdTF.font = [UIFont systemFontOfSize:15];
    
    _PwdTF.placeholder = @" 输入密码";
    
//    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_PwdTF];
    
    self.forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _forgetBtn.frame = CGRectMake(ScreenWidth - 95 , CGRectGetMaxY(_phoneTF.frame) + 10, 80, 30);
    
    _forgetBtn.layer.cornerRadius = 20;
    
    [_forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    
    [_forgetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self addSubview:_forgetBtn];
}

@end
