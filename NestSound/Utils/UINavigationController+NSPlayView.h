//
//  UINavigationController+NSPlayView.h
//  NestSound
//
//  Created by 谢豪杰 on 16/7/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (NSPlayView)
@property (nonatomic,strong) UIImageView * playStatus;
@property (nonatomic,strong) UIButton * btn;
-(UIBarButtonItem *)loadingViewShow:(BOOL)show;

@end
