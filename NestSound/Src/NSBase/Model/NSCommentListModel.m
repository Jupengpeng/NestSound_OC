//
//  NSCommentListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/6.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCommentListModel.h"


@implementation NSCommentModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"commentID":@"id",
             @"commentType":@"comment_type",
             @"itemID":@"itemid",
             @"userID":@"uid",
             @"targetUserID":@"target_uid",
             @"type":@"type",
             @"createDate":@"createdate",
             @"comment":@"comment",
             @"headerURL":@"headerurl",
             @"nickName":@"nickname",
             @"targetName":@"targetname",
             @"titleImageURL":@"pic",
             @"title":@"title",
             @"authorName":@"author",
             @"nowTargetName":@"target_nickname"};
}

@end


@implementation NSCommentListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"commentList":@"data"};
}


@end
