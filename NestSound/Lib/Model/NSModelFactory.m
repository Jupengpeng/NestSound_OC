//
//  MCModelFactory.m
//  MissCandy
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "NSModelFactory.h"

@implementation NSModelFactory
+ (NSBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict {
    
    return [[NSBaseModel alloc] initWithJSONDict:jsonDict];
}
@end
