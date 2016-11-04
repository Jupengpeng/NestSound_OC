//
//  NSInvitationListTableViewCell.h
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CooperationUser;
@class CooperationModel;
@class InvitationModel;
@class NSInvitationListTableViewCell;

@protocol NSInvitationListTableViewCellDelegate <NSObject>

- (void)invitationBtnClickWith:(NSInvitationListTableViewCell *)cell;
- (void)iconBtnClickWith:(NSInvitationListTableViewCell *)cell;
@end

@interface NSInvitationListTableViewCell : UITableViewCell
@property (nonatomic,assign) id <NSInvitationListTableViewCellDelegate> delegate;
@property (nonatomic, strong) CooperationUser *cooperationUser;
@property (nonatomic, strong) CooperationModel *cooperationModel;
@property (nonatomic, strong) InvitationModel *invitationModel;
@property (nonatomic, strong) UIButton *invitationBtn;
@end
