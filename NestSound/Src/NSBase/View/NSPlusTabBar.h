//
//  NSPlusTabBar.h
//  NestSound
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSPlusTabBar;

@protocol NSPlusTabBarDelegate <NSObject, UITabBarDelegate>

- (void)plusTabBar:(NSPlusTabBar *)tabBar didSelectedPlusBtn:(UIButton *)plusBtn;

@end

@interface NSPlusTabBar : UITabBar

@property (nonatomic, weak) id<NSPlusTabBarDelegate> delegate;

@end
