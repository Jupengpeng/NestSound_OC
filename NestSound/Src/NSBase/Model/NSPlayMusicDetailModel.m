//
//  NSPlayMusicDetailModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPlayMusicDetailModel.h"

@implementation NSPlayMusicDetailModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"musicdDetail":@"data"};
}

@end

@implementation NSPlayMusicDetail
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"commentNum":@"commentnum",
             @"isShow":@"is_issue",
             @"fovNum":@"fovnum",
             @"hotId":@"hotid",
             @"hotMp3Times":@"hotmp3times",
             @"isZan":@"isZan",
             @"isCollection":@"iscollect",
             @"itemID":@"itemid",
             @"mp3Times":@"mp3times",
             @"nextItemID":@"next",
             @"prevItemID":@"prev",
             @"userID":@"uid",
             @"zanNum":@"zannum",
             @"headURL":@"headurl",
             @"hotTitle":@"hotTitle",
             @"hotMP3":@"hotmp3",
             @"shareURL":@"shareurl",
             @"lyrics":@"lyrics",
             @"titleImageURL":@"pic",
             @"playURL":@"playurl",
             @"title":@"title",
             @"author":@"author",
             @"detaile":@"diyids"};

}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.commentNum forKey:@"commentNum"];
    [aCoder encodeInteger:self.fovNum forKey:@"fovNum"];
    [aCoder encodeInteger:self.hotId forKey:@"hotId"];
    [aCoder encodeInteger:self.hotMp3Times forKey:@"hotMp3Times"];
    [aCoder encodeInteger:self.isZan forKey:@"isZan"];
    [aCoder encodeInteger:self.isCollection forKey:@"isCollection"];
    [aCoder encodeInteger:self.itemID forKey:@"itemID"];
    [aCoder encodeInteger:self.mp3Times forKey:@"mp3Times"];
    [aCoder encodeInteger:self.nextItemID forKey:@"nextItemID"];
    [aCoder encodeInteger:self.prevItemID forKey:@"prevItemID"];
    [aCoder encodeInteger:self.userID forKey:@"userID"];
    [aCoder encodeInteger:self.zanNum forKey:@"zanNum"];
    [aCoder encodeInteger:self.isShow forKey:@"isShow"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.headURL forKey:@"headURL"];
    [aCoder encodeObject:self.hotTitle forKey:@"hotTitle"];
    [aCoder encodeObject:self.hotMP3 forKey:@"hotMP3"];
    [aCoder encodeObject:self.shareURL forKey:@"shareURL"];
    [aCoder encodeObject:self.lyrics forKey:@"lyrics"];
    [aCoder encodeObject:self.titleImageURL forKey:@"titleImageURL"];
    [aCoder encodeObject:self.playURL forKey:@"playURL"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.detaile forKey:@"detaile"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.commentNum = [aDecoder decodeIntegerForKey:@"commentNum"];
        self.fovNum = [aDecoder decodeIntegerForKey:@"fovNum"];
        self.hotId = [aDecoder decodeIntegerForKey:@"hotId"];
        self.hotMp3Times = [aDecoder decodeIntegerForKey:@"hotMp3Times"];
        self.isZan = [aDecoder decodeIntegerForKey:@"isZan"];
        self.isCollection = [aDecoder decodeIntegerForKey:@"isCollection"];
        self.itemID = [aDecoder decodeIntegerForKey:@"itemID"];
        self.mp3Times = [aDecoder decodeIntegerForKey:@"mp3Times"];
        self.nextItemID = [aDecoder decodeIntegerForKey:@"nextItemID"];
        self.prevItemID = [aDecoder decodeIntegerForKey:@"prevItemID"];
        self.userID = [aDecoder decodeIntegerForKey:@"userID"];
        self.zanNum = [aDecoder decodeIntegerForKey:@"zanNum"];
        self.isShow = [aDecoder decodeIntegerForKey:@"isShow"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.headURL = [aDecoder decodeObjectForKey:@"headURL"];
        self.hotTitle = [aDecoder decodeObjectForKey:@"hotTitle"];
        self.hotMP3 = [aDecoder decodeObjectForKey:@"hotMP3"];
        self.shareURL = [aDecoder decodeObjectForKey:@"shareURL"];
        self.lyrics = [aDecoder decodeObjectForKey:@"lyrics"];
        self.titleImageURL = [aDecoder decodeObjectForKey:@"titleImageURL"];
        self.playURL = [aDecoder decodeObjectForKey:@"playURL"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.detaile = [aDecoder decodeObjectForKey:@"detaile"];
    }
    return self;
}

@end
