//
//  NSCooperationListTableViewCell.h
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CooperationModel;
@interface NSCooperationListTableViewCell : UITableViewCell
@property (nonatomic,strong) CooperationModel *cooperationModel;
@property (nonatomic, assign) CGFloat lyricLabelMaxY;
@end
