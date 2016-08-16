//
//  NSMusicSayCollectionViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicSayCollectionViewCell.h"
#import "NSIndexModel.h"
@interface NSMusicSayCollectionViewCell ()
{
    
    UIImageView *imageView;

//类型Label
    UILabel *typeLabel;

//歌名Label
    UILabel *songNameLabel;

//描述Label
    UILabel *describeLabel;
}
@end

@implementation NSMusicSayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [self addSubview:imageView];
    
    imageView.image = [UIImage imageNamed:@"img_03"];
    
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds  = YES;
    //描述Label
    describeLabel = [[UILabel alloc] init];
    
    describeLabel.font = [UIFont boldSystemFontOfSize:12];
    
    describeLabel.textColor = [UIColor whiteColor];
    describeLabel.shadowColor = [UIColor blackColor];
   
    [imageView addSubview:describeLabel];
    
    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
    }];
    
    
    //类型Label
    typeLabel = [[UILabel alloc] init];
    
    typeLabel.font = [UIFont boldSystemFontOfSize:16];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.shadowColor = [UIColor blackColor];
    typeLabel.shadowOffset =CGSizeMake(0.1 , 0.1);
    [imageView addSubview:typeLabel];
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        
        make.bottom.equalTo(describeLabel.mas_top).offset(-10);
        
    }];
    
    
    //歌名Label
    songNameLabel = [[UILabel alloc] init];
    
    songNameLabel.font = [UIFont boldSystemFontOfSize:14];
    
    songNameLabel.textColor = [UIColor whiteColor];
        songNameLabel.shadowColor = [UIColor blackColor];
    songNameLabel.shadowOffset = CGSizeMake(0.1, 0.1);
    [imageView addSubview:songNameLabel];
    
    [songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(typeLabel.mas_right).offset(15);
        
        make.bottom.equalTo(describeLabel.mas_top).offset(-10);
        
    }];
    
}


#pragma mark -setter &&getter
-(void)setMusicSay:(NSMusicSay *)musicSay
{
    [imageView setDDImageWithURLString:musicSay.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
//    describeLabel.text = musicSay.detail;
//    songNameLabel.text = musicSay.workName;
    
}

- (void)setPicUrlStr:(NSString *)picUrlStr{
    
    imageView.image = [UIImage imageNamed:@"MusicDesign"];
    
//    [imageView setDDImageWithURLString:picUrlStr placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    
    
}

@end







