//
//  NSRecommendCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/4/29.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRecommendCell.h"

@interface NSRecommendCell ()
{
    UILabel * workNameLab;
    
    UILabel * authorNameLab;
    
    UIImageView * titlePage;
    
    UIImageView * playCountBk;
    
    UIImageView * listenImage;
    
    UILabel * playCountLab;
}
@end


@implementation NSRecommendCell


-(instancetype)init:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    

        [self configureUIApperance];

    }
    return self;
}


-(void)configureUIApperance
{
    
    //titlePage
    titlePage = [[UIImageView alloc] init];
    [self.contentView addSubview:titlePage];
    
    playCountBk = [[UIImageView alloc] init];
    [titlePage addSubview:playCountBk];
    
    //listen
    listenImage = [[UIImageView alloc] init];
    [playCountBk addSubview:listenImage];
    listenImage.backgroundColor = [UIColor blackColor];
    
    
    //playCountLab
    playCountLab = [[UILabel alloc] init];
    playCountLab.font = [UIFont systemFontOfSize:9];
    playCountLab.textColor = [UIColor hexColorFloat:@"ffffff"];
    [playCountBk addSubview:playCountLab];
    
    
    //workNameLab
    workNameLab = [[UILabel alloc] init];
    workNameLab.font = [UIFont systemFontOfSize:13];
    workNameLab.textColor = [UIColor hexColorFloat:@"181818"];
    [self.contentView addSubview:workNameLab];
    
    
    //authorNameLab
    authorNameLab = [[UILabel alloc] init];
    authorNameLab.font = [UIFont systemFontOfSize:11];
    authorNameLab.textColor = [UIColor hexColorFloat:@"999999"];
    [self.contentView addSubview:authorNameLab];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //constraints
    [titlePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-45);
    }];
    
    [playCountBk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(titlePage);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(48);
        
    }];
    
    [listenImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playCountBk.mas_centerY);
        make.left.equalTo(playCountBk.mas_left).with.offset(9);
        
    }];
    
    [playCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playCountBk.mas_centerY);
        make.left.equalTo(listenImage.mas_right).with.offset(4);
        make.right.equalTo(playCountBk);
    }];
    
    
    
    [workNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlePage.mas_bottom).with.offset(8);
        make.left.equalTo(self.contentView.mas_left).with.offset(7);
        make.right.equalTo(self.contentView.mas_right).with.offset(7);
    }];

    [authorNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workNameLab.mas_bottom).with.offset(4);
        make.left.right.equalTo(workNameLab);
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
    authorNameLab.text = _authorName;
}

-(void)setPlayCount:(NSString *)playCount
{
    _playCount = playCount;
    playCountLab.text = _playCount;
}

-(void)setImgeUrl:(NSString *)imgeUrl
{
    _imgeUrl = imgeUrl;
//    [titlePage setDDImageWithURLString:_imgeUrl];
    [titlePage setImage:[UIImage imageNamed:@"img_03"]];
}

-(void)setType:(NSString *)type
{
    _type = type;
    if ([_type isEqualToString:@"1"]) {
        [listenImage setImage:[UIImage imageNamed:@"1.3_writeWords_lyricsWarehouse"]];
    }else{
        [listenImage setImage:[UIImage imageNamed:@"1.3_writeWords_rhyming"]];
    }
}

@end
