//
//  NSSongMenuCollectionViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongMenuCollectionViewCell.h"

@interface NSSongMenuCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

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
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    self.imageView.image = [UIImage imageNamed:@"img_02"];
    
    [self addSubview:self.imageView];
    
}



@end












