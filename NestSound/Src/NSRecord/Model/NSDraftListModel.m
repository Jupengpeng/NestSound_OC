//
//  NSDraftListModel.m
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDraftListModel.h"


@implementation NSDraftModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"itemId":@"id",
             @"uid":@"uid",
             @"content":@"content",
             @"title":@"title",
             @"draftdesc":@"draftdesc",
             @"createTime":@"createtime"};
}

@end


@implementation NSDraftListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"draftList":@"data"};
}
@end
