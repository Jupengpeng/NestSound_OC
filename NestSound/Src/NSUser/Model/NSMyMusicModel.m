//
//  NSMyMusicModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMyMusicModel.h"

@implementation NSMyMusicModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"createDate":@"createdate",
             @"fovNum":@"fovnum",
             @"isShow":@"is_issue",
             @"itemId":@"itemid",
             @"lookNum":@"looknum",
             @"upvoteNum":@"zannum",
             @"title":@"title",
             @"titleImageUrl":@"pic",
             @"titleImageUrls":@"pics",
             @"userID":@"uid",
             @"author":@"author",
             @"inTableTime":@"intabletime",
             @"type":@"type",
             @"spireContent":@"spirecontent",
             @"audio":@"audio"
             
             
             };
}
@end
