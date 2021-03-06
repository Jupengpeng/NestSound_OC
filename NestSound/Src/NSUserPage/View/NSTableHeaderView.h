//
//  NSTableHeaderView.h
//  NestSound
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@class UserOtherModel;
@interface NSTableHeaderView : UIView

//头像
@property (nonatomic, strong) UIImageView *iconView;

//用户名
@property (nonatomic, strong) UILabel *userName;

//简介
@property (nonatomic, strong) UILabel *introduction;

//关注
@property (nonatomic, strong) UIButton *followBtn;

//粉丝
@property (nonatomic, strong) UIButton *fansBtn;

@property (nonatomic,strong) UserModel * userModel;
@property (nonatomic,strong) UserOtherModel * otherModel;
@end
