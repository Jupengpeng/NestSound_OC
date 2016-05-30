//
//  NSCommentMessageListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCommentMessageListModel.h"


@implementation commentMessageModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"commentType":@"comment_type",
             @"type":@"type",
             @"commentId":@"id",
             @"targetUserID":@"target_uid",
             @"userId":@"uid",
             @"workId":@"workid",
             @"author":@"author",
             @"comment":@"comment",
             @"createDate":@"createdate",
             @"headerUrl":@"headerurl",
             @"nickName":@"nickname",
             @"titleImageUrl":@"pic",
             @"targetHeaderUrl":@"targetHeader",
             @"targetName":@"targetname",
             @"workName":@"title",
             };

}
@end


@implementation NSCommentMessageListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"commentMessageList":@"data"};
}
@end
