//
//  NSTool.m
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//

#import "NSTool.h"

void swizzled_Method(Class class,SEL originalSelector,SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzeldMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didSwizzle = class_addMethod(class, originalSelector, method_getImplementation(swizzeldMethod), method_getTypeEncoding(swizzeldMethod));
    
    if (didSwizzle) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzeldMethod);
    }
}

BOOL debugMode = NO;
NSString *host = @"";
NSString *port = @"";

@implementation NSTool
static NSDateFormatter *dateFormatter;

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[self class] configureHostURL];
        
        dateFormatter = [[NSDateFormatter alloc] init];
    });
}

#pragma mark + configureHostURL
+ (void)configureHostURL {
    
    if (debugMode) {
        
        if ([NSTool isStringEmpty:[USERDEFAULT objectForKey:customHostKey]]) {
            
#ifdef DEBUG
            host = debugHost;
            port = debugPort;
            
            [USERDEFAULT setValue:debugHost forKey:customHostKey];
            [USERDEFAULT setValue:debugPort forKey:customPortKey];
            [USERDEFAULT synchronize];
#else
            host = releaseHost;
            port = releasePort;
            
            [USERDEFAULT setValue:releaseHost forKey:customHostKey];
            [USERDEFAULT setValue:releasePort forKey:customPortKey];
            [USERDEFAULT synchronize];
#endif
        } else {
            
            host = [USERDEFAULT objectForKey:customHostKey];
            port = [USERDEFAULT objectForKey:customPortKey];
        }
        return ;
    }
#ifdef DEBUG
    host = debugHost;
    port = debugPort;
#else
    host = releaseHost;
    port = releasePort;
#endif
}

#pragma mark - obtainHostURL
+ (NSString *)obtainHostURL {
    
    NSString *requestURL = [USERDEFAULT objectForKey:customHostKey];
    if (![NSTool isStringEmpty:requestURL]) {
        if (![NSTool isStringEmpty:customPortKey]) {
            requestURL = [requestURL stringByAppendingFormat:@":%@",[USERDEFAULT objectForKey:customPortKey]];
        }
        return requestURL;
    }
    requestURL = host;
    if (![NSTool isStringEmpty:port]) {
        requestURL = [requestURL stringByAppendingFormat:@":%@",port];
    }
    return requestURL;
}

#pragma mark - appDelegate
+ (AppDelegate *)appDelegate {
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - isStringEmpty
+ (BOOL)isStringEmpty:(NSString *)targetString {
    
    if (![targetString isKindOfClass:[NSString class]]) {
        targetString = targetString.description;
    }
    if ([targetString isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([targetString isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([targetString isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([targetString isEqualToString:@"(null)(null)"]) {
        return YES;
    }
    if ([[targetString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}
@end
