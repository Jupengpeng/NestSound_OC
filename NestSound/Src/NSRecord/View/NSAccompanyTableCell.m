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
    UILabel * useTimeLabel;
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
    [titlePage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    titlePage.contentMode =  UIViewContentModeScaleAspectFill;
    titlePage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    titlePage.clipsToBounds  = YES;
    [self.contentView addSubview:titlePage];
    
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setImage:[UIImage imageNamed:@"2.0_play"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"2.0_suspended"] forState:UIControlStateSelected];
    
    self.btn = btn;
    
    [self.contentView addSubview:btn];
    
//    //playbtn
//    playBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
//                
//    } action:^(UIButton *btn) {
//        
//    }];
    [self.contentView addSubview:playBtn];
    
    //workNameLabel
    workNameLabel = [[UILabel alloc] init];
    workNameLabel.numberOfLines = 0;
    workNameLabel.font = [UIFont systemFontOfSize:15];
    workNameLabel.textColor = [UIColor hexColorFloat:@"181818"];
    [self.contentView addSubview:workNameLabel];

    //authorNameLabel
    authorNameLabel = [[UILabel alloc] init];
    authorNameLabel.font = [UIFont systemFontOfSize:11];
    authorNameLabel.numberOfLines = 0;
    authorNameLabel.textColor = [UIColor hexColorFloat:@"666666"];
    [self.contentView addSubview:authorNameLabel];
    
    //useTimeLabel
    useTimeLabel = [[UILabel alloc] init];
    useTimeLabel.font = [UIFont systemFontOfSize:11];
    useTimeLabel.numberOfLines = 0;
    useTimeLabel.textColor = [UIColor hexColorFloat:@"666666"];
    [self.contentView addSubview:useTimeLabel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //constraints
    
    [titlePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(12*ScreenWidth/25);
    }];
    
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titlePage.mas_centerX);
        make.centerY.equalTo(titlePage.mas_centerY);
        make.height.width.mas_equalTo(40);
        
    }];
    
    [workNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlePage.mas_right).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.bottom.equalTo(authorNameLabel.mas_top).with.offset(-5);
    }];
    
    [authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workNameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.top.equalTo(workNameLabel.mas_bottom).with.offset(5);
        make.bottom.equalTo(useTimeLabel.mas_top).with.offset(-5);
    }];
    [useTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workNameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.top.equalTo(authorNameLabel.mas_bottom).with.offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(titlePage);
        make.right.equalTo(titlePage.mas_right).with.offset(-5);
        make.bottom.equalTo(titlePage.mas_bottom).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];

}

-(void)setAccompanyModel:(NSAccommpanyModel *)accompanyModel
{
    _accompanyModel = accompanyModel;
    
    workNameLabel.text = _accompanyModel.title;
    authorNameLabel.text = [NSString stringWithFormat:@"%@ %@",_accompanyModel.author, [NSTool stringFormatWithTimeLong:_accompanyModel.mp3Times]];
    useTimeLabel.text = [NSString stringWithFormat:@"使用次数:%d",_accompanyModel.useTime];
    [titlePage setDDImageWithURLString:_accompanyModel.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
}

@end
