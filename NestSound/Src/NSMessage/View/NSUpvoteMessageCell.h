//
//  NSUpvoteMessageCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UpvoteMessage;
@interface NSUpvoteMessageCell : UITableViewCell


@property (nonatomic,assign) BOOL isUpvote;

@property (nonatomic,strong) UpvoteMessage * upvoteMessage;
@property (nonatomic,strong) UpvoteMessage * collectionMessage;


@end
