//
//  UIImage+NSAdditions.h
//  TestApp
//
//  Created by NOVA8OSSA on 15/7/1.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DDAdditions)

+ (UIImage *)screenShoot:(UIView *)view;

- (UIImage *)scaleFitToSize:(CGSize)size;

- (UIImage *)scaleFillToSize:(CGSize)size;

+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size;
/**
 *  rgb 值创建图片
 */
+ (UIImage*) createImageWithColor: (UIColor*) color;
/**
改变图片size
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize;

+ (UIImage *)opaqueImageWithRenderColor:(UIColor *)color renderSize:(CGSize)size;

+ (UIImage *)imageWithCornerRadius:(float)radius fillColor:(UIColor *)fillColor StrokeColor:(UIColor *)strokeColor;

+ (UIImage *)imageWithSize:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;

@end
