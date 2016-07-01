//
//  NSUpvoteMessageListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUpvoteMessageListModel.h"


@implementation UpvoteMessage
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"messageId":@"id",
             @"target_uid":@"target_uid",
             @"userId":@"user_id",
             @"type":@"type",
             @"workId":@"itemid",
             @"upvoteTime":@"intabletime",
             @"author":@"author",
             @"headerUrl":@"headerurl",
             @"nickName":@"nickname",
             @"titleImageUrl":@"pic",
             @"titleImageUrls":@"pics",
             @"workName":@"title"
             };

}
@end


@implementation NSUpvoteMessageListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"upvoteMessageList":@"data"};
}

@end
