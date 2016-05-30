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

    return @{@"SongList":@"data"};
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
             @"workName":@"name",
             @"playUrl":@"playurl",
             @"itemId":@"itemid"
             };

}

@end
