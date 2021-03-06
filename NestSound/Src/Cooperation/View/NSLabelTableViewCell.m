//
//  NSLabelTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLabelTableViewCell.h"
#import "NSCooperationListModel.h"
@interface NSLabelTableViewCell ()
{
    UILabel *commentLabel;
}
@end

@implementation NSLabelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupLabelCommentCellUI];
    }
    return self;
}
- (void)setupLabelCommentCellUI {
    
    commentLabel = [[UILabel alloc] init];
    
    commentLabel.text = @"长安不会乱:评论";
    
    commentLabel.textColor = [UIColor lightGrayColor];
    
    commentLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:commentLabel];
    
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.top.equalTo(self.contentView.mas_top).offset(5);
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}
- (void)setCommentModel:(CooperationCommentModel *)commentModel {
    _commentModel = commentModel;
    commentLabel.attributedText = [attributedString getMutableAttributedString:[NSString stringWithFormat:@"%@:%@",commentModel.nickName,commentModel.comment] textColor:[UIColor darkGrayColor] length:commentModel.nickName.length];
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
