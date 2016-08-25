//
//  NSTemplateListModel.m
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSTemplateListModel.h"

@implementation NSTemplateModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"itemId":@"id",
             @"content":@"content",
             @"title":@"title",
             @"workname":@"workname",
             @"createtime":@"createtime",
             @"playUrl":@"mp3"};
}

@end

@implementation NSTemplateListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"templateList":@"data"};
}

@end
