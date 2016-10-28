//
//  NSCooperationListTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationListTableViewCell.h"

@interface NSCooperationListTableViewCell ()
{
    UIView *sectionView;
    UILabel *nickName;
    UILabel *lyricLabel;
    UILabel *demandLabel;
    UIView *labelBackView;
}
@end

@implementation NSCooperationListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupCooperationListCellUI];
    }
    return self;
}
- (void)setupCooperationListCellUI {
    
    sectionView = [[UIView alloc] init];
    
    sectionView.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    [self.contentView addSubview:sectionView];
    
    //
    nickName = [[UILabel alloc] init];
    
    nickName.text = @"疯子";
    
    [self.contentView addSubview:nickName];
    
    //
    lyricLabel = [[UILabel alloc] init];
    
    lyricLabel.text = @"合作歌词合作歌词合作歌词合作歌词合作歌词合作歌词合作歌词合作歌词";
    
    lyricLabel.numberOfLines = 0;
    
    lyricLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:lyricLabel];
    
    //
    labelBackView = [[UIView alloc] init];
    
    labelBackView.backgroundColor = KBackgroundColor;
    
    [self.contentView addSubview:labelBackView];
    
    demandLabel = [[UILabel alloc] init];
    
    demandLabel.numberOfLines = 0;
    
    demandLabel.text = @"合作需求合作需求合作需求合作需求合作需求合作需求合作需求合作需求";
    
    demandLabel.font = [UIFont systemFontOfSize:12];
    
    [labelBackView addSubview:demandLabel];
    
    
}
- (void)layoutSubviews {
    
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(0);
        
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
        make.size.mas_equalTo(CGSizeMake(5, 20));
    }];
    
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(sectionView);
        
        make.left.equalTo(sectionView.mas_right).offset(5);
        
    }];
    
    [lyricLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(nickName.mas_left).offset(0);
        
        make.top.equalTo(sectionView.mas_bottom).offset(10);
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.height.mas_offset(50);
        
    }];
    
    [labelBackView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.contentView);
        
        make.top.equalTo(lyricLabel.mas_bottom).offset(10);
        
        make.height.mas_offset(70);
        
    }];
    
    [demandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.top.equalTo(labelBackView.mas_top).offset(10);
        
        make.height.mas_offset(50);
        
    }];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
