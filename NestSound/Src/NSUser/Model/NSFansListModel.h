//
//  NSFansListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@protocol   NSFansModel <NSObject>
@end
@interface NSFansModel : NSBaseModel
@property (nonatomic,assign) long fansID;
@property (nonatomic,assign) int status;
@property (nonatomic,copy) NSString * fansSign;
@property (nonatomic,copy) NSString * fansName;
@property (nonatomic,copy) NSString * fansHeadURL;



@end

@interface NSFansListModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSFansModel> * fansListModel;

@end
