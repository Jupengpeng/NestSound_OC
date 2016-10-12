//
//  NSPreserveListModel.h
//  NestSound
//
//  Created by yinchao on 16/9/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol   NSPreserveModel <NSObject>

@end
@interface NSPreserveModel : NSBaseModel

//@property (nonatomic,assign) int status;
@property (nonatomic,copy) NSString * preserveName;
@property (nonatomic,copy) NSString * createTime;
@property (nonatomic,copy) NSString * preserveId;
@property (nonatomic,assign) long status;
@property (nonatomic,assign) long sortId;

@end


@interface NSPreserveListModel : NSBaseModel
@property (nonatomic,strong) NSArray <NSPreserveModel> *preserveList;
@end

