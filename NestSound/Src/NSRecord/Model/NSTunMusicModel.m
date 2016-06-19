//
//  NSTunMusicModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSTunMusicModel.h"

@implementation NSTunMusicModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return  @{@"tunMusicModel":@"data"};
}
@end

@implementation TunMusicMoel
-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"oldPath":@"oldPath",
             @"MusicPath":@"newPath"};
}

@end