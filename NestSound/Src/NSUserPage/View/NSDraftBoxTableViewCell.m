//
//  NSDraftBoxTableViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDraftBoxTableViewCell.h"

@interface NSDraftBoxTableViewCell ()

@property (nonatomic, strong) UILabel *songName;

@property (nonatomic, strong) UIImageView *sendFailure;

@property (nonatomic, strong) UILabel *songType;

@property (nonatomic, strong) UILabel *tiemLabel;

@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation NSDraftBoxTableViewCell


- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    
}

@end
