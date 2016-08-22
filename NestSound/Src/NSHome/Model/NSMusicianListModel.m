//
//  NSMusicianListModel.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/20.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicianListModel.h"

@implementation NSMusicianDetailModel 
-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"musicianId":@"id",
             @"pic":@"pic",
             @"sort":@"sort",
             @"ability":@"ability",
             @"name":@"name",
             };
}
@end

@implementation NSMusicianListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"musicianList":@"data"
             };
}
@end
