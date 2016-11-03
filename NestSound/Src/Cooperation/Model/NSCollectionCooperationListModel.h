//
//  NSCollectionCooperationListModel.h
//  NestSound
//
//  Created by yinchao on 2016/10/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol CollectionCooperationModel <NSObject>


@end

@interface CollectionCooperationModel : NSBaseModel
@property (nonatomic, assign) int cooperationId;
@property (nonatomic, copy) NSString *cooperationTitle;
@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headerUrl;
@property (nonatomic, assign) long workNum;
@property (nonatomic, assign) long createTime;
@property (nonatomic, assign) long uId;
@end

@interface NSCollectionCooperationListModel : NSBaseModel
@property (nonatomic,strong) NSArray <CollectionCooperationModel> *collectionList;
@end
