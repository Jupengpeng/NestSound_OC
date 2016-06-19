//
//  NSUserModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/3.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@interface userModel : NSBaseModel

@property (nonatomic,assign) long userID;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * headerURL;
@property (nonatomic,copy) NSString * loginToken;
@property (nonatomic,copy) NSString * birthday;
@property (nonatomic,copy) NSString * desc;
@property (nonatomic,assign) int male;
@end

@interface NSUserModel : NSBaseModel

@property (nonatomic,strong) userModel * userDetail;
@end
