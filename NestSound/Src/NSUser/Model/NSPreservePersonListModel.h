//
//  NSPreservePersonListModel.h
//  NestSound
//
//  Created by yinchao on 16/9/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
@protocol   NSPreservePersonModel <NSObject>
@end
@interface NSPreservePersonModel : NSBaseModel
@property(nonatomic,copy) NSString * userName;
@property(nonatomic,copy) NSString * userPhone;
@property(nonatomic,copy) NSString * userId;
@end


@interface NSPreservePersonListModel : NSBaseModel
@property (nonatomic,strong) NSArray <NSPreservePersonModel> *preservePerList;
@end
