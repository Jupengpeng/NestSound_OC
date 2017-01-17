//
//  NSCacheProductCell.m
//  NestSound
//
//  Created by yinchao on 2016/11/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCacheProductCell.h"
#import "NSAccommpanyListModel.h"
@interface NSCacheProductCell ()
{
    UILabel *titleLabel;
    UILabel *dateLabel;
    UIButton *uploadBtn;
}
@end

@implementation NSCacheProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupCacheProductCellUI];
    }
    return self;
}
- (void)setupCacheProductCellUI {
    
    //标题
    titleLabel = [[UILabel alloc] init];
    
//    titleLabel.text = @"为你钟情";
    
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        
        make.top.equalTo(self.mas_top).offset(10);
        
    }];
    //时间
    dateLabel = [[UILabel alloc] init];
    
    dateLabel.font = [UIFont systemFontOfSize:10];
    
    dateLabel.textColor = [UIColor hexColorFloat:@"bababa"];
    
    dateLabel.textAlignment = NSTextAlignmentRight;
    
//    dateLabel.text = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    [self.contentView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
//        make.width.mas_equalTo(ScreenWidth/2);
        
    }];
    
    //上传
    uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    uploadBtn.layer.cornerRadius = 3;
    
    uploadBtn.layer.masksToBounds= YES;
    
    self.playBtn = uploadBtn;
    
    [self.contentView addSubview:uploadBtn];
    
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-10);
        
        make.centerY.equalTo(self.mas_centerY);
        
        make.size.mas_offset(CGSizeMake(50, 24));
        
    }];
    
    
}
- (void)setAccompanyModel:(NSAccommpanyModel *)accompanyModel {
    _accompanyModel = accompanyModel;
    titleLabel.text = accompanyModel.title;
    [self.playBtn setImage:[UIImage imageNamed:@"2.3.6_accompanyPlay"] forState:UIControlStateNormal];
    
    [self.playBtn setImage:[UIImage imageNamed:@"2.3.6_accompanyPause"] forState:UIControlStateSelected];
}
- (void)setupCacheLyricProductWithDictionary:(NSDictionary *)dic {
    titleLabel.text = dic[@"lyricName"];
    dateLabel.text = [NSString stringWithFormat:@"%@",dic[@"currentTime"]];
    [self.playBtn setTitle:@"上传" forState:UIControlStateNormal];
    self.playBtn.layer.borderWidth = 0.6;
    self.playBtn.layer.borderColor = [[UIColor hexColorFloat:@"ffd705"] CGColor];
    [self.playBtn setTitleColor:[UIColor hexColorFloat:@"ffd705"] forState:UIControlStateNormal];
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
