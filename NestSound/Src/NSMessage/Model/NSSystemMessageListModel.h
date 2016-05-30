//
//  NSSystemMessageListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@protocol SystemMessageModel <NSObject>
@end

@interface SystemMessageModel : NSBaseModel

@property (nonatomic,assign) NSDate * createDate;
@property (nonatomic,assign) long messageId;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * detailUrl;
@end

@interface NSSystemMessageListModel : NSBaseModel

@property (nonatomic,assign) long totalCount;
@property (nonatomic,strong) NSArray <SystemMessageModel> * systemMessageList;

@end
