//
//  NSThemeCommentCell.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

typedef void(^NSThemeCommentCellCommentorClickBlock)(NSInteger commentorId);

@class  NSJoinWorkCommentModel;
#import <UIKit/UIKit.h>

@interface NSThemeCommentCell : UITableViewCell

@property (nonatomic,strong) NSJoinWorkCommentModel *commentModel;

//评论内容
@property (nonatomic, strong) TTTAttributedLabel *commentLabel;

@property (nonatomic, assign) CGFloat commentLabelMaxY;

//作者名
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic,copy) NSThemeCommentCellCommentorClickBlock commetorClickBlock;


@end
