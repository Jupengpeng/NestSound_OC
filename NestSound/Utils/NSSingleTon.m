//
//  NSSingleTon.m
//  NestSound
//
//  Created by yinchao on 16/8/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSingleTon.h"

@implementation NSSingleTon

+ (NSSingleTon *)viewFrom {
    
    static NSSingleTon *viewFrom = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        viewFrom = [[NSSingleTon alloc] init];
        
        viewFrom.viewTag = [NSString string];
        
        viewFrom.controllersNum = 0;
        
    });
    return viewFrom;
    
}

@end
