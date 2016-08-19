//
//  NSActivityDetailModel.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSActivityDetailModel.h"



@implementation ActivityDetailModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"activityId":@"id",
             @"actDesc":@"description",
             @"joinnum":@"joinnum",
             @"begindate":@"begindate",
             @"enddate":@"enddate",
             @"url":@"url",
             @"pic":@"pic",
             @"title":@"title",
             @"type":@"type",
             @"looknum":@"looknum",
             @"worknum":@"worknum",
             @"sort":@"sort"
             };
}


@end

@implementation NSActivityDataModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"activityDetailModel":@"activityDetail",
             @"isJoin":@"isJoin"};
}


@end


@implementation NSActivityDetailModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"activityDataModel":@"data"
             };
}


@end
