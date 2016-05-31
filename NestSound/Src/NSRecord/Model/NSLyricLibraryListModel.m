//
//  NSLyricLibraryListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricLibraryListModel.h"

@implementation NSLyricLibraryListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"LyricLibaryListModel":@"data"};
}

@end

@implementation NSTypeLyricListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"typeId":@"id",
             @"typeTitle":@"title",
             @"lyricLibaryList":@"libArr"};

}
@end

@implementation LyricLibList
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"libId":@"lid",
             @"lyrics":@"lyrics"};
    
}
@end
