//
//  AppDelegate+ILAdditions.m
//  iLight
//
//  Created by yandi on 15/10/4.
//  Copyright © 2015年 xiaokakeji. All rights reserved.
//

#import "AppDelegate+NSAdditions.h"

@implementation AppDelegate (DDAdditions)

+ (float)systemVer {
    return [UIDevice currentDevice].systemVersion.floatValue;
}

+ (NSString *)appName {
    NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
    return [infoDictionary objectForKey:@"CFBundleName"];
}
@end
