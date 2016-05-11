//
//  UIScrollView+IMPullToRefresh.h
//  iMei
//
//  Created by yandi on 15/4/7.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "SVPullToRefresh.h"

extern NSString *const ShouldRestartAnimationNotification;

@interface UIScrollView (DDPullToRefresh)
- (void)addDDPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addDDInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
@end
