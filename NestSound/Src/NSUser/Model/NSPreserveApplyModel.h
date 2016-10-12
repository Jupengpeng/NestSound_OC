//
//  NSPreserveApplyMododel.h
//  NestSound
//
//  Created by yintao on 16/10/9.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@interface NSPreserveProductInfoModel : NSBaseModel

@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *lyricAuthor;

@property (nonatomic,copy) NSString *songAuthor;

@property (nonatomic,copy) NSString *accompaniment;

@property (nonatomic,copy) NSString *createTime;

@property (nonatomic,copy) NSString *image;

@property (nonatomic,copy) NSString *type;

@end

@interface NSPreservePersonInfoModel : NSBaseModel

@property (nonatomic,copy) NSString *cUserName;

@property (nonatomic,copy) NSString *cCardId;

@property (nonatomic,copy) NSString *cPhone;

@property (nonatomic,copy) NSString *cUid;

@end

@interface NSPreserveOrderPriceModel : NSBaseModel

@property (nonatomic,strong) NSArray *orderPriceArray;

@end

@interface NSPreserveApplyModel : NSBaseModel

@property (nonatomic,strong) NSPreserveProductInfoModel *productInfo;

@property (nonatomic,strong) NSPreservePersonInfoModel *personInfo;

@property (nonatomic,strong) NSArray *orderPrice;

@end


