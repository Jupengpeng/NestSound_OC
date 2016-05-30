//
//  NSMyInspirationListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"



@protocol InspirationModel <NSObject>
@end
@interface InspirationModel : NSBaseModel
@property (nonatomic,assign) NSDate * createDate;
@property (nonatomic,assign) long userId;
@property (nonatomic,assign) long itemId;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * audioUrl;
@property (nonatomic,copy) NSString * titleImageUrl;

@end

@interface NSMyInspirationList : NSBaseModel
@property (nonatomic,strong) NSArray <InspirationModel> * myInspirationList;

@end

@interface NSMyInspirationListModel : NSBaseModel

@property (nonatomic,strong) NSMyInspirationList * MyInspirationList;

@end
