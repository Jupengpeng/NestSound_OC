//
//  NSPreserveWorkInfoCell.h
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSPreserveWorkInfoCell : UITableViewCell
@property (nonatomic,strong) UILabel *preserveDate;
@property (nonatomic,strong) UILabel *preserveCode;
- (void)setupData;


@end
