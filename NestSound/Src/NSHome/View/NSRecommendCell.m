//
//  NSRecommendCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/4/29.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRecommendCell.h"
#import "NSIndexModel.h"
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


-(instancetype)initWithFrame:(CGRect)frame
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
    [titlePage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    titlePage.contentMode =  UIViewContentModeScaleAspectFill;
    titlePage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    titlePage.clipsToBounds  = YES;
    [self.contentView addSubview:titlePage];
    
    playCountBk = [[UIImageView alloc] init];
    playCountBk.image = [UIImage imageNamed:@"2.0_listenCountBKIcon"];
    [titlePage addSubview:playCountBk];
    
    //listen
    listenImage = [[UIImageView alloc] init];
    [playCountBk addSubview:listenImage];
  
    
    
    //playCountLab
    playCountLab = [[UILabel alloc] init];
    playCountLab.font = [UIFont systemFontOfSize:9];
    playCountLab.textAlignment = NSTextAlignmentLeft;
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
        make.right.equalTo(self.contentView.mas_right).with.offset(-7);
    }];

    [authorNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workNameLab.mas_bottom).with.offset(4);
        make.left.right.equalTo(workNameLab);
    }];
    
}


#pragma mark setter & getter

-(void)setRecommend:(NSMusicModel *)recommend
{

    _recommend = recommend;
    workNameLab.text = _recommend.workName;

    authorNameLab.text = _recommend.authorName;
    if (_recommend.playCount > 9999) {
        double count = (double)_recommend.playCount/10000.0;
        CHLog(@"%f",count);
        playCountLab.text = [NSString stringWithFormat:@"%.1f万",count];
    }else{
        playCountLab.text = [NSString stringWithFormat:@"%d",_recommend.playCount];
    }

    [titlePage setDDImageWithURLString:_recommend.titlePageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];

    if (recommend.type == 1) {
        [listenImage setImage:[UIImage imageNamed:@"2.0_listenIcon"]];
    }else{
        [listenImage setImage:[UIImage imageNamed:@"2.0_lyricIcon"]];
    }
    
}


-(void)setSongNew:(NSNew *)songNew
{
    _songNew = songNew;
    workNameLab.text = _songNew.workName;
    
    authorNameLab.text = _songNew.authorName;
    
    
    if (_songNew.playCount > 9999) {
        float count = _songNew.playCount/10000;
        playCountLab.text = [NSString stringWithFormat:@"%.1f万",count];
    }else{
        playCountLab.text = [NSString stringWithFormat:@"%d",_songNew.playCount];
    }
    
    if (_songNew.type == 1) {
        [listenImage setImage:[UIImage imageNamed:@"2.0_listenIcon"]];
    }else{
        [listenImage setImage:[UIImage imageNamed:@"2.0_lyricIcon"]];
    }
    
    [titlePage setDDImageWithURLString:_songNew.titlePageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    
    
}
-(void)setIsMusic:(BOOL)isMusic
{
    _isMusic = isMusic;
    if (_isMusic) {
         [listenImage setImage:[UIImage imageNamed:@"2.0_listenIcon"]];
    }
}

@end
