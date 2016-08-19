//
//  NSThemeTopicCommentCell.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/16.
//  Copyright © 2016年 yinchao. All rights reserved.
//

typedef void(^NSThemeTopicCommentCellMoreCommentClick)(NSInteger clickIndex,id);
typedef void(^NSThemeTopicCommentCellLaunchCommentClick)(NSInteger clickIndex,id);


@class NSJoinedWorkDetailModel;

#import <UIKit/UIKit.h>

@interface NSThemeTopicCommentCell : UITableViewCell


@property (nonatomic,copy) NSThemeTopicCommentCellMoreCommentClick moreCommentClick;

@property (nonatomic,copy) NSThemeTopicCommentCellLaunchCommentClick launchCommentClick;



@property (nonatomic,strong) NSJoinedWorkDetailModel *workDetailModel;

@end
