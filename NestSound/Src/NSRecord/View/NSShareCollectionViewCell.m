//
//  NSShareCollectionViewCell.m
//  NestSound
//
//  Created by Apple on 16/6/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSShareCollectionViewCell.h"

@interface NSShareCollectionViewCell ()
{
    UILabel * nameLabel;
    UIImageView * iconImage;
}
@end

@implementation NSShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    
    iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.width)];
    
    
    [self.contentView addSubview:iconImage];
    
    nameLabel = [[UILabel alloc] init];
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    nameLabel.font = [UIFont systemFontOfSize:12];
    
    
    [self.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        
        make.right.equalTo(self.contentView.mas_right);
        
        make.top.equalTo(iconImage.mas_bottom);
        
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];

}


#pragma mark - setter & getter
-(void)setDic:(NSDictionary *)dic
{
    iconImage.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    nameLabel.text = dic[@"name"];
}


@end





