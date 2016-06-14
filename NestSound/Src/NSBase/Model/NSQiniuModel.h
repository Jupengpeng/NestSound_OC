//
//  NSQiniuModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@interface QiniuDetail : NSBaseModel

@property (nonatomic,copy) NSString * fileName;
@property (nonatomic,copy) NSString * token;
@property (nonatomic,copy) NSString * QiniuDomain;


@end

@interface NSQiniuModel : NSBaseModel
@property (nonatomic,strong) QiniuDetail * qiniuDetail;
@end
