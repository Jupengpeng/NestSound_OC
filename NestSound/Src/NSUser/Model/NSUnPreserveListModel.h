//
//  NSUnPreserveListModel.h
//  NestSound
//
//  Created by yinchao on 16/10/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
@protocol   NSUnPreserveModel <NSObject>
@end
@interface NSUnPreserveModel : NSBaseModel
@property(nonatomic,copy) NSString * title;
@property(nonatomic,assign) NSTimeInterval time;
@property(nonatomic,copy) NSString * productId;
@end

@interface NSUnPreserveListModel : NSBaseModel
@property (nonatomic,strong) NSArray <NSUnPreserveModel> *unPreserveList;
@end
