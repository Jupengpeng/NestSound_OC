//
//  NSCommentListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/6.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol NSCommentModel <NSObject>
@end
@interface NSCommentModel : NSBaseModel
@property (nonatomic,assign) long commentID;
@property (nonatomic,assign) int commentType;
@property (nonatomic,assign) long itemID;
@property (nonatomic,assign) long userID;
@property (nonatomic,assign) long targetUserID;
@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString * comment;
@property (nonatomic,copy) NSString * headerURL;
@property (nonatomic,copy) NSString * nickName;
@property (nonatomic,copy) NSString * targetName;//commented Name
@end

@interface NSCommentListModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSCommentModel> * commentList;

@end
