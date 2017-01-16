//
//  YCPlayPCMCallback.m
//  SoundEffectLibDemo
//
//  Created by 鞠鹏 on 2017/1/15.
//  Copyright © 2017年 JuPeng. All rights reserved.
//

#import "YCPlayPCMCallback.h"


@interface YCPlayPCMCallback ()

@end

static id _instance;


@implementation YCPlayPCMCallback

+ (instancetype)sharedPlayMusic {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}




@end
