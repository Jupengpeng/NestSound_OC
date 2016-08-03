//
//  NSRegisterView.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/3.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRegisterView.h"
#import "NSTextField.h"
@implementation NSRegisterView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureApperence];
    }
    return self;
}
- (void)configureApperence {
    // 用户名
    UIImage *userNameImg = [UIImage imageNamed:@"2.0_phonenumber_icon"];
    UIImageView *userNameImgView = [[UIImageView alloc] initWithImage:userNameImg];
    userNameImgView.frame = CGRectMake(0, 0, 12, 15);
    NSTextField *userNameTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, 17, ScreenWidth -20, 30) drawingLeft:userNameImgView];
    userNameTF.secureTextEntry = YES;
    userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    userNameTF.layer.borderColor = [[UIColor clearColor] CGColor];
    userNameTF.font = [UIFont systemFontOfSize:15];
    userNameTF.placeholder = @" 用户名";
    //    [oldPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:userNameTF];
    
    //输入手机号
    UIImage *phoneImg = [UIImage imageNamed:@"2.0_password_gray"];
    UIImageView *phoneImgView = [[UIImageView alloc] initWithImage:phoneImg];
    phoneImgView.frame = CGRectMake(0, 0, 12, 15);
    NSTextField *phoneTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(userNameTF.frame) + 5, ScreenWidth - 20, 30) drawingLeft:phoneImgView];
    phoneTF.secureTextEntry = YES;
    phoneTF.layer.borderColor = [[UIColor clearColor] CGColor];
    phoneTF.font = [UIFont systemFontOfSize:15];
    phoneTF.placeholder = @" 输入手机号码";
    //    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:phoneTF];
    
    //验证码
    UIImage *codeImg = [UIImage imageNamed:@"2.0_password_gray"];
    UIImageView *codeImgView = [[UIImageView alloc] initWithImage:codeImg];
    codeImgView.frame = CGRectMake(0, 0, 12, 15);
    NSTextField *codeTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(phoneTF.frame) + 5, ScreenWidth - 20, 30) drawingLeft:codeImgView];
    codeTF.secureTextEntry = YES;
    codeTF.layer.borderColor = [[UIColor clearColor] CGColor];
    codeTF.font = [UIFont systemFontOfSize:15];
    codeTF.placeholder = @" 验证码";
    //    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:codeTF];
    
    //获取验证码
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    codeBtn.frame = CGRectMake(ScreenWidth - 100 , 0, 80, 40);
    codeBtn.layer.cornerRadius = 20;
    codeBtn.userInteractionEnabled = NO;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(forgetThePassword) forControlEvents:UIControlEventTouchUpInside];
    [codeTF addSubview:codeBtn];
    
    //输入密码
    UIImage *passwordImg = [UIImage imageNamed:@"2.0_password_gray"];
    UIImageView *passwordImgView = [[UIImageView alloc] initWithImage:passwordImg];
    passwordImgView.frame = CGRectMake(0, 0, 12, 15);
    NSTextField *passwordTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(codeTF.frame) + 5, ScreenWidth - 20, 30) drawingLeft:passwordImgView];
    passwordTF.secureTextEntry = YES;
    passwordTF.layer.borderColor = [[UIColor clearColor] CGColor];
    passwordTF.font = [UIFont systemFontOfSize:15];
    passwordTF.placeholder = @"  输入密码";
    //    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:passwordTF];
    
    //再次输入密码
    UIImage *repasswordImg = [UIImage imageNamed:@"2.0_password_gray"];
    UIImageView *repasswordImgView = [[UIImageView alloc] initWithImage:repasswordImg];
    repasswordImgView.frame = CGRectMake(0, 0, 12, 15);
    NSTextField *repasswordTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(passwordTF.frame), ScreenWidth - 20, 30) drawingLeft:repasswordImgView];
    repasswordTF.secureTextEntry = YES;
    repasswordTF.layer.borderColor = [[UIColor clearColor] CGColor];
    repasswordTF.font = [UIFont systemFontOfSize:15];
    repasswordTF.placeholder = @"  再次输入密码";
    //    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:repasswordTF];
}
@end
