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
    UIImageView * line;

}
@end


@implementation NSAccompanyListHeaderView

-(instancetype)init
{
    self = [super init];
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
    [self addSubview:titilePage];
    
    //line
    line = [[UIImageView alloc] init];
    line.backgroundColor = [UIColor blackColor];
    [self addSubview:line];
    
    //hotbBtn
    _hotBtn= [[UIButton alloc] init];
    [self.hotBtn setTitle:LocalizedStr(@"promot_hot") forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:[UIColor hexColorFloat:@"333333"] forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:[UIColor hexColorFloat:@"ffce00"] forState:UIControlStateSelected];
    [self addSubview:self.hotBtn];
    
    
    //newBtn
    _xinBtn = [[UIButton alloc] init];
    [self.xinBtn setTitle:LocalizedStr(@"promot_new") forState:UIControlStateNormal];
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
    
    [self.hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(titilePage.mas_top).with.offset(10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(32);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hotBtn.mas_centerX);
        make.left.equalTo(self.hotBtn.mas_right).with.offset(10);
        make.width.mas_equalTo(3);
    }];
    
    
    [self.xinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(line.mas_centerX);
        make.left.equalTo(line.mas_right).with.offset(10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(32);
    }];
}


@end
