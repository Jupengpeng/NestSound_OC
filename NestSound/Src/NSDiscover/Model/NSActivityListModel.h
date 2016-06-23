//
//  NSActivityListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol NSActivity <NSObject>
@end
@interface NSActivity : NSBaseModel

@property (nonatomic,assign) int  status;
@property (nonatomic,assign) long itemId;
@property (nonatomic,assign) NSTimeInterval beginDate;
@property (nonatomic,copy) NSString * detail;
@property (nonatomic,assign) NSTimeInterval endDate;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,copy) NSString * activityUrl;
@end

@interface NSActivityListModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSActivity> * ActivityList;

@end



