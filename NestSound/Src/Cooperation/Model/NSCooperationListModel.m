//
//  NSCooperationListModel.m
//  NestSound
//
//  Created by yinchao on 2016/10/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationListModel.h"

@implementation CooperationModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperationId":@"id",
             @"cooperationTitle":@"title",
             @"cooperationLyric":@"lyrics",
             @"requiement":@"requirement",
             @"commentNum":@"commentnum",
             @"createTime":@"createtime"};
}

@end

@implementation CooperationListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperation":@"demandInfo"};
}

@end

@implementation NSCooperationListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperationList":@"data"};
}

@end