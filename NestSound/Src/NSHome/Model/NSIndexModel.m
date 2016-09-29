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
    [aCoder encodeObject:self.shareurl forKey:@"shareurl"];
    [aCoder encodeObject:self.zannum forKey:@"zannum"];
    [aCoder encodeObject:self.commentnum forKey:@"commentnum"];
    [aCoder encodeObject:self.sharenum forKey:@"sharenum"];
    [aCoder encodeBool:self.isZan forKey:@"isZan"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.titleImageUrl = [aDecoder decodeObjectForKey:@"titleImageUrl"];
        self.detail  = [aDecoder decodeObjectForKey:@"detail"];
        self.workName    = [aDecoder decodeObjectForKey:@"workName"];
        self.shareurl = [aDecoder decodeObjectForKey:@"shareurl"];
        self.zannum = [aDecoder decodeObjectForKey:@"zannum"];
        self.commentnum = [aDecoder decodeObjectForKey:@"commentnum"];
        self.sharenum = [aDecoder decodeObjectForKey:@"sharenum"];
        self.isZan =  [aDecoder decodeBoolForKey:@"isZan"];
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
             @"shareurl":@"shareurl",
             @"zannum":@"zannum",
             @"commentnum":@"commentnum",
             @"commentnum":@"sharenum",
             @"isZan":@"isZan"};
}

@end