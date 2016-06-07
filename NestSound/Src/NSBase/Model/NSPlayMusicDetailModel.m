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
             @"author":@"author"};

}

@end