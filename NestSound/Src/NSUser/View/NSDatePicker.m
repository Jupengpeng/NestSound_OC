//
//  NSDatePicker.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDatePicker.h"

@interface NSDatePicker ()
{
    UIView * viewBk;
    UIView * bar;
}
@end

@implementation NSDatePicker


-(instancetype)init
{
    if (self = [super init]) {
        [self configureUIAppearance];
    }
    return self;
}


-(void)configureUIAppearance
{
    viewBk = [[UIView alloc] init];
    viewBk.backgroundColor = [UIColor blackColor];
    viewBk.alpha = 0.5;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewHiden)];
    [viewBk addGestureRecognizer:tap];
    
    [self addSubview:viewBk];
    
    bar = [[UIView alloc] init];
    bar.backgroundColor = [UIColor whiteColor];
    [self addSubview:bar];
    
    
    _choseBtn = [[UIButton alloc] init];
    [_choseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_choseBtn setTitle:@"确认" forState:UIControlStateNormal];
    [bar addSubview:_choseBtn];
    
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [bar addSubview:_cancelBtn];
    
    
    _choseBirthday = [[UIDatePicker alloc] init];
    [_choseBirthday setDatePickerMode:UIDatePickerModeDate];
    [bar addSubview:_choseBirthday];
    
}


-(void)layoutSubviews
{
    //constraints
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(250);
    }];
    
    [viewBk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(bar.mas_top);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bar.mas_top).with.offset(10);
        make.left.equalTo(bar.mas_left).with.offset(15);
        make.height.mas_equalTo(15);
        
    }];
    
    [_choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bar.mas_top).with.offset(10);
        make.right.equalTo(bar.mas_right).with.offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    [_choseBirthday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bar.mas_left);
        make.right.equalTo(bar.mas_right);
        make.bottom.equalTo(bar.mas_bottom);
        make.top.equalTo(_choseBtn.mas_bottom).with.offset(10);
    }];
    
}

-(void)viewHiden
{
    self.hidden = YES;
}
@end
