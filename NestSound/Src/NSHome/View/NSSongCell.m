//
//  NSSongCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongCell.h"

@interface NSSongCell (){

    UILabel * numberLab;
    UILabel * workNameLab;
    UILabel * aurthorLab;

}

@end


@implementation NSSongCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //configure UI
        self.backgroundColor = [UIColor whiteColor];
        
        //listNumber
        numberLab = [[UILabel alloc] init];
        numberLab.font = [UIFont systemFontOfSize:12];
        numberLab.textColor = [UIColor hexColorFloat:@"666666"];
        [self.contentView addSubview:numberLab];
        
        //worknameLab
        workNameLab  = [[UILabel alloc] init];
        workNameLab.font = [UIFont systemFontOfSize:14];
        workNameLab.textColor = [UIColor hexColorFloat:@"181818"];
        [self.contentView addSubview:workNameLab];
        
        //aurthorLab
        aurthorLab = [[UILabel alloc] init];
        aurthorLab.font = [UIFont systemFontOfSize:10];
        aurthorLab.textColor = [UIColor hexColorFloat:@"666666"];
        [self.contentView addSubview:aurthorLab];
        
        
       
    }

    return self;
}

-(void)layoutSubviews
{

    //constrains
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerX);
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
    }];
    
    [workNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLab.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(14);
    }];
    
    [aurthorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workNameLab.mas_left);
        make.top.equalTo(workNameLab.mas_bottom).with.offset(5);
        make.height.mas_equalTo(10);
    }];

}

#pragma mark setter & getter

-(void)setWorkName:(NSString *)workName
{
    _workName = workName;
    workNameLab.text = _workName;

}

-(void)setAuthorName:(NSString *)authorName
{
    _authorName = authorName;
    aurthorLab.text = _authorName;

}

-(void)setNumber:(NSString *)number
{
    _number = number;
    numberLab.text = _number;

}

@end
