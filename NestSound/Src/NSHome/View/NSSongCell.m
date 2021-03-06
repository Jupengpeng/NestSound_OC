//
//  NSSongCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongCell.h"
#import "NSSongListModel.h"
@interface NSSongCell (){

    
    UILabel * workNameLab;
    UILabel * aurthorLab;
    
}

@end


@implementation NSSongCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //configure UI
//        self.backgroundColor = [UIColor whiteColor];
        
        //listNumber
        self.numberLab = [[UILabel alloc] init];
        _numberLab.font = [UIFont systemFontOfSize:12];
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.textColor = [UIColor hexColorFloat:@"666666"];
        [self.contentView addSubview:_numberLab];
        
        self.playImg = [[UIImageView alloc] init];
        _playImg.hidden = YES;
        _playImg.image = [UIImage imageNamed:@"2.0_trumpet"];
        [self.contentView addSubview:_playImg];
        
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
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.width.mas_offset(20);
    }];
    
    [self.playImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.size.mas_equalTo(15);
    }];
    
    [workNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numberLab.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.height.mas_equalTo(14);
    }];
    
    [aurthorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workNameLab.mas_left);
        make.top.equalTo(workNameLab.mas_bottom).with.offset(5);
        make.height.mas_equalTo(10);
    }];

}

#pragma mark setter & getter

-(void)setNumber:(NSInteger) number
{
    _number = number;
    _numberLab.text = [NSString stringWithFormat:@"%ld",(long)_number];
}

-(void)setSongModel:(songModel *)songModel
{
 
    _songModel = songModel;
    
    workNameLab.text = _songModel.workName;

    aurthorLab.text = _songModel.author;

}

@end
