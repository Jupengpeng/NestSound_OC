//
//  NSFanscell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSFansModel;

@interface NSFanscell : UITableViewCell
@property (nonatomic,assign) BOOL isFans;
@property (nonatomic,strong) NSFansModel * fansModel;
@property (nonatomic,strong) UIButton * focusBtn;
@end
