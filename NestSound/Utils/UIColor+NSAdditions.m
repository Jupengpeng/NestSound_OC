//
//  UIColor+ILAdditions.m
//  iLight
//
//  Created by chang qin on 15/9/7.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "UIColor+NSAdditions.h"

@implementation UIColor (NSAdditions)
+ (UIColor *)hexColorFloat:(NSString *)floatColorString {
    if (floatColorString.length < 6) {
        return nil;
    }
    
    NSRange scanRange;
    scanRange.length = 2;
    unsigned int _red,_green,_blue;
    
    // red
    scanRange.location = 0;
    [[NSScanner scannerWithString:[floatColorString substringWithRange:scanRange]] scanHexInt:&_red];
    
    // green
    scanRange.location = 2;
    [[NSScanner scannerWithString:[floatColorString substringWithRange:scanRange]] scanHexInt:&_green];
    
    // blue
    scanRange.location = 4;
    [[NSScanner scannerWithString:[floatColorString substringWithRange:scanRange]] scanHexInt:&_blue];
    
    return [UIColor colorWithRed:_red/255. green:_green/255. blue:_blue/255. alpha:1.];
}
@end
