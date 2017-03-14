//
//  NSDownView.h
//  NestSound
//
//  Created by 鞠鹏 on 2017/2/10.
//  Copyright © 2017年 yinchao. All rights reserved.
//



typedef void(^NSDownViewVolumeBlock)(CGFloat volume);

#import <UIKit/UIKit.h>


@interface NSDownView : UIView


- (instancetype)initWithFrame:(CGRect)frame accompanyBlock:(NSDownViewVolumeBlock)accompanyBlock recordBlock:(NSDownViewVolumeBlock)recordBlock ;

- (void)setBothVolume:(CGFloat)volume;

@end
