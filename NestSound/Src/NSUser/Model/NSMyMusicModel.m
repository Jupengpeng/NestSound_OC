//
//  NSMyMusicModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMyMusicModel.h"

@implementation NSMyMusicModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"createDate":@"createDate",
             @"fovNum":@"fovnum",
             @"itemId":@"itemid",
             @"lookNum":@"looknum",
             @"upvoteNum":@"zannum",
             @"title":@"name",
             @"titleImageUrl":@"pic"
             };
}
@end