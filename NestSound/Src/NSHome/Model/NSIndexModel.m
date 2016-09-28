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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.titleImageUrl forKey:@"titleImageUrl"];
    [aCoder encodeObject:self.activityURL forKey:@"activityURL"];
    [aCoder encodeInt:self.state forKey:@"state"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.titleImageUrl = [aDecoder decodeObjectForKey:@"titleImageUrl"];
        self.activityURL  = [aDecoder decodeObjectForKey:@"activityURL"];
        self.state   = [aDecoder decodeIntForKey:@"state"];
    }
    return self;
}

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
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.titlePageUrl forKey:@"titlePageUrl"];
    [aCoder encodeObject:self.authorName forKey:@"authorName"];
    [aCoder encodeInt:self.playCount forKey:@"playCount"];
    [aCoder encodeObject:self.workName forKey:@"workName"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.titlePageUrl = [aDecoder decodeObjectForKey:@"titlePageUrl"];
        self.authorName  = [aDecoder decodeObjectForKey:@"authorName"];
        self.playCount   = [aDecoder decodeIntForKey:@"playCount"];
        self.workName    = [aDecoder decodeObjectForKey:@"workName"];
    }
    return self;
}
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
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.titleImageURl forKey:@"titleImageURl"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.titleImageURl = [aDecoder decodeObjectForKey:@"titleImageURl"];
        self.title  = [aDecoder decodeObjectForKey:@"title"];
        self.desc    = [aDecoder decodeObjectForKey:@"desc"];
    }
    return self;
}
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
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.titlePageUrl forKey:@"titlePageUrl"];
    [aCoder encodeObject:self.authorName forKey:@"authorName"];
    [aCoder encodeObject:self.workName forKey:@"workName"];
    [aCoder encodeInt:self.playCount forKey:@"playCount"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.titlePageUrl = [aDecoder decodeObjectForKey:@"titlePageUrl"];
        self.authorName  = [aDecoder decodeObjectForKey:@"authorName"];
        self.workName    = [aDecoder decodeObjectForKey:@"workName"];
        self.playCount  = [aDecoder decodeIntForKey:@"playCount"];
    }
    return self;
}
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
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.titleImageUrl forKey:@"titleImageUrl"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
    [aCoder encodeObject:self.workName forKey:@"workName"];
    [aCoder encodeObject:self.shareUrl forKey:@"shareUrl"];
    [aCoder encodeObject:self.zanNum forKey:@"zanNum"];
    [aCoder encodeObject:self.commentNum forKey:@"commentNum"];
    [aCoder encodeObject:self.shareNum forKey:@"shareNum"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.titleImageUrl = [aDecoder decodeObjectForKey:@"titleImageUrl"];
        self.detail  = [aDecoder decodeObjectForKey:@"detail"];
        self.workName    = [aDecoder decodeObjectForKey:@"workName"];
        self.shareUrl = [aDecoder decodeObjectForKey:@"shareUrl"];
        self.zanNum = [aDecoder decodeObjectForKey:@"zanNum"];
        self.commentNum = [aDecoder decodeObjectForKey:@"commentNum"];
        self.shareNum = [aDecoder decodeObjectForKey:@"shareNum"];
    }
    return self;
}
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"titleImageUrl":@"pic",
             @"itemID":@"itemid",
             @"type":@"type",
             @"playUrl":@"url",
             @"detail":@"detail",
             @"workName":@"name",
             @"shareUrl":@"shareurl",
             @"zanNum":@"zannum",
             @"commentNum":@"commentnum",
             @"shareNum":@"sharenum"};
}

@end