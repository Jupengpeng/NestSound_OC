//
//  NSSongMenuCollectionViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongMenuCollectionViewCell.h"
#import "NSIndexModel.h"
#import "NSSingListModel.h"
@interface NSSongMenuCollectionViewCell ()

{
    UIImageView *imageView;
    UILabel * songListName;

}
@end

@implementation NSSongMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    
    songListName = [[UILabel alloc] init];
    songListName.textColor = [UIColor blackColor];
    songListName.textAlignment = NSTextAlignmentLeft;
    songListName.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:songListName];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //constraints
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(111);
    }];
    
    [songListName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(imageView.mas_bottom).offset(8);
        //make.bottom.equalTo(self.contentView.mas_bottom).offset(5);
    }];
}

#pragma mark -setter & getter
-(void)setRecommendSong:(NSRecommendSong *)recommendSong
{
    _recommendSong = recommendSong;
    [imageView setDDImageWithURLString:recommendSong.titleImageURl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    songListName.text = recommendSong.title;
    
}

-(void)setSingList:(singListModel *)singList
{
    [imageView setDDImageWithURLString:singList.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
}

@end












