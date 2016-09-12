//
//  NSUserMessageViewController.h
//  NestSound
//
//  Created by yinchao on 16/9/12.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
typedef  NS_ENUM(NSInteger,UserMessageType){
    
    EditMessageType,
    ShowMessageType
};
@interface NSUserMessageViewController : NSBaseViewController
-(instancetype)initWithUserMessageType:(UserMessageType)messageType_;
@end
