//
//  NSCacheManager.h
//  NestSound
//
//  Created by yintao on 2016/11/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <YYCache/YYCache.h>

@interface NSCacheManager : YYCache

+ (instancetype)cacheWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;

- (id<NSCoding>)objectForKey:(NSString *)key ;

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void (^)(void))block;

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

- (void)removeAllObjects;

@end
