//
//  NSUserMusicListModel.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserMusicListModel.h"



@implementation NSUserMusicModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    
    return @{@"status":@"status",
             @"title":@"title",
             @"createtime":@"createtime",
             @"pic":@"pic",
             @"itemid":@"itemid",

             };
    
}

@end


@implementation NSUserMusicListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    
    return @{@"myMusicList":@"data",

             };
    
}



@end
