//
//  NSCooperationCollectionTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationCollectionTableViewCell.h"
#import "NSCollectionCooperationListModel.h"
@interface NSCooperationCollectionTableViewCell ()
{
    //头像
    UIImageView *iconImgView;
    //作者名字
    UILabel *authorNameLabel;
    //日期
    UILabel *dateLabel;
    //参与合作人数
    UILabel *joinNum;
    //作品名称
    UILabel * workNameLabel;
    //合作状态
    UILabel * statusLabel;
}
@end


@implementation NSCooperationCollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupCooperationCollectionCellUI];
    }
    return self;
}
- (void)setupCooperationCollectionCellUI {
    
    //头像
    iconImgView = [[UIImageView alloc] init];
    
    iconImgView.image = [UIImage imageNamed:@"2.0_weChat"];
    
    [self.contentView addSubview:iconImgView];
    
    iconImgView.clipsToBounds = YES;
    
    iconImgView.layer.cornerRadius = 20;
    
    //作者名
    authorNameLabel = [[UILabel alloc] init];
    
    authorNameLabel.font = [UIFont systemFontOfSize:14];
    
    authorNameLabel.text = @"疯子";
    
    [self.contentView addSubview:authorNameLabel];
    
    
    //日期
    dateLabel = [[UILabel alloc] init];
    
    dateLabel.font = [UIFont systemFontOfSize:12];
    
    dateLabel.textColor = [UIColor lightGrayColor];
    
    dateLabel.text = @"2016-05-26 20:00";
    
    [self.contentView addSubview:dateLabel];
    
    //参与人数
    joinNum = [[UILabel alloc] init];
    
    joinNum.text = @"23人参与合作";
    
    joinNum.textColor = [UIColor lightGrayColor];
    
    joinNum.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:joinNum];
    
    //作品名称
    workNameLabel = [[UILabel alloc] init];
    
    workNameLabel.text = @"《从你的全世界路过》";
    
    workNameLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:workNameLabel];
    
    //合作状态
    statusLabel = [[UILabel alloc] init];
    
    statusLabel.text = @"对方停止该合作";
    
    statusLabel.font = [UIFont systemFontOfSize:12];
    
    statusLabel.textColor = [UIColor hexColorFloat:@"ffd705"];
    
    [self.contentView addSubview:statusLabel];
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //头像
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
        make.width.mas_equalTo(40);
        
        make.height.mas_equalTo(40);
        
    }];
    
    //作者名
    [authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImgView.mas_right).offset(10);
        
        make.top.equalTo(iconImgView.mas_top);
        
    }];
    
    //日期
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImgView.mas_right).offset(10);
        
        make.bottom.equalTo(iconImgView.mas_bottom);
        
    }];
    
    //参与人数
    [joinNum mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.top.equalTo(authorNameLabel.mas_top).offset(0);
        
    }];
    
    //作品名称
    [workNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(iconImgView.mas_bottom).offset(10);
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
    }];
    
    //合作状态
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.bottom.equalTo(workNameLabel.mas_bottom).offset(0);
        
    }];
}
- (void)setCollectionModel:(CollectionCooperationModel *)collectionModel {
    _collectionModel = collectionModel;
    [iconImgView setDDImageWithURLString:collectionModel.headerUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    authorNameLabel.text = collectionModel.nickName;
    dateLabel.text = [date datetoLongLongStringWithDate:collectionModel.createTime];
    joinNum.text = [NSString stringWithFormat:@"%ld人参与合作",collectionModel.workNum];
    workNameLabel.text = collectionModel.cooperationTitle;
    switch (collectionModel.status) {
        case 1:
            statusLabel.text = @"";
            break;
        case 3:
            statusLabel.text = @"对方停止该合作";
            statusLabel.textColor = [UIColor redColor];
            break;
        case 4:
            statusLabel.text = @"已经到期";
            statusLabel.textColor = [UIColor redColor];
            break;
        case 8:
            statusLabel.text = @"合作成功";
            statusLabel.textColor = [UIColor hexColorFloat:@"ffd705"];
            break;
        default:
            break;
    }
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
