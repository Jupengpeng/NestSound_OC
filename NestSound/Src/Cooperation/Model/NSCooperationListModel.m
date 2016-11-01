//
//  NSCooperationListModel.m
//  NestSound
//
//  Created by yinchao on 2016/10/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationListModel.h"

@implementation CooperationModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperationId":@"id",
             @"cooperationTitle":@"title",
             @"cooperationLyric":@"lyrics",
             @"requiement":@"requirement",
             @"commentNum":@"commentnum",
             @"createTime":@"createtime"};
}

@end

@implementation CooperationListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperation":@"demandInfo"};
}

@end


@implementation CooperationCommentModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"nickName":@"nickname",
             @"comment":@"comment"};
}

@end

@implementation CooperationCommentListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperationComment":@"commentList"};
}

@end

@implementation CooperationUser

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"nickName@":@"nickname",
             @"headerUrl":@"headerurl",
             @"uId":@"uid"};
}

@end

@implementation NSCooperationUser

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperationUser":@"userInfo"};
}

@end

@implementation NSCooperationListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperationList":@"data",
             @"commentList":@"data",
             @"cooperationUser":@"data"};
}

@end
