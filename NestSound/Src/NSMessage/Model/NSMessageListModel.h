//
//  NSMessageListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"




@interface messageCountModel : NSBaseModel

@property (nonatomic,assign) int commentCount;
@property (nonatomic,assign) int upvoteCount;
@property (nonatomic,assign) int collecCount;
@property (nonatomic,assign) int systemCount;
@property (nonatomic,assign) int preserveCount;
@property (nonatomic,assign) int cooperationCount;
@end

@interface NSMessageListModel : NSBaseModel

@property (nonatomic,strong) messageCountModel * messageCount;

@end
