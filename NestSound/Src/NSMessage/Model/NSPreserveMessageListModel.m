//
//  NSPreserveMessageListModel.m
//  NestSound
//
//  Created by yinchao on 16/10/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveMessageListModel.h"

@implementation NSPreserveMessage

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"time":@"createtime",
             @"title":@"title",
             @"pushtype":@"pushtype",
             @"content":@"content"};
}

@end


@implementation NSPreserveMessageListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"preserveMessageList":@"data"};
}
@end
