//
//  NSStarMusicianListCell.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSStarMusicianListCell.h"
#import "NSTool.h"

@interface NSStarMusicianListCell ()

@property (nonatomic,strong) UIImageView *headerImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIButton *tag1Button;
@property (nonatomic,strong) UIButton *tag2button;

@end

@implementation NSStarMusicianListCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        [self initUI];
        
    }
    
    return self;
}

- (void)initUI{
    
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = 30.0f;
    
    
    [self addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textColor = [UIColor hexColorFloat:@"a4a4a4"];
    self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.headerImageView.mas_right).offset(18);
        make.height.mas_equalTo(11.0f);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.tag1Button = [UIButton  buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
       
        btn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);

    } action:^(UIButton *btn) {
        
    }];
    
    [self addSubview:self.tag1Button];
    self.tag1Button.height = 11.0f;
    self.tag1Button.centerY = 45;

    
    
    self.tag2button = [UIButton  buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        btn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    } action:^(UIButton *btn) {
        
    }];
    
    [self addSubview:self.tag2button];
    self.tag2button.height = 11.0f;
    self.tag2button.centerY = 45;

    
}

- (void)updateUIWithData{
    
    
    self.nameLabel.text = @"陈医生";

    [self.headerImageView setDDImageWithURLString:@"" placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    
    NSString *tag1Str= @"编曲";

    [self.tag1Button setTitle:tag1Str forState:UIControlStateNormal];
    self.tag1Button.width = [NSTool getWidthWithContent:tag1Str font:[UIFont systemFontOfSize:10.0f]]  + 12;
    self.tag1Button.x = ScreenWidth - 10 - self.tag1Button.width;
    [self.tag1Button setBackgroundImage:[self setupBGImageStretchWithImage:[UIImage imageNamed:@"biaoqian"]] forState:UIControlStateNormal];

    
    NSString *tag2Str = @"玛德智障";
    [self.tag2button setTitle:tag2Str forState:UIControlStateNormal];

    self.tag2button.width = [NSTool getWidthWithContent:tag2Str font:[UIFont systemFontOfSize:10.0f] ] + 12 ;
    self.tag2button.x = CGRectGetMinX(self.tag1Button.frame) - self.tag2button.width - 5;
    

    [self.tag2button setBackgroundImage:[self setupBGImageStretchWithImage:[UIImage imageNamed:@"biaoqian"]] forState:UIControlStateNormal];

    
}

- (UIImage *)setupBGImageStretchWithImage:(UIImage *)bgImage {
    // 设置端盖的值
    CGFloat top = bgImage.size.height * 0.5;
    CGFloat left = bgImage.size.width * 0.5;
    CGFloat bottom = bgImage.size.height * 0.5;
    CGFloat right = bgImage.size.width * 0.5;
    
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    
    // 拉伸图片
    UIImage *newImage = [bgImage resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    
//    // 设置按钮的背景图片
//    [btn setBackgroundImage:newImage forState:UIControlStateNormal];
    return newImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
