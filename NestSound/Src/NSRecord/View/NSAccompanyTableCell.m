//
//  NSAccompanyTableCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccompanyTableCell.h"
#import "NSAccommpanyListModel.h"
@interface NSAccompanyTableCell ()
{
    UIImageView * titlePage;
    UILabel * authorNameLabel;
    UILabel * workNameLabel;
    UIButton * playBtn;
}
@end


@implementation NSAccompanyTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        [self configureUIAppearance];

    }
    
    return self;
}

#pragma mark - configureUIAppearance
-(void)configureUIAppearance
{

    self.contentView.backgroundColor = [UIColor hexColorFloat:@"f0f0f0"];
    self.contentView.layer.cornerRadius = 10;
    
    //titlePage
    titlePage = [[UIImageView alloc] init];
    [self.contentView addSubview:titlePage];
    
//    //playbtn
//    playBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
//                
//    } action:^(UIButton *btn) {
//        
//    }];
    [self.contentView addSubview:playBtn];
    
    //workNameLabel
    workNameLabel = [[UILabel alloc] init];
    workNameLabel.font = [UIFont systemFontOfSize:15];
    workNameLabel.textColor = [UIColor hexColorFloat:@"181818"];
    [self.contentView addSubview:workNameLabel];

    //authorNameLabel
    authorNameLabel = [[UILabel alloc] init];
    authorNameLabel.font = [UIFont systemFontOfSize:11];
    authorNameLabel.textColor = [UIColor hexColorFloat:@"666666"];
    [self.contentView addSubview:authorNameLabel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //constraints
    
    [titlePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(70);
    }];
    
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titlePage.mas_centerX);
        make.centerY.equalTo(titlePage.mas_centerY);
        make.height.width.mas_equalTo(40);
    }];
    
    [workNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlePage.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.height.mas_equalTo(15);
    }];
    
    [authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workNameLabel.mas_left);
        make.top.equalTo(workNameLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.height.mas_equalTo(11);
        
    }];

}

-(void)setAccompanyModel:(NSAccommpanyModel *)accompanyModel
{
    _accompanyModel = accompanyModel;
    
    workNameLabel.text = _accompanyModel.title;
    authorNameLabel.text = _accompanyModel.author;
#warning titlePage placeHolderImage
    [titlePage setDDImageWithURLString:_accompanyModel.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_accompany_highlighted"]];
}

@end
