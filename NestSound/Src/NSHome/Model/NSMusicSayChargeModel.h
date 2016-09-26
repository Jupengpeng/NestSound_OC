//
//  NSMusicSayChargeModel.h
//  NestSound
//
//  Created by yintao on 16/9/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@class NSMetadataModel,NSRefundsModel,NSExtraModel,NSCredentialModel,NSWxModel;


@interface NSMusicSayChargeModel : NSBaseModel


@property (nonatomic, copy) NSString *time_settle;

@property (nonatomic, copy) NSString *descStr;

@property (nonatomic, copy) NSString *transaction_no;

@property (nonatomic, copy) NSString *time_paid;

@property (nonatomic, strong) NSMetadataModel *metadata;

@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, strong) NSExtraModel *extra;

@property (nonatomic, assign) BOOL livemode;

@property (nonatomic, copy) NSString *order_no;

@property (nonatomic, strong) NSRefundsModel *refunds;

@property (nonatomic, copy) NSString *object;

@property (nonatomic, copy) NSString *currency;

@property (nonatomic, assign) BOOL refunded;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *subject;

@property (nonatomic, assign) NSInteger amount_refunded;

@property (nonatomic, copy) NSString *failure_code;

@property (nonatomic, assign) BOOL paid;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, assign) NSInteger amount_settle;

@property (nonatomic, copy) NSString *failure_msg;

@property (nonatomic, assign) NSInteger time_expire;

@property (nonatomic, copy) NSString *client_ip;

@property (nonatomic, strong) NSCredentialModel *credential;

@property (nonatomic, assign) NSInteger created;

@property (nonatomic, copy) NSString *app;

@end


@interface NSMetadataModel : NSObject


@end

@interface NSRefundsModel : NSObject

@property (nonatomic, assign) BOOL has_more;

@property (nonatomic, copy) NSString *object;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) NSString *url;

@end

@interface NSExtraModel : NSObject

@end

@interface NSCredentialModel : NSObject

@property (nonatomic, strong) NSWxModel *wx;

@property (nonatomic, copy) NSString *object;

@end

@interface NSWxModel : NSObject

@property (nonatomic, copy) NSString *nonceStr;

@property (nonatomic, copy) NSString *partnerId;

@property (nonatomic, copy) NSString *timeStamp;

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, copy) NSString *packageValue;

@property (nonatomic, copy) NSString *prepayId;

@property (nonatomic, copy) NSString *sign;

@end

