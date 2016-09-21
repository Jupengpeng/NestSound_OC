//
//  NSUserProfileCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@interface NSUserProfileCell : UITableViewCell

@property (nonatomic,copy) NSString * iconURL;

@property (nonatomic,copy) NSString * nickName;

@property (nonatomic,copy) NSString * number;
@property (nonatomic,strong) UIImageView * userIcon;
@property (nonatomic,strong) UserModel *userModel;
@end
