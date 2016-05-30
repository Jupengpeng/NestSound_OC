//
//  NSMyLricListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMyLricListModel.h"

@implementation NSMyLyricModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    
    return @{@"author":@"author",
             @"itemId":@"itemid",
             @"lookNum":@"looknum",
             @"lyrics":@"lyrics",
             @"title":@"name",
             @"titleImageUrl":@"pic"
             };
    
}
@end


@implementation NSMyLricListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"NSMyLyricModel":@"data"};
}
@end
