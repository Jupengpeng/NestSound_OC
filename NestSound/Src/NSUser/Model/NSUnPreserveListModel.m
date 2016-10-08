//
//  NSUnPreserveListModel.m
//  NestSound
//
//  Created by yinchao on 16/10/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUnPreserveListModel.h"

@implementation NSUnPreserveModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"title":@"title",
             @"time":@"updatetime",
             @"productId":@"id"};
}

@end

@implementation NSUnPreserveListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"unPreserveList":@"data"};
}
@end
