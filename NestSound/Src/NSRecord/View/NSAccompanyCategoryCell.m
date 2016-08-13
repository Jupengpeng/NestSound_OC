//
//  NSAccompanyCategoryCell.m
//  NestSound
//
//  Created by yinchao on 16/8/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccompanyCategoryCell.h"
#import "NSAccommpanyListModel.h"

@interface NSAccompanyCategoryCell ()
{
    UIImageView *backImgView;
}
@end

@implementation NSAccompanyCategoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupAccompanyCategoryUI];
    }
    return self;
}
- (void)setupAccompanyCategoryUI {
    
    backImgView = [UIImageView new];
    
    [backImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    backImgView.contentMode =  UIViewContentModeScaleAspectFill;
    
    backImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    backImgView.clipsToBounds  = YES;
    
    [self.contentView addSubview:backImgView];
    
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(self.contentView);
        
    }];
    
}


- (void)setAccompanyCategory:(NSSimpleCategoryModel *)accompanyCategory {
    
    _accompanyCategory = accompanyCategory;
    
    [backImgView setDDImageWithURLString:accompanyCategory.categoryPic placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
}
- (void)setSimpleSing:(NSSimpleSingModel *)simpleSing {
    _simpleSing = simpleSing;
    [backImgView setDDImageWithURLString:simpleSing.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
}
@end
