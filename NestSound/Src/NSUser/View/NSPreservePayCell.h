//
//  NSPreservePayCell.h
//  NestSound
//
//  Created by yintao on 16/9/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//


typedef void(^NSPreservePayCellChooseBlock)(UIButton *chooseButton);

#import <UIKit/UIKit.h>

@interface NSPreservePayCell : UITableViewCell

@property (nonatomic,copy) NSPreservePayCellChooseBlock chooseBlock;

@end
