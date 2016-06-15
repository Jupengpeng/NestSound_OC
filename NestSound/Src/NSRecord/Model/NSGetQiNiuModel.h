//
//  NSGetQiNiuModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@interface qiNiu : NSBaseModel
@property (nonatomic,copy) NSString * fileName;
@property (nonatomic,copy) NSString * token;
@property (nonatomic,copy) NSString * qiNIuDomain;

@end

@interface NSGetQiNiuModel : NSBaseModel
@property (nonatomic,strong) qiNiu * qiNIuModel;
@end
