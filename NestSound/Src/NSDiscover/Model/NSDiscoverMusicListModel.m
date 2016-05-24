//
//  NSDiscoverMusicListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDiscoverMusicListModel.h"



@implementation NSDiscoverNewList
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"songList":@"newList"};
}

@end

@implementation NSDiscoverHotList

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"hotList":@"redList"};
}
@end

@implementation NSDiscoverMusicListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"HotList":@"data",
             @"SongList":@"data"
             };
}
@end
