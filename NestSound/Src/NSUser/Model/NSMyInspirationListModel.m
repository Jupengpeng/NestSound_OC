//
//  NSMyInspirationListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMyInspirationListModel.h"

@implementation NSMyInspirationListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"MyInspirationList":@"data"};
}
@end

@implementation NSMyInspirationList

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"myInspirationList":@"list"};
    
}

@end

@implementation InspirationModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"createDate":@"createdate",
             @"userId":@"uid",
             @"itemId":@"id",
             @"title":@"title",
             @"audioUrl":@"audio",
             @"titleImageUrl":@"pics"};
    
}
@end