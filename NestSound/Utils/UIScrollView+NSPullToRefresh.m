//
//  UIScrollView+IMPullToRefresh.m
//  iMei
//
//  Created by yandi on 15/4/7.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "UIView+NSAdditions.h"
#import "UIScrollView+NSPullToRefresh.h"

NSString *const ShouldRestartAnimationNotification = @"shouldRestartAnimationNotification";

@interface YDAnimatingView : UIImageView

@end

@implementation YDAnimatingView

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self configureAnimatingSettings];
    
        [NOTICENTER addObserver:self selector:@selector(restartAnimation) name:ShouldRestartAnimationNotification object:nil];
    }
    return self;
}

#pragma mark - configureAnimatingSettings
- (void)configureAnimatingSettings {
    
    self.animationDuration = 0.8;
    self.animationRepeatCount = MAXFLOAT;
#warning animationImages
    self.animationImages = @[[UIImage imageNamed:@"2.0_loading_1"],
                             [UIImage imageNamed:@"2.0_loading_2"],
                             [UIImage imageNamed:@"2.0_loading_3"],
                             [UIImage imageNamed:@"2.0_loading_4"],
                             [UIImage imageNamed:@"2.0_loading_5"],
                             [UIImage imageNamed:@"2.0_loading_6"],
                             [UIImage imageNamed:@"2.0_loading_7"],
                             [UIImage imageNamed:@"2.0_loading_8"],
                             [UIImage imageNamed:@"2.0_loading_9"],
                             [UIImage imageNamed:@"2.0_loading_10"],
                             [UIImage imageNamed:@"2.0_loading_11"],
                             [UIImage imageNamed:@"2.0_loading_12"],
                             [UIImage imageNamed:@"2.0_loading_13"],
                             [UIImage imageNamed:@"2.0_loading_14"],
                             [UIImage imageNamed:@"2.0_loading_15"],
                             [UIImage imageNamed:@"2.0_loading_16"]];
}

#pragma mark - restartAnimation
- (void)restartAnimation {
 
    [self startAnimating];
}
@end

@implementation UIScrollView (DDPullToRefresh)

- (void)addDDPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    
    [self addPullToRefreshWithActionHandler:actionHandler];
    
    SVPullToRefreshView *refreshView = self.pullToRefreshView;
    refreshView.arrowColor = [UIColor clearColor];
    
    
    UIView *baseView = (UIView *)[refreshView viewWithStringTag:@"headerBaseView"];
    if (!baseView) {
        
        baseView = [[UIView alloc] init];
        baseView.stringTag = @"headerBaseView";
        baseView.backgroundColor = refreshView.superview.backgroundColor;
        baseView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 60);
        [refreshView addSubview:baseView];
    }
    YDAnimatingView *loadingImageView = (YDAnimatingView *)[baseView viewWithStringTag:@"loadingImageView"];
    if (!loadingImageView) {
        
        loadingImageView = [[YDAnimatingView alloc] init];
        loadingImageView.stringTag = @"loadingImageView";
        loadingImageView.frame = CGRectMake(ScreenWidth/2-15, 20, 30, 30);
        [baseView addSubview:loadingImageView];
    }
    [loadingImageView startAnimating];
    
    [refreshView setTitle:@"" forState:SVPullToRefreshStateStopped];
    [refreshView setTitle:@"shuaxin" forState:SVPullToRefreshStateTriggered];
    [refreshView setTitle:@"shuaxin" forState:SVPullToRefreshStateLoading];
}

- (void)addDDInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    [self addInfiniteScrollingWithActionHandler:actionHandler];
    
    SVInfiniteScrollingView *infiniteView = self.infiniteScrollingView;
    
    UIView *baseView = [infiniteView viewWithStringTag:@"footerBaseView"];
    if (!baseView) {
        
        baseView = [[UIView alloc] init];
        baseView.stringTag = @"footerBaseView";
        baseView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 60);
        [infiniteView addSubview:baseView];
    }
    
    YDAnimatingView *infiniteImageView = (YDAnimatingView *)[baseView viewWithStringTag:@"infiniteImageView"];
    if (!infiniteImageView) {
        infiniteImageView = [[YDAnimatingView alloc] init];
        infiniteImageView.stringTag = @"infiniteImageView";
        [baseView addSubview:infiniteImageView];
        
        // constrains
        [infiniteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(baseView);
        }];
    }
    [infiniteImageView startAnimating];
}
@end
