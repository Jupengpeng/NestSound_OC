//
//  NSAccompanyListHeaderView.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccompanyListHeaderView.h"

@interface NSAccompanyListHeaderView ()
{
    UIImageView * titilePage;
    UIView * line;

}
@end


@implementation NSAccompanyListHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self) {
        [self configureUIAppearance];
    }
    return self;
}
#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    //titlePage
    titilePage = [[UIImageView alloc] init];
    titilePage.layer.cornerRadius = 10;
    [titilePage setDDImageWithURLString:@"http://pic.yinchao.cn/noAccomy20160707134021.png" placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    titilePage.userInteractionEnabled = YES;
    [self addSubview:titilePage];
    
    //singBtn
    self.singBtn = [[UIButton alloc] init];
    
    [titilePage addSubview:self.singBtn];
    
    //line
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor blackColor];
    [self addSubview:line];
    
    //hotbBtn
    _hotBtn= [[UIButton alloc] init];
    self.hotBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.hotBtn setFont:[UIFont systemFontOfSize:16]];
    [self.hotBtn setTitle:@"最热" forState:UIControlStateNormal];
//    [self.hotBtn setTitle:LocalizedStr(@"promot_hot") forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:[UIColor hexColorFloat:@"333333"] forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:[UIColor hexColorFloat:@"ffce00"] forState:UIControlStateSelected];
    [self addSubview:self.hotBtn];
    
    
    //newBtn
    _xinBtn = [[UIButton alloc] init];
    self.xinBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.xinBtn setTitle:@"最新" forState:UIControlStateNormal];
//    [self.xinBtn setTitle:LocalizedStr(@"promot_new") forState:UIControlStateNormal];
    [self.xinBtn setTitleColor:[UIColor hexColorFloat:@"333333"] forState:UIControlStateNormal];
    [self.xinBtn setTitleColor:[UIColor hexColorFloat:@"ffce00"] forState:UIControlStateSelected];
    [self addSubview:self.xinBtn];
    

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //constraints
    [titilePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(140);
    }];
    
    //self.singBtn
    [self.singBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(titilePage);
    }];
    
    [self.hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(titilePage.mas_bottom).with.offset(10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(35);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hotBtn.mas_centerY);
        make.left.equalTo(self.hotBtn.mas_right).with.offset(5);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(14);
    }];
    
    
    [self.xinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line.mas_centerY);
        make.left.equalTo(line.mas_right).with.offset(5);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(35);
    }];
}


@end
