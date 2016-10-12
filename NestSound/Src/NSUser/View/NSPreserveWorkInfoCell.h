//
//  NSPreserveWorkInfoCell.h
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSPreserveProductInfoModel;

@interface NSPreserveWorkInfoCell : UITableViewCell
@property (nonatomic,strong) UILabel *preserveDate;
@property (nonatomic,strong) UILabel *preserveCode;
- (void)setupDataWithSortId:(NSString *)sortId;
//保全申请 作品信息
@property (nonatomic,strong) NSPreserveProductInfoModel *productInfoModel;
@end
