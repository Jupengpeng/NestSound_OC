//
//  NSDraftBoxTableViewCell.h
//  NestSound
//
//  Created by Apple on 16/5/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSDraftBoxTableViewCell;

@protocol NSDraftBoxTableViewCellDelegate <NSObject>

- (void)draftBoxTableViewCell:(NSDraftBoxTableViewCell *)draftBoxCell withSendBtn:(UIButton *)sendBtn;

@end

@interface NSDraftBoxTableViewCell : UITableViewCell

@property (nonatomic, weak) id<NSDraftBoxTableViewCellDelegate> delegate;

@end
