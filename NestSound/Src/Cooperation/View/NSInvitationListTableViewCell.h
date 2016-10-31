//
//  NSInvitationListTableViewCell.h
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSInvitationListTableViewCell;

@protocol NSInvitationListTableViewCellDelegate <NSObject>

- (void)invitationBtnClickWith:(NSInvitationListTableViewCell *)cell;

@end

@interface NSInvitationListTableViewCell : UITableViewCell
@property (nonatomic,assign) id <NSInvitationListTableViewCellDelegate> delegate;
@end
