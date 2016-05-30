//
//  NSSingListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSingListModel.h"


@implementation singListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"detail":@"detail",
             @"title":@"name",
             @"titleImageUrl":@"pic",
             @"itemId":@"id"
             };
}
@end

@implementation NSSingListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"singList":@"data"};
}
@end
