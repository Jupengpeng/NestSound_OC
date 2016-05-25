//
//  NSMusicModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicModel.h"

@implementation NSMusicModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"titlePageUrl":@"pic",
             @"authorName":@"author",
             @"itemId":@"itemid",
             @"playCount":@"looknum",
             @"workName":@"name",
             @"type":@"status"
             };
    
}

@end
