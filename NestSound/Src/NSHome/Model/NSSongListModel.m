//
//  NSSongListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongListModel.h"





@implementation NSSongListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"SongList":@"data",
             @"songListDetail":@"data"};

}


@end

@implementation NSSongListDetail
-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"listDetail":@"recommedSong"};
}

@end

@implementation  SongListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"songList":@"workList"};
}

@end


@implementation songModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"author":@"author",
             @"workName":@"title",
             @"playUrl":@"playurl",
             @"itemId":@"itemid"
             };

}

@end
