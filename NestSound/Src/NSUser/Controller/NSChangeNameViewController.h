//
//  NSChangeNameViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

typedef void(^returnName)(NSString * name);
@interface NSChangeNameViewController : NSBaseViewController

@property (nonatomic,copy) returnName  returnNameBlock;

-(instancetype)initWithType:(NSString *)type;

-(void)returnName:(returnName)block;

@end
