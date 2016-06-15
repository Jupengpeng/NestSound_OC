//
//  NSPublicLyricModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@interface publicLyricModel : NSBaseModel
@property (nonatomic,assign) long itemID;
@property (nonatomic,copy) NSString * shareURL;

@end

@interface NSPublicLyricModel : NSBaseModel
@property (nonatomic,strong) publicLyricModel * publicLyricModel;
@end
