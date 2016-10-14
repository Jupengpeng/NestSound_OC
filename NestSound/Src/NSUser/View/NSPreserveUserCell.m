//
//  NSPreserveUserCell.m
//  NestSound
//
//  Created by yintao on 16/9/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveUserCell.h"
#import "NSPreserveApplyModel.h"

@interface NSPreserveUserCell ()

@property (nonatomic,strong) UILabel *nameLaebl;
@property (nonatomic,strong) UILabel *identifierLabel;
@property (nonatomic,strong) UILabel *phoneLabel;

@end

@implementation NSPreserveUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (NSInteger i = 1; i < 3; i ++) {
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 45*i, ScreenWidth - 10, 0.5)];
            line.backgroundColor = [UIColor hexColorFloat:@"f3f2f3"];
            [self addSubview:line];
        }
        
        NSArray *titleArr = @[@"姓名",@"身份证",@"手机号"];
        
        for (NSInteger i = 0; i < 3; i ++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 17 + 45*i, 60, 14)];
            titleLabel.text = titleArr[i];
            titleLabel.textColor = [UIColor hexColorFloat:@"323232"];
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [self addSubview:titleLabel];
        }
        
        self.nameLaebl = [[UILabel alloc] initWithFrame:CGRectMake(73, 17, ScreenWidth - 73, 14.0f)];
        self.nameLaebl.textColor = [UIColor hexColorFloat:@"646464"];
        self.nameLaebl.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.nameLaebl];
        
        self.identifierLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 17 + 45, ScreenWidth - 73, 14.0f)];
        self.identifierLabel.textColor = [UIColor hexColorFloat:@"646464"];
        self.identifierLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.identifierLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 17 + 90, ScreenWidth - 73, 14.0f)];
        self.phoneLabel.textColor = [UIColor hexColorFloat:@"646464"];
        self.phoneLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.phoneLabel];
        
        
    }
    return self;
}

- (void)setPersonModel:(NSPreservePersonInfoModel *)personModel{
    _personModel = personModel;
    self.nameLaebl.text =personModel.cUserName;
    self.identifierLabel.text = personModel.cCardId;
    self.phoneLabel.text = personModel.cPhone;
}

- (void)setupData{
    self.nameLaebl.text = @"Json Mraz";
    self.identifierLabel.text = @"321283111111111111";
    self.phoneLabel.text = @"1888888888";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
