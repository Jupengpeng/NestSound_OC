//
//  NSPreservePayCell.m
//  NestSound
//
//  Created by yintao on 16/9/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreservePayCell.h"

@interface NSPreservePayCell ()

@property (nonatomic,strong) UIImageView *payIconView;

@property (nonatomic,strong) UIButton *chooseButton;

@property (nonatomic,strong) UILabel *payTitleLabel;

@end

@implementation NSPreservePayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.payIconView = [[UIImageView alloc] init];
        self.payIconView.frame = CGRectMake(10, 9, 35, 31);
        [self addSubview:self.payIconView];
        
        self.payTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 18, 60, 14)];
        self.payTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.payTitleLabel.textColor = [UIColor hexColorFloat:@"323232"];
        [self addSubview:self.payTitleLabel];
        
        self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(ScreenWidth - 48, 5, 40, 40);
            [btn setImage:[UIImage imageNamed:@"gouxuan_No"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
            btn.selected = YES;
        } action:^(UIButton *btn) {
          
            if (self.chooseBlock) {
                self.chooseBlock(btn);
            }
            
        }];
        
        [self addSubview:self.chooseButton];
        
        [self setupData];
    }
    return self;
}

- (void)setupData{
    
    self.payIconView.image = [UIImage imageNamed:@"WXPay"];
    self.payTitleLabel.text = @"微信支付";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
