//
//  NSNewMusicTableViewCell.h
//  NestSound
//
//  Created by Apple on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSNewMusicTableViewCell : UITableViewCell

//排行数字
@property (nonatomic, strong) UILabel *numLabel;

//日期
- (void)addDateLabel;

@end
