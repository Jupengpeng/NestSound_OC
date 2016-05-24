//
//  NSDicoverLyricListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDicoverLyricListModel.h"

@implementation NSDicoverLyricListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"HotLyricList":@"data",
             @"LyricList":@"data"
             };
}

@end

@implementation NSHotLyricListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"hotLyricList":@"redList"};
    
}

@end

@implementation NSLyricListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"lyricList":@"newList"};
}

@end