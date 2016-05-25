//
//  NSSystemMessageListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSystemMessageListModel.h"

@implementation SystemMessageModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"createDate":@"createdate",
             @"messageId":@"id",
             @"status":@"status",
             @"title":@"title",
             @"content":@"context",
             @"detailUrl":@"url",
             @"type":@"type",
             @"titleImageUrl":@"pic"
             };

}
@end


@implementation NSSystemMessageListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"systemMessageList":@"data"};
}
@end
