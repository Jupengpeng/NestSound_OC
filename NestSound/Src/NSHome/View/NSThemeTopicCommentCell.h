//
//  NSThemeTopicCommentCell.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/16.
//  Copyright © 2016年 yinchao. All rights reserved.
//
@class NSJoinedWorkDetailModel;


typedef void(^NSThemeTopicCommentCellMoreCommentBlock)(NSInteger clickIndex,id obj);
typedef void(^NSThemeTopicCommentCellLaunchCommentBlock)(NSInteger clickIndex,id obj);
typedef void(^NSThemeTopicCommentCellHeaderClickBlock)(NSJoinedWorkDetailModel *workDetailModel);
typedef void(^NSThemeTopicCommentCellWorkCoverBlock)(NSJoinedWorkDetailModel *workDetailModel,UIButton *clickButton);
typedef void(^NSThemeTopicCommentCellCommentorClickBlock)(NSInteger commentorId);
#import <UIKit/UIKit.h>

@interface NSThemeTopicCommentCell : UITableViewCell


@property (nonatomic,copy) NSThemeTopicCommentCellMoreCommentBlock moreCommentClick;

@property (nonatomic,copy) NSThemeTopicCommentCellLaunchCommentBlock launchCommentClick;

@property (nonatomic,copy) NSThemeTopicCommentCellHeaderClickBlock headerClickBlock;

@property (nonatomic,copy) NSThemeTopicCommentCellWorkCoverBlock workCoverBlock;
@property (nonatomic,copy) NSThemeTopicCommentCellCommentorClickBlock commetorClickBlock;

@property (nonatomic,strong) NSJoinedWorkDetailModel *workDetailModel;


@end
