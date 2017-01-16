//
//  YCPlayPCMCallback.h
//  SoundEffectLibDemo
//
//  Created by 鞠鹏 on 2017/1/15.
//  Copyright © 2017年 JuPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YCPlayerPCMPlayBlock)(NSString *playStr);

@interface YCPlayPCMCallback : NSObject

@property (nonatomic,copy) YCPlayerPCMPlayBlock PCMPlayerBlock;

+ (instancetype)sharedPlayMusic ;


@end
