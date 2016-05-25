//
//  NSActivityListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSActivityListModel.h"

@implementation NSActivityListModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"ActivityList":@"data"};
}

@end


@implementation NSActivity

-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"beginDate":@"begindate",
             @"detail":@"detail",
             @"endDate":@"enddate",
             @"name":@"name",
             @"titleImageUrl":@"pic",
             @"status":@"status",
             @"activityUrl":@"url"
             };
}

@end
