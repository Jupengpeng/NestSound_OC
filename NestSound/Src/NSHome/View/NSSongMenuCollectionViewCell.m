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
    imageView.image = [UIImage imageNamed:@"img_02"];
    [self.contentView addSubview:imageView];
    
}

#pragma mark -setter & getter
-(void)setRecommendSong:(NSRecommendSong *)recommendSong
{
    
    [imageView setDDImageWithURLString:recommendSong.titleImageURl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    
}

-(void)setSingList:(singListModel *)singList
{
    [imageView setDDImageWithURLString:singList.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_addPicture"]];
}

@end












