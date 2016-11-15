//
//  NSCacheManager.m
//  NestSound
//
//  Created by yintao on 2016/11/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCacheManager.h"

@implementation NSCacheManager

+ (instancetype)cacheWithName:(NSString *)name{

    NSCacheManager *manager = [[NSCacheManager alloc] initWithName:name];
    return manager;
}

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
    if (self) {
        
    }
    return self;
}


- (id<NSCoding>)objectForKey:(NSString *)key{
    id<NSCoding> object = [self objectForKey:key];
    return object;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void (^)(void))block{
    
    [self setObject:object forKey:key withBlock:block];
    
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key{
    
    [self setObject:object forKey:key];
}

- (void)removeAllObjects{
    
    [self removeAllObjects];
}

@end
