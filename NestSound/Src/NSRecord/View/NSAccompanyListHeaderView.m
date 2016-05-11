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
    UIButton * hotBtn;
    UIButton * newBtn;
}
@end


@implementation NSAccompanyListHeaderView

-(instancetype)init
{
    self = [super init];
    if (self) {
        
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
    [self addSubview:line];
    
    //hotbBtn
    hotBtn = [[UIButton alloc] init];
    [hotBtn setTitle:LocalizedStr(@"promot_hot") forState:UIControlStateNormal];
    [self addSubview:hotBtn];
    
    
    //newBtn
    newBtn = [[UIButton alloc] init];
    [newBtn setTitle:LocalizedStr(@"promot_new") forState:UIControlStateNormal];
    [self addSubview:newBtn];
    

}

-(void)layoutSubviews
{
    //constraints
    [titilePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.right.equalTo(self);
    }];
    
    [hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(titilePage.mas_top).with.offset(10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(32);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(hotBtn.mas_centerX);
        make.left.equalTo(hotBtn.mas_right).with.offset(10);
        make.width.mas_equalTo(3);
    }];
    
    
    [newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(line.mas_centerX);
        make.left.equalTo(line.mas_right).with.offset(10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(32);
    }];
}
@end
