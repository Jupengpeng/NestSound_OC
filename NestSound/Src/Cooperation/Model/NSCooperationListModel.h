//
//  NSCooperationListModel.h
//  NestSound
//
//  Created by yinchao on 2016/10/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@interface CooperationModel : NSBaseModel

@property (nonatomic, assign) int cooperationId;
@property (nonatomic, copy) NSString *cooperationTitle;
@property (nonatomic, copy) NSString *cooperationLyric;
@property (nonatomic, copy) NSString *requiement;
@property (nonatomic, assign) int commentNum;
//@property (nonatomic, assign) int workNum;
@property (nonatomic, assign) long createTime;
@end
@interface CooperationListModel : NSBaseModel
@property (nonatomic,strong) CooperationModel *cooperation;
@end;

@interface NSCooperationListModel : NSBaseModel
@property (nonatomic, strong) CooperationListModel *cooperationList;
@end
