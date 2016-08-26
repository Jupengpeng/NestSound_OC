//
//  NSRegisterView.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/3.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRegisterView.h"

#define KColor_Background [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1]
@implementation NSRegisterView
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
    // 用户名
    UIImage *userNameImg = [UIImage imageNamed:@"2.0_user_icon"];
    
    UIImageView *userNameImgView = [[UIImageView alloc] initWithImage:userNameImg];
    
    userNameImgView.frame = CGRectMake(0, 0, 12, 14);
    
    self.userNameTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth -20, 30) drawingLeft:userNameImgView];
    
    _userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _userNameTF.layer.borderColor = [[UIColor clearColor] CGColor];
    
    _userNameTF.font = [UIFont systemFontOfSize:15];
    
    _userNameTF.placeholder = @"用户名";
    //    [oldPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_userNameTF];
    
    //输入手机号
    UIImage *phoneImg = [UIImage imageNamed:@"2.0_phonenumber_icon"];
    
    UIImageView *phoneImgView = [[UIImageView alloc] initWithImage:phoneImg];
    
    phoneImgView.frame = CGRectMake(0, 0, 12, 18);
    
    self.phoneTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_userNameTF.frame) + 10, ScreenWidth - 20, 30) drawingLeft:phoneImgView];
    
    _phoneTF.layer.borderColor = [[UIColor clearColor] CGColor];
    
    _phoneTF.font = [UIFont systemFontOfSize:15];
    
    _phoneTF.placeholder = @"手机号";
    
    //    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_phoneTF];
    
    
    //验证码
    
    UIImage *codeImg = [UIImage imageNamed:@"2.0_checkCode"];
    
    UIImageView *codeImgView = [[UIImageView alloc] initWithImage:codeImg];
    
    codeImgView.frame = CGRectMake(0, 0, 12, 14);
    
    self.codeTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_phoneTF.frame) + 10, ScreenWidth - 110, 30) drawingLeft:codeImgView];
    
    _codeTF.layer.borderColor = [[UIColor clearColor] CGColor];
    
    _codeTF.font = [UIFont systemFontOfSize:15];
    
    _codeTF.placeholder = @"验证码";
    
    //    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_codeTF];
    
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 95, CGRectGetMaxY(_phoneTF.frame) + 10, 2, 20)];
    
    yellowView.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
    
    [self addSubview:yellowView];
    
    //获取验证码
    self.codeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _codeBtn.frame = CGRectMake(ScreenWidth - 90 , CGRectGetMaxY(_phoneTF.frame), 80, 40);
    
    _codeBtn.layer.cornerRadius = 20;
        
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [_codeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self addSubview:_codeBtn];
    
    //输入密码
    UIImage *passwordImg = [UIImage imageNamed:@"2.0_password_gray"];
    
    UIImageView *passwordImgView = [[UIImageView alloc] initWithImage:passwordImg];
    
    passwordImgView.frame = CGRectMake(0, 0, 12, 14);
    
    self.passwordTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_codeTF.frame) + 10, ScreenWidth - 20, 30) drawingLeft:passwordImgView];
    
    _passwordTF.secureTextEntry = YES;
    
    _passwordTF.layer.borderColor = [[UIColor clearColor] CGColor];
    
    _passwordTF.font = [UIFont systemFontOfSize:15];
    
    _passwordTF.placeholder = @"输入密码";
    
    //    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_passwordTF];
    
    //再次输入密码
    UIImage *repasswordImg = [UIImage imageNamed:@"2.0_repassword_gray"];
    
    UIImageView *repasswordImgView = [[UIImageView alloc] initWithImage:repasswordImg];
    
    repasswordImgView.frame = CGRectMake(0, 0, 12, 14);
    
    self.repasswordTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_passwordTF.frame) + 10, ScreenWidth - 20, 30) drawingLeft:repasswordImgView];
    
    _repasswordTF.secureTextEntry = YES;
    
    _repasswordTF.layer.borderColor = [[UIColor clearColor] CGColor];
    
    _repasswordTF.font = [UIFont systemFontOfSize:15];
    
    _repasswordTF.placeholder = @"再次输入密码";
    
    //    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_repasswordTF];
}
@end
