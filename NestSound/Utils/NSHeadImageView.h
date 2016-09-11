//
//  NSHeadImageView.h
//  NestSound
//
//  Created by yintao on 16/9/10.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSHeadImageView : UIImageView

@property (nonatomic,assign) CGFloat blurAlpha;

- (UIImage *)setupBlurImageWithBlurRadius:(CGFloat)blurRadius image:(UIImage *)image;


@end
