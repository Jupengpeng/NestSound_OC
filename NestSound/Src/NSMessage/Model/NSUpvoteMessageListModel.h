//
//  NSUpvoteMessageListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol UpvoteMessage  <NSObject>
@end

@interface UpvoteMessage : NSBaseModel

@property (nonatomic,assign) long messageId;
@property (nonatomic,assign) long target_uid; //userID
@property (nonatomic,assign) long userId;//upvote userID
@property (nonatomic,assign) int type;
@property (nonatomic,assign) long workId;
@property (nonatomic,assign) NSDate * upvoteTime;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * headerUrl;
@property (nonatomic,copy) NSString * nickName;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,copy) NSString * workName;

@end


@interface NSUpvoteMessageListModel : NSBaseModel

@property (nonatomic,assign) long totalCount;
@property (nonatomic,strong) NSArray <UpvoteMessage> * upvoteMessageList;

@end
