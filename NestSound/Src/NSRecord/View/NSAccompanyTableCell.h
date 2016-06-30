//
//  NSAccompanyTableCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSAccommpanyModel;

@interface NSAccompanyTableCell : UITableViewCell

@property (nonatomic,strong) NSAccommpanyModel * accompanyModel;

@property (nonatomic, weak) UIButton *btn;

@end
