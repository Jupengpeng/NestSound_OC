//
//  NSPreserveWorkInfoCell.h
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSPreserveProductInfoModel;
@class NSProductModel;

@interface NSPreserveWorkInfoCell : UITableViewCell
@property (nonatomic,strong) UILabel *preserveDate;
@property (nonatomic,strong) UILabel *preserveCode;
- (void)setupDataWithProductModel:(NSProductModel *)productModel;
//保全申请 作品信息
@property (nonatomic,strong) NSPreserveProductInfoModel *productInfoModel;
@end
