//
//  NSPreserveListModel.m
//  NestSound
//
//  Created by yinchao on 16/9/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveListModel.h"

@implementation NSPreserveListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"preserveList":@"data"};
}
@end

@implementation NSPreserveModel

- (NSDictionary *)modelKeyJSONKeyMapper {

    return @{@"preserveName":@"worksname",
             @"createTime":@"createtime",
             @"status":@"statue",
             @"preserveId":@"id",
             @"sortId":@"sort_id"
             };
}

@end