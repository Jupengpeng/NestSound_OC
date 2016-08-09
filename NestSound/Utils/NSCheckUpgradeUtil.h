//
//  NSCheckUpgradeUtil.h
//  NestSound
//
//  Created by 李龙飞 on 16/8/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCheckUpgradeUtil : NSObject

/**
 检查app更新
 */
+(void)checkUpgrade;

/**
 获取app版本
 */
+(NSString *)getCurrentAppVersion;
@end
