//
//  NSIndexModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSIndexModel.h"

@implementation NSIndexModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"BannerList":@"data",
             @"RecommendList":@"data",
             @"NewList":@"data",
             @"RecommendSongList":@"data",
             @"MusicSayList":@"data",
             @"code":@"code",
             @"message":@"message"
             };
}

@end

@implementation NSBannerList
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"bannerList":@"bannerList"};
    
}
@end

@implementation NSBanner
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"itemID":@"itemid",
             @"titleImageUrl":@"pic",
             @"activityURL":@"playurl",
             @"state":@"type"
             };
}
@end

@implementation NSRecommendList
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"recommendList":@"mTuijianList"};
}

@end

@implementation NSRecommend
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"titlePageUrl":@"pic",
             @"authorName":@"author",
             @"itemId":@"itemid",
             @"playCount":@"looknum",
             @"workName":@"title",
             @"type":@"status"
             };
    
}
@end


@implementation NSRecommendSongLs

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"recommendSongList":@"recommendsonglist" };
}

@end

//@implementation NSRecommendSongList
//-(NSDictionary *)modelKeyJSONKeyMapper
//{
//    return @{@"recommendSongList":@"recommendsonglist"};
//}

//@end

@implementation NSRecommendSong
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"titleImageURl":@"pic",
             @"title":@"name",
             @"itemID":@"id",
             @"desc":@"detail"
             };
}
@end


@implementation NSNewList
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"songList":@"newList"};
}

@end

@implementation NSNew
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

@implementation NSMusicSayList
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"musicSayList":@"yueshuoList"};
}

@end

@implementation NSMusicSay
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"titleImageUrl":@"pic",
             @"itemID":@"itemid",
             @"type":@"type",
             @"playUrl":@"url",
             @"detail":@"detail",
             @"workName":@"name"
             };
}

@end