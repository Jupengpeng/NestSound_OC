//
//  NSCooperationDetailModel.m
//  NestSound
//
//  Created by yintao on 2016/11/2.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationDetailModel.h"
#import "NSCommentListModel.h"
@implementation NSCooperationDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"completeList" : [CoWorkModel class],
             @"commentList" : [CommentModel class],
             @"userInfo" : @"userInfo" ,
             @"demandInfo":@"demandInfo"};
}

- (NSArray *)commentArray{
    
    NSMutableArray *commentArray = [NSMutableArray array];
    for (CommentModel *oriModel in self.commentList) {
        NSCommentModel *commentModel = [[NSCommentModel alloc] init];
        
        commentModel.commentID = oriModel.id;
        commentModel.type = oriModel.type;
        commentModel.commentType = oriModel.comment_type;
        commentModel.itemID = oriModel.itemid;
        commentModel.userID = oriModel.uid;
        commentModel.targetUserID = oriModel.target_uid;
        commentModel.createDate = oriModel.createdate;
        commentModel.comment = oriModel.comment;
        commentModel.headerURL = oriModel.headerurl;
        commentModel.nickName = oriModel.nickname;
        commentModel.titleImageURL = oriModel.targetheaderurl;
        commentModel.nowTargetName = oriModel.target_nickname;
        commentModel.nickName = oriModel.nickname;
        [commentArray addObject:commentModel];
    }
    _commentArray = [NSMutableArray arrayWithArray:commentArray];

    return _commentArray;
    
}

@end

@implementation UserinfoModel

@end


@implementation DemandinfoModel

@end


@implementation CoWorkModel


@end


@implementation CommentModel

@synthesize id = _id;

@end
