//
//  UIImage+NSAdditions.m
//  TestApp
//
//  Created by NOVA8OSSA on 15/7/1.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "UIImage+NSAdditions.h"

@implementation UIImage (NSAdditions)

+ (UIImage *)screenShoot:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size{
    
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)opaqueImageWithRenderColor:(UIColor *)color renderSize:(CGSize)size {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)scaleFitToSize:(CGSize)size {
    
    CGFloat scaleRate = MIN(size.width / self.size.width, size.height / self.size.height);
    return [self scaleImageToSize:size rate:scaleRate];
}

- (UIImage *)scaleFillToSize:(CGSize)size {
    
    CGFloat scaleRate = MAX(size.width / self.size.width, size.height / self.size.height);
    return [self scaleImageToSize:size rate:scaleRate];
}

- (UIImage *)scaleImageToSize:(CGSize)size rate:(CGFloat)scaleRate {
    
    UIImage *image = nil;
    CGSize renderSize = CGSizeMake(self.size.width * scaleRate, self.size.height * scaleRate);
    CGFloat startX = size.width * 0.5 - renderSize.width * 0.5;
    CGFloat startY = size.height * 0.5 - renderSize.height * 0.5;
    
    CGImageAlphaInfo info = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque = (info == kCGImageAlphaNone) || (info == kCGImageAlphaNoneSkipFirst) || (info == kCGImageAlphaNoneSkipLast);
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0.);
    UIColor *backgroundColor = opaque ? [UIColor whiteColor] : [UIColor clearColor];
    [backgroundColor setFill];
    UIRectFillUsingBlendMode(CGRectMake(0, 0, size.width, size.height), kCGBlendModeNormal);
    
    [self drawInRect:CGRectMake(startX, startY, renderSize.width, renderSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithCornerRadius:(float)radius fillColor:(UIColor *)fillColor StrokeColor:(UIColor *)strokeColor {
    CGSize renderSize = CGSizeMake(10, 10);
    UIGraphicsBeginImageContextWithOptions(renderSize, NO, 0.);
    CGContextRef drawCtx = UIGraphicsGetCurrentContext();
    CGPathRef borderPath = CGPathCreateWithRoundedRect((CGRect){CGPointZero,renderSize}, radius, radius, NULL);
    CGContextAddPath(drawCtx, borderPath);
    if (strokeColor) {
        [strokeColor setStroke];
        CGContextDrawPath(drawCtx, kCGPathStroke);
    }
    if (fillColor) {
        [fillColor setFill];
        CGContextDrawPath(drawCtx, kCGPathFill);
    }
    UIImage *resImage = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:UIEdgeInsetsMake(radius/2., radius/2., radius/2., radius/2.)];
    UIGraphicsEndImageContext();
    CGPathRelease(borderPath);
    
    return resImage;
}

+ (UIImage *)imageWithSize:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor {
    
    CGRect circleRect = CGRectMake(lineWidth , lineWidth, size.width-lineWidth*2, size.height-lineWidth*2);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.);
    CGContextRef drawCtx = UIGraphicsGetCurrentContext();
    CGPathRef renderPath = CGPathCreateWithRoundedRect(circleRect, radius, radius, NULL);
    CGContextAddPath(drawCtx, renderPath);
    
    if (strokeColor && fillColor) {
        [fillColor setFill];
        [strokeColor setStroke];
        
        CGContextDrawPath(drawCtx, kCGPathFillStroke);
    } else {
        if (fillColor) {
            [fillColor setFill];
            CGContextDrawPath(drawCtx, kCGPathFill);
        } else if (strokeColor) {
            [strokeColor setStroke];
            CGContextDrawPath(drawCtx, kCGPathStroke);
        }
    }
    
    UIImage *resImage = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:UIEdgeInsetsMake(lineWidth+radius, lineWidth+radius, lineWidth+radius, lineWidth+radius)];
    UIGraphicsEndImageContext();
    CGPathRelease(renderPath);
    
    return resImage;
}
@end











