//
//  NSMyCooperationListModel.m
//  NestSound
//
//  Created by yinchao on 2016/10/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMyCooperationListModel.h"


@implementation myCooperationModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"myCooperationId":@"id",
             @"cooperationTitle":@"title",
             @"workNum":@"worknum",
             @"createTime":@"createtime",
             @"status":@"status"};
}

@end

@implementation NSMyCooperationListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"myCooperationList":@"data"};
}
@end
