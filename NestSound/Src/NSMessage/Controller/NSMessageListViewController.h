//
//  NSMessageListViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

typedef  NS_ENUM(NSInteger,MessageType){
    
    UpvoteMessageType,
    CollectionMessageType,
    CommentMessageType,
    SystemMessageType

};

@interface NSMessageListViewController : NSBaseViewController

@property (nonatomic,copy) NSString * messageListType;

-(instancetype)initWithMessageType:(MessageType)messageType_;

@end
