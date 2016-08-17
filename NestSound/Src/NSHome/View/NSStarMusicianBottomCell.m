//
//  NSStarMusicianBottomCell.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSStarMusicianBottomCell.h"
#import "NSStarMusicianModel.h"

@interface NSStarMusicianBottomCell ()

@property (nonatomic,strong) UIButton *coverButton;

@end

@implementation NSStarMusicianBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


-(void)setMusicianModel:(NSStarMusicianModel *)musicianModel{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
