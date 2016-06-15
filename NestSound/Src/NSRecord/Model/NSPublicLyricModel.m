//
//  NSPublicLyricModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPublicLyricModel.h"



@implementation NSPublicLyricModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"publicLyricModel":@"data"};
}
@end

@implementation publicLyricModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"itemID":@"itemid",
             @"shareURL":@"shareurl"};
}

@end