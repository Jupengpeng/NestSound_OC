//
//  NSStarMusicianListCell.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSStarMusicianListCell.h"
#import "NSTool.h"
#import "NSBiaoqianView.h"
#import "NSMusicianListModel.h"

@interface NSStarMusicianListCell ()

@property (nonatomic,strong) UIImageView *headerImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) NSBiaoqianView *tag1View;

@property (nonatomic,strong) NSBiaoqianView *tag2View;

//@property (nonatomic,strong) UIButton *tag1Button;
//@property (nonatomic,strong) UIButton *tag2button;

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
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
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
    

    self.tag1View = [[NSBiaoqianView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.tag1View];
    
    self.tag2View = [[NSBiaoqianView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.tag2View];
}

- (void)setMusicianModel:(NSMusicianListDetailModel *)musicianModel{

    _musicianModel = musicianModel;
    
    self.nameLabel.text = musicianModel.name;
    [self.headerImageView setDDImageWithURLString:musicianModel.pic placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    NSArray *tagArray = [NSTool getTagsFromTagString:musicianModel.ability];
    self.tag1View.hidden = NO;
    self.tag2View.hidden = NO;
    switch (tagArray.count) {

        case 0:
        {
            self.tag1View.hidden = YES;
            self.tag2View.hidden = YES;
        }
            break;
        case 1:
        {
            self.tag1View.title = tagArray[0];
            self.tag2View.hidden = YES;
        }
            break;
        case 2:
        {
            self.tag2View.title = tagArray[0];
            self.tag1View.title = tagArray[1];
        }
            break;

            
        default:
        {
            self.tag1View.title = @"全能";
            self.tag2View.hidden = YES;
        }
            break;
    }
    
    self.tag1View.x = ScreenWidth - 10 - self.tag1View.width;
    self.tag2View.x = CGRectGetMinX(self.tag1View.frame) - self.tag2View.width - 5;
    self.tag1View.centerY = 45;
    self.tag2View.centerY = 45;
    
}

- (void)updateUIWithData{
    
    
    self.nameLabel.text = @"陈医生";

    [self.headerImageView setDDImageWithURLString:@"" placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    
    NSString *tag1Str= @"编曲";

    self.tag1View.title = tag1Str;
    self.tag1View.x = ScreenWidth - 10 - self.tag1View.width;

    
    NSString *tag2Str = @"玛德智障";
    self.tag2View.title = tag2Str;
    self.tag2View.x = CGRectGetMinX(self.tag1View.frame) - self.tag2View.width - 5;

    self.tag1View.centerY = 45;
    self.tag2View.centerY = 45;
    
}

- (UIImage *)setupBGImageStretchWithImage:(UIImage *)bgImage {
    // 设置端盖的值
    CGFloat top = bgImage.size.height * 0.5 - 1;
    CGFloat left = bgImage.size.width * 0.5 - 1;
    CGFloat bottom = bgImage.size.height * 0.5;
    CGFloat right = bgImage.size.width * 0.5;
    
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    
    // 拉伸图片
    UIImage *newImage = [bgImage resizableImageWithCapInsets:edgeInsets resizingMode:mode];

        // 设置按钮的背景图片

    return newImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
