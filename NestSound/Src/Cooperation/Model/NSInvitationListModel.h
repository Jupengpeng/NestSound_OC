//
//  NSInvitationListModel.h
//  NestSound
//
//  Created by yinchao on 2016/11/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol InvitationModel <NSObject>


@end

@interface InvitationModel : NSBaseModel

@property (nonatomic, assign) long uId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headerUrl;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, assign) int isInvited;
@property (nonatomic, assign) int isRecommend;
@end

@interface NSInvitationListModel : NSBaseModel
@property (nonatomic, strong) NSArray <InvitationModel> *invitationList;
@end
