//
//  NSInvitationListModel.m
//  NestSound
//
//  Created by yinchao on 2016/11/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInvitationListModel.h"

@implementation InvitationModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"uId":@"uid",
             @"nickName":@"nickname",
             @"headerUrl":@"headurl",
             @"signature":@"signature",
             @"isInvited":@"invite",
             @"isRecommend":@"recommend"};
}

@end

@implementation NSInvitationListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"invitationList":@"data"};
}
@end
