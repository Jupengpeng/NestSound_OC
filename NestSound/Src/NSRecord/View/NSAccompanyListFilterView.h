//
//  NSAccompanyListFilterView.h
//  NestSound
//
//  Created by yintao on 16/9/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

@class NSSimpleCategoryModel;
@class NSSimpleSingModel;
@class NSAccommpanyListModel;

typedef void(^NSAccompanyListFilterViewCategoryBlock)(NSInteger cateIndex,NSSimpleCategoryModel *categoryModel);
typedef void(^NSAccompanyListFilterViewSortBlock)(NSInteger sortIndex);
typedef void(^NSAccompanyListFilterViewConfirmBlock)(NSInteger sortIndex,NSInteger cateIndex,NSSimpleCategoryModel *categoryModel);
#import <UIKit/UIKit.h>

@interface NSAccompanyListFilterView : UIView

@property (nonatomic,copy) NSAccompanyListFilterViewCategoryBlock categoryBlock;
@property (nonatomic,copy) NSAccompanyListFilterViewSortBlock sortBlock;
@property (nonatomic,copy) NSAccompanyListFilterViewConfirmBlock confirmBlock;

- (void)showWithCompletion:(void (^)(BOOL finished))completion;
- (void)dismiss;

- (void)setOriginalStateWithIndex:(NSInteger)index;

- (instancetype)initWithFrame:(CGRect)frame listModel:(NSAccommpanyListModel *)listModel;

@end
