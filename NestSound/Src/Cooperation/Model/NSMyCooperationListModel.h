//
//  NSMyCooperationListModel.h
//  NestSound
//
//  Created by yinchao on 2016/10/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol myCooperationModel <NSObject>


@end

@interface myCooperationModel : NSBaseModel
@property (nonatomic, assign) int myCooperationId;
@property (nonatomic, copy) NSString *cooperationTitle;
@property (nonatomic, assign) long workNum;
@property (nonatomic, assign) long createTime;
@property (nonatomic, copy) NSString *status;
@end

@interface NSMyCooperationListModel : NSBaseModel
@property (nonatomic, strong) NSArray <myCooperationModel> *myCooperationList;
@end
