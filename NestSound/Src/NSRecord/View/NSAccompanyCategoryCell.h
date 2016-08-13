//
//  NSAccompanyCategoryCell.h
//  NestSound
//
//  Created by yinchao on 16/8/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSSimpleCategoryModel;
@class NSSimpleSingModel;
@interface NSAccompanyCategoryCell : UICollectionViewCell
@property (nonatomic, strong) NSSimpleCategoryModel *accompanyCategory;
@property (nonatomic, strong) NSSimpleSingModel *simpleSing;
@end
