//
//  NSCommentMessageListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol  commentMessageModel <NSObject>
@end

@interface commentMessageModel : NSBaseModel

@property (nonatomic,assign) int commentType;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) long commentId;
@property (nonatomic,assign) long targetUserID;//commented userid == myself
@property (nonatomic,assign) long userId;//comment userid
@property (nonatomic,assign) long workId;//comment workID
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * comment;
@property (nonatomic,assign) NSTimeInterval  createDate;
@property (nonatomic,copy) NSString * headerUrl;
@property (nonatomic,copy) NSString * nickName;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,copy) NSString * targetHeaderUrl;//commented headerURl
@property (nonatomic,copy) NSString * targetName;//commented name
@property (nonatomic,copy) NSString * workName;


@end

@interface NSCommentMessageListModel : NSBaseModel

@property (nonatomic,assign) long totalCount;
@property (nonatomic,strong) NSArray <commentMessageModel> * commentMessageList;

@end
