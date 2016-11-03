//
//  NSCooperationLyricListModel.m
//  NestSound
//
//  Created by yinchao on 2016/11/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationLyricListModel.h"

@implementation CooperationLyricModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"lyricId":@"itemid",
             @"createTime":@"createtime",
             @"isOpened":@"status",
             @"title":@"title",
             @"lyric":@"lyrics",
             @"author":@"author"};
}

@end

@implementation NSCooperationLyricListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"cooperationLyricList":@"data"};
}
@end
