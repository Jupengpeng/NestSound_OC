//
//  NSPreserveDetailListModel.h
//  NestSound
//
//  Created by yinchao on 16/10/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@interface NSProductModel : NSBaseModel
@property (nonatomic,assign) long productId;
@property (nonatomic,copy) NSString * productTitle;
@property (nonatomic,copy) NSString * songAuthor;
@property (nonatomic,copy) NSString * lyricAuthor;
@property (nonatomic,copy) NSString * accompaniment;
@property (nonatomic,assign) NSTimeInterval createTime;
@property (nonatomic,copy) NSString * productImg;
@property (nonatomic,assign) NSTimeInterval preserveTime;
@property (nonatomic,copy) NSString * preserveNo;
@property (nonatomic,assign) long type;
@end

@interface NSProductListModel : NSBaseModel
@property (nonatomic,strong) NSProductModel *productModel;
@end

@interface NSPersonModel : NSBaseModel
//@property (nonatomic,assign) long userId;
@property (nonatomic,copy) NSString * userPhone;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * userIDNo;
@property (nonatomic,assign) int userIdentity;
@end

@interface NSPersonListModel : NSBaseModel
@property (nonatomic,strong) NSPersonModel *personModel;
@end

@interface NSPreserveResultModel : NSBaseModel
@property (nonatomic,copy) NSString * certificateURL;
@property (nonatomic,assign) long preserveId;
@property (nonatomic,assign) long status;
@end

@interface NSPreserveDetailListModel : NSBaseModel
@property (nonatomic,strong) NSProductListModel * productList;
@property (nonatomic,strong) NSPersonListModel * personList;
@property (nonatomic,strong) NSPreserveResultModel * preserveResultModel;
@end
