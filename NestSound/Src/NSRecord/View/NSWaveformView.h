//
//  NSWaveformView.h
//  NestSound
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSWaveformView : UIView

@property (nonatomic, assign) CGFloat num;

- (void)drawLine;

- (void)playerAllPath;

- (void)removeAllPath;

@end
