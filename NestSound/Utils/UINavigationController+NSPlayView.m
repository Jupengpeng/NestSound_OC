//
//  UINavigationController+NSPlayView.m
//  NestSound
//
//  Created by 谢豪杰 on 16/7/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "UINavigationController+NSPlayView.h"


@implementation UINavigationController (NSPlayView)

@dynamic  playStatus;
@dynamic  btn;

-(UIBarButtonItem *)loadingViewShow:(BOOL)show
{
    if (!!show) {
        
    }else{
        self.playStatus   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 21)];
        self.playStatus.animationDuration = 0.8;
        self.playStatus.animationImages = @[[UIImage imageNamed:@"2.0_play_status_1"],
                                       [UIImage imageNamed:@"2.0_play_status_2"],
                                       [UIImage imageNamed:@"2.0_play_status_3"],
                                       [UIImage imageNamed:@"2.0_play_status_4"],
                                       [UIImage imageNamed:@"2.0_play_status_5"],
                                       [UIImage imageNamed:@"2.0_play_status_6"],
                                       [UIImage imageNamed:@"2.0_play_status_7"],
                                       [UIImage imageNamed:@"2.0_play_status_8"],
                                       [UIImage imageNamed:@"2.0_play_status_9"],
                                       [UIImage imageNamed:@"2.0_play_status_10"],
                                       [UIImage imageNamed:@"2.0_play_status_11"],
                                       [UIImage imageNamed:@"2.0_play_status_12"],
                                       [UIImage imageNamed:@"2.0_play_status_13"],
                                       [UIImage imageNamed:@"2.0_play_status_14"],
                                       [UIImage imageNamed:@"2.0_play_status_15"],
                                       [UIImage imageNamed:@"2.0_play_status_16"]];
        self.playStatus.userInteractionEnabled = YES;
        
        self.btn = [[UIButton alloc] initWithFrame:self.playStatus.frame];
        [self.playStatus addSubview:self.btn];
        [self.playStatus stopAnimating];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.playStatus];
        return item;
    }
    return nil;
}

#pragma mark -startPlayAnimation
-(void)restarAnimation :(BOOL)animation
{
    if (!!animation) {
        [self.playStatus stopAnimating];
    }else{
        
        [self.playStatus startAnimating];
        
    }
}

-(void)setBtn:(UIButton *)btn
{
    self.btn = btn;
    
}

@end
