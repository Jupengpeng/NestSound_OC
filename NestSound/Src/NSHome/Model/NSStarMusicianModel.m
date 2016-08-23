//
//  NSNSStarMusicianModel.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSStarMusicianModel.h"





/**
 *  音乐人详情
 */
@implementation NSStarMusicianModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"musicianData":@"data",
             @"worklistData":@"data"
             };
}

@end



@implementation NSMusicianDataModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"musicianModel":@"musician",
             };
}


@end

@implementation NSWorklistDataModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"workList":@"worklist",
             };
}


@end


@implementation NSMusicianModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"musicianId":@"id",
             @"introduction":@"introduction",
             @"ability":@"ability",
             @"pic":@"pic",
             @"musicianDescription":@"description",
             @"name":@"name"
             };
}




@end


@implementation NSWorklistModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"sort":@"sort",
             @"workId":@"id",
             @"pic":@"pic",
             @"title":@"title",
             @"mp3time":@"mp3time",
             @"name":@"name",
             @"mp3":@"mp3"
             
             };
}



@end