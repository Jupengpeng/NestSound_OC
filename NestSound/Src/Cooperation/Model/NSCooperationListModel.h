//
//  NSCooperationListModel.h
//  NestSound
//
//  Created by yinchao on 2016/10/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
//合作
@interface CooperationModel : NSBaseModel

@property (nonatomic, assign) int cooperationId;
@property (nonatomic, copy) NSString *cooperationTitle;
@property (nonatomic, copy) NSString *cooperationLyric;
@property (nonatomic, copy) NSString *requiement;
@property (nonatomic, assign) int commentNum;
@property (nonatomic, assign) int workNum;
@property (nonatomic, assign) long createTime;
@end


//评论
@protocol CooperationCommentModel <NSObject>

@end

@interface CooperationCommentModel : NSBaseModel
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *comment;
@end
 

//用户信息

@interface CooperationUser : NSBaseModel
@property (nonatomic ,copy) NSString *nickName;
@property (nonatomic ,copy) NSString *headerUrl;
@property (nonatomic ,assign) long uId;
@end


@protocol MainCooperationListModel <NSObject>

@end

@interface MainCooperationListModel : NSBaseModel
@property (nonatomic, strong) CooperationModel *cooperation;
@property (nonatomic, strong) NSArray <CooperationCommentModel> *cooperationCommentList;
@property (nonatomic, strong) CooperationUser *cooperationUser;
@end


@interface NSCooperationListModel : NSBaseModel
@property (nonatomic, strong) NSArray <MainCooperationListModel> *mainCooperationList;
@end
