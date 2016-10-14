//
//  NSPreserveUserCell.h
//  NestSound
//
//  Created by yintao on 16/9/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSPreservePersonInfoModel;
@interface NSPreserveUserCell : UITableViewCell


@property (nonatomic,strong) NSPreservePersonInfoModel *personModel;
- (void)setupData;

@end
