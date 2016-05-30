//
//  NSLyricDetailModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricDetailModel.h"



@implementation  LyricDetailModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"commentNum":@"commentnum",
             @"fovNum":@"fovnum",
             @"zanNum":@"zannum",
             @"isCollect":@"isCollect",
             @"isZan":@"isZan",
             @"status":@"status",
             @"itemId":@"itemid",
             @"simpleId":@"sampleid",
             @"userId":@"uid",
             @"author":@"author",
             @"lyrics":@"lyrics",
             @"shareUrl":@"shareurl",
             @"titleImageUrl":@"pic",
             @"title":@"title",
             @"headerUrl":@"headurl",
             @"createDate":@"createdare"
             };
}

@end

@implementation NSLyricDetailModel

-(NSDictionary *)modelKeyJSONKeyMapper
{

    return  @{@"lyricDetailModel":@"data"};
}


@end
