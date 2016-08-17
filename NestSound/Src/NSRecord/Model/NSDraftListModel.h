//
//  NSDraftListModel.h
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@protocol  NSDraftModel <NSObject>
@end

@interface NSDraftModel : NSBaseModel
@property (nonatomic,assign) long itemId;
@property (nonatomic,assign) long uid;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * draftdesc;


@end

@interface NSDraftListModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSDraftModel> * draftList;
@end
