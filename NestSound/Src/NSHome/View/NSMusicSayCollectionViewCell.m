//
//  NSMusicSayCollectionViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicSayCollectionViewCell.h"

@interface NSMusicSayCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

//类型Label
@property (nonatomic, strong) UILabel *typeLabel;

//歌名Label
@property (nonatomic, strong) UILabel *songNameLabel;

//描述Label
@property (nonatomic, strong) UILabel *describeLabel;

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
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.imageView];
    
    self.imageView.image = [UIImage imageNamed:@"img_03"];
    
    //描述Label
    self.describeLabel = [[UILabel alloc] init];
    
    self.describeLabel.font = [UIFont boldSystemFontOfSize:12];
    
    self.describeLabel.textColor = [UIColor whiteColor];
    self.describeLabel.shadowColor = [UIColor blackColor];
    self.describeLabel.text = @"哈哈哈哈! 啥也不告诉你!!!";
    [self.imageView addSubview:self.describeLabel];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
    }];
    
    
    //类型Label
    self.typeLabel = [[UILabel alloc] init];
    
    self.typeLabel.font = [UIFont boldSystemFontOfSize:16];
    self.typeLabel.textColor = [UIColor whiteColor];
     self.typeLabel.text = @"我写我的歌·";
    self.typeLabel.shadowColor = [UIColor blackColor];
    self.typeLabel.shadowOffset =CGSizeMake(0.1 , 0.1);
    [self.imageView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        
        make.bottom.equalTo(self.describeLabel.mas_top).offset(-10);
        
    }];
    
    
    //歌名Label
    self.songNameLabel = [[UILabel alloc] init];
    
    self.songNameLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.songNameLabel.textColor = [UIColor whiteColor];
     self.songNameLabel.text = @"<<老张的歌>>";
    self.songNameLabel.shadowColor = [UIColor blackColor];
    self.songNameLabel.shadowOffset = CGSizeMake(0.1, 0.1);
    [self.imageView addSubview:self.songNameLabel];
    
    [self.songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.typeLabel.mas_right).offset(15);
        
        make.bottom.equalTo(self.describeLabel.mas_top).offset(-10);
        
    }];
    
}


@end







