//
//  NSIndexCollectionReusableView.h
//  NestSound
//
//  Created by Apple on 16/5/2.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSIndexCollectionReusableView;

@protocol NSIndexCollectionReusableViewDelegate <NSObject>

- (void)indexCollectionReusableView:(NSIndexCollectionReusableView *)reusableView withImageBtn:(UIButton *)imageBtn;

@end

@interface NSIndexCollectionReusableView : UICollectionReusableView 

@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) NSMutableArray * bannerAry;
- (void)addHeaderViewWithImageArray:(NSArray *)imageArray;



- (UIButton *)loadMore;

@property (nonatomic, weak) id<NSIndexCollectionReusableViewDelegate> delegate;

@end
