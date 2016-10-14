//
//  NSPreserveMessageListModel.h
//  NestSound
//
//  Created by yinchao on 16/10/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol NSPreserveMessage  <NSObject>
@end

@interface NSPreserveMessage : NSBaseModel

@property (nonatomic,assign) NSTimeInterval  time;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * pushtype;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * orderNo;

@end
@interface NSPreserveMessageListModel : NSBaseModel
@property (nonatomic,strong) NSArray <NSPreserveMessage> * preserveMessageList;
@end
