//
//  NSDrawLineView.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDrawLineView.h"

@implementation NSDrawLineView


#pragma mark -overrider drawRect
-(void)drawRect:(CGRect)rect
{
    CGContextRef  ref = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    for (int i =0; i<self.bounds.size.width/4; i++) {
        [path moveToPoint:CGPointMake(4*i, 0)];
        [path addLineToPoint:CGPointMake(2+4*i, 0)];
        
    }

    [[UIColor hexColorFloat:@"eeeeee"] setStroke];
    
    CGContextAddPath(ref, path.CGPath);
    CGContextStrokePath(ref);
    
}

@end
