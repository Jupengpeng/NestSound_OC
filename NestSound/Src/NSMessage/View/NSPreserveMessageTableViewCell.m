//
//  NSPreserveMessageTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveMessageTableViewCell.h"
#import "NSPreserveMessageListModel.h"
@interface NSPreserveMessageTableViewCell ()
{
    UIImageView *avatarImg;
    UILabel *titleLabel;
    UILabel *dateLabel;
    UILabel *contentLabel;
}
@end


@implementation NSPreserveMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupPreserveMessageCell];
    }
    return self;
}
- (void)setupPreserveMessageCell {
    avatarImg = [[UIImageView alloc] init];
    
    [self.contentView addSubview:avatarImg];
    
    //标题
    titleLabel = [[UILabel alloc] init];
    
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    titleLabel.textColor = [UIColor hexColorFloat:@"#333"];
    
    titleLabel.text = @"音淘网络科技";
    
    [self.contentView addSubview:titleLabel];
    
    //日期
    dateLabel = [[UILabel alloc] init];
    
    dateLabel.font = [UIFont systemFontOfSize:12];
    
    dateLabel.textColor = [UIColor hexColorFloat:@"#999"];
    
    dateLabel.text = @"2016-05-26";
    
    [self.contentView addSubview:dateLabel];
    
    contentLabel = [[UILabel alloc] init];
    
    contentLabel.font = [UIFont systemFontOfSize:13];
    
    contentLabel.numberOfLines = 0;
    
    contentLabel.textColor = [UIColor hexColorFloat:@"#666"];
    
    contentLabel.text = @"尊敬的张某某，您为作品《好久不见》申请的歌词版权认证已经成功了！";
    
    [self.contentView addSubview:contentLabel];
    
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //
    [avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
        make.width.mas_equalTo(35);
        
        make.height.mas_equalTo(35);
        
    }];
    
    //标题
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(avatarImg.mas_right).offset(10);
        
        make.top.equalTo(avatarImg.mas_top);
        
    }];
    
    //日期
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(avatarImg.mas_right).offset(10);
        
        make.bottom.equalTo(avatarImg.mas_bottom);
        
    }];
    
    //内容
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(15);
        
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        
        make.top.equalTo(avatarImg.mas_bottom).offset(10);
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        
    }];
    
}
- (void)setPreserveModel:(NSPreserveMessage *)preserveModel {
    _preserveModel = preserveModel;
    titleLabel.text = preserveModel.title;
    if ([preserveModel.pushtype isEqualToString:@"copyrighSuccess"]) {
        avatarImg.image = [UIImage imageNamed:@"2.2_preerve_success"];
    } else if ([preserveModel.pushtype isEqualToString:@"copyrighFail"]){
        avatarImg.image = [UIImage imageNamed:@"2.2_preserve_fail"];
    } else if ([preserveModel.pushtype isEqualToString:@"activityFinish"]||[preserveModel.pushtype isEqualToString:@"newActivity"]) {
        titleLabel.text = @"活动通知";
        avatarImg.image = [UIImage imageNamed:@"2.2_message_activity"];
    } else if ([preserveModel.pushtype isEqualToString:@"addToSonglist"]||[preserveModel.pushtype isEqualToString:@"recommedToIndex"]) {
        titleLabel.text = @"推荐通知";
        avatarImg.image = [UIImage imageNamed:@"2.2_message_recommend"];
    } else if ([preserveModel.pushtype isEqualToString:@"cooperateComplete"]) {
        titleLabel.text = @"完成合作";
        avatarImg.image = [UIImage imageNamed:@"2.3_message_complete"];
    } else if ([preserveModel.pushtype isEqualToString:@"cooperateInvite"]) {
        titleLabel.text = @"合作邀请";
        avatarImg.image = [UIImage imageNamed:@"2.3_message_invite"];
    } else if ([preserveModel.pushtype isEqualToString:@"cooperateAccess"]) {
        titleLabel.text = @"合作采纳";
        avatarImg.image = [UIImage imageNamed:@"2.3_message_accept"];
    } else if ([preserveModel.pushtype isEqualToString:@"cooperateExpire"]) {
        titleLabel.text = @"合作到期";
        avatarImg.image = [UIImage imageNamed:@"2.3_message_endTime"];
    } else if ([preserveModel.pushtype isEqualToString:@"cooperateLeave"] || [preserveModel.pushtype isEqualToString:@"cooperateLeaveReply"]) {
        titleLabel.text = @"留言消息";
        avatarImg.image = [UIImage imageNamed:@"2.3_message_message"];
    }
    
    dateLabel.text = [date datetoLongLongStringWithDate:preserveModel.time];
    contentLabel.text = preserveModel.content;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
