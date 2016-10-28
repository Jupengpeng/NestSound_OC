//
//  NSCooperationMessageTableViewCell.h
//  NestSound
//
//  Created by yinchao on 16/10/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSCooperationMessageTableViewCell;

@protocol NSCooperationMessageTableViewCellDelegate <NSObject>

- (void)commentTableViewCell:(NSCooperationMessageTableViewCell *)cell;
- (void)replyCommentTableViewCell:(NSCooperationMessageTableViewCell *)cell;
@end
@interface NSCooperationMessageTableViewCell : UITableViewCell
//评论内容
@property (nonatomic, strong) TTTAttributedLabel *commentLabel;

@property (nonatomic, assign) CGFloat commentLabelMaxY;

//作者名
@property (nonatomic, strong) UILabel *authorNameLabel;

//@property (nonatomic,strong) NSCommentModel * commentModel;

@property (nonatomic, weak) id<NSCooperationMessageTableViewCellDelegate> delegate;
@end
