//
//  NSDrawGrayLine.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDrawGrayLine.h"

@implementation NSDrawGrayLine

-(void)drawRect:(CGRect)rect
{
    CGContextRef  ref = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [path setLineWidth:rect.size.width];
    [[UIColor hexColorFloat:@"666666"] setStroke];
    
    CGContextAddPath(ref, path.CGPath);
    CGContextStrokePath(ref);
}

@end
