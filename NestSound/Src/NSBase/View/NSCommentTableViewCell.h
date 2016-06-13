//
//  NSCommentTableViewCell.h
//  NestSound
//
//  Created by Apple on 16/5/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSCommentTableViewCell;
@class NSCommentModel;
@protocol NSCommentTableViewCellDelegate <NSObject>

- (void)commentTableViewCell:(NSCommentTableViewCell *)cell;

@end


@interface NSCommentTableViewCell : UITableViewCell

//评论内容
@property (nonatomic, strong) TTTAttributedLabel *commentLabel;

@property (nonatomic, assign) CGFloat commentLabelMaxY;

//作者名
@property (nonatomic, strong) UILabel *authorNameLabel;

@property (nonatomic,strong) NSCommentModel * commentModel;

@property (nonatomic, weak) id<NSCommentTableViewCellDelegate> delegate;

@end
