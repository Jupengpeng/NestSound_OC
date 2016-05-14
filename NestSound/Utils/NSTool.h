//
//  NSTool.h
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>

@interface NSTool : NSObject

extern void swizzled_Method(Class class,SEL originalSelector,SEL swizzledSelector);

+ (NSString *)obtainHostURL;
+ (AppDelegate *)appDelegate;
+ (BOOL)isStringEmpty:(NSString *)targetString;
@end
