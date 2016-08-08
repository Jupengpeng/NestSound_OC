//
//  NSRegisterView.h
//  NestSound
//
//  Created by 李龙飞 on 16/8/3.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTextField.h"
@interface NSRegisterView : UIView
@property (nonatomic, strong) NSTextField *userNameTF;
@property (nonatomic, strong)NSTextField *phoneTF;
@property (nonatomic, strong)NSTextField *codeTF;
@property (nonatomic, strong)NSTextField *passwordTF;
@property (nonatomic, strong)NSTextField *repasswordTF;
@property (nonatomic, strong) UIButton *codeBtn;
@end
