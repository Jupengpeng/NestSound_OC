//
//  NSCooperationListTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationListTableViewCell.h"
#import "NSCooperationListModel.h"
@interface NSCooperationListTableViewCell ()
{
    UIView *sectionView;
    UILabel *titleLabel;
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
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-10, 0.8)];
    
    separatorLine.backgroundColor = KBackgroundColor;
    
    [self.contentView addSubview:separatorLine];
    
    sectionView = [[UIView alloc] init];
    
    sectionView.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    [self.contentView addSubview:sectionView];
    
    //
    titleLabel = [[UILabel alloc] init];
    
    titleLabel.text = @"音淘网络";
    
    [self.contentView addSubview:titleLabel];
    
    //
    lyricLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    lyricLabel.text = @"合作歌词合作歌词合作歌词合作歌词合作歌词合作歌词合作歌词合作歌词";
    
    lyricLabel.numberOfLines = 3;
    
    lyricLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:lyricLabel];
    
    //
    labelBackView = [[UIView alloc] initWithFrame:CGRectZero];
    
    labelBackView.backgroundColor = KBackgroundColor;
    
    [self.contentView addSubview:labelBackView];
    
    demandLabel = [[UILabel alloc] init];
    
    demandLabel.numberOfLines = 0;
    
    demandLabel.text = @"合作需求合作需求合作需求合作需求合作需求合作需求合作需求合作需求";
    
    demandLabel.font = [UIFont systemFontOfSize:12];
    
    [labelBackView addSubview:demandLabel];
    
    
}

- (void)setCooperationModel:(CooperationModel *)cooperationModel {
    
    _cooperationModel = cooperationModel;
    titleLabel.text = cooperationModel.cooperationTitle;
    lyricLabel.text = cooperationModel.cooperationLyric;
    demandLabel.text = cooperationModel.requiement;
    CGSize labelSize = [lyricLabel.text sizeWithFont:[UIFont systemFontOfSize:12] andLineSpacing:3 maxSize:CGSizeMake(ScreenWidth - 20, 60)];
    lyricLabel.frame = CGRectMake(10, 40, labelSize.width, labelSize.height);
    labelBackView.frame = CGRectMake(0, CGRectGetMaxY(lyricLabel.frame) + 10, ScreenWidth, 70);
    self.lyricLabelMaxY = CGRectGetMaxY(labelBackView.frame) + 10;
}


- (void)layoutSubviews {
    
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(0);
        
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
        make.size.mas_equalTo(CGSizeMake(5, 20));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(sectionView);
        
        make.left.equalTo(sectionView.mas_right).offset(5);
        
    }];
    
//    [lyricLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(titleLabel.mas_left).offset(0);
//        
//        make.top.equalTo(sectionView.mas_bottom).offset(10);
//        
//        make.right.equalTo(self.contentView.mas_right).offset(-10);
//        
//        make.height.mas_offset(50);
//        
//    }];
    
//    [labelBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.right.equalTo(self.contentView);
//        
//        make.top.equalTo(lyricLabel.mas_bottom).offset(10);
//        
//        make.height.mas_offset(70);
//        
//    }];
    
    [demandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.top.equalTo(labelBackView.mas_top).offset(10);
        
        make.height.mas_offset(50);
        
    }];
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
