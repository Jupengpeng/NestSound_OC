//
//  NSLoginView.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/3.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLoginView.h"
#import "NSTextField.h"
@implementation NSLoginView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureApperence];
    }
    return self;
}
- (void)configureApperence {
    // 手机号
    UIImage *phoneImg = [UIImage imageNamed:@"2.0_phonenumber_icon"];
    UIImageView *phoneImgView = [[UIImageView alloc] initWithImage:phoneImg];
    phoneImgView.frame = CGRectMake(0, 0, 12, 15);
    NSTextField *phoneTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth -20, 30) drawingLeft:phoneImgView];
    phoneTF.secureTextEntry = YES;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.layer.borderColor = [[UIColor clearColor] CGColor];
    phoneTF.font = [UIFont systemFontOfSize:15];
    phoneTF.placeholder = @" 输入手机号码";
//    [oldPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:phoneTF];
    
    //新密码
    UIImage *PwdImg = [UIImage imageNamed:@"2.0_password_gray"];
    UIImageView *PwdImgView = [[UIImageView alloc] initWithImage:PwdImg];
    PwdImgView.frame = CGRectMake(0, 0, 12, 15);
    NSTextField *PwdTF = [[NSTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(phoneTF.frame) + 10, ScreenWidth - 20, 30) drawingLeft:PwdImgView];
    PwdTF.secureTextEntry = YES;
    PwdTF.layer.borderColor = [[UIColor clearColor] CGColor];
    PwdTF.font = [UIFont systemFontOfSize:15];
    PwdTF.placeholder = @" 输入密码";
//    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:PwdTF];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    forgetBtn.frame = CGRectMake(ScreenWidth - 100 , CGRectGetMaxY(phoneTF.frame) + 10, 80, 30);
    forgetBtn.layer.cornerRadius = 20;
    forgetBtn.userInteractionEnabled = NO;
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetThePassword) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetBtn];
}
@end
