//
//  NSUserProfileViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
@class qiNiu;
@interface NSUserProfileViewController : NSBaseViewController

@property (nonatomic,strong) qiNiu * qiniuDetail;
- (instancetype)initWithUserDictionary:(NSDictionary *)dic;
@end
