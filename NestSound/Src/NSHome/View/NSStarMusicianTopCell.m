//
//  NSStarMusicianTopCell.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSStarMusicianTopCell.h"
#import "NSStarMusicianModel.h"
#import "NSBiaoqianView.h"
#import "NSTool.h"
@interface NSStarMusicianTopCell ()

@property (nonatomic,strong) UIImageView *headIcon;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *briefLabe;
@property (nonatomic,strong) UILabel *descriptionLabel;

@end


@implementation NSStarMusicianTopCell

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
    
    self.headIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.headIcon.clipsToBounds = YES;
    self.headIcon.layer.cornerRadius = 30.0f;
    [self addSubview:self.headIcon];
    
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.top.equalTo(self.mas_top).offset(15.0f);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIcon.mas_right).offset(25.0f);
        make.top.equalTo(self.mas_top).offset(17);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    self.briefLabe = [[UILabel alloc] initWithFrame:CGRectZero];
    self.briefLabe.font = [UIFont systemFontOfSize:12.0f];
    self.briefLabe.textColor = [UIColor hexColorFloat:@"afafaf"];
    [self addSubview:self.briefLabe];
    [self.briefLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIcon.mas_right).offset(25.0f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
    
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
    self.descriptionLabel.textColor = [UIColor hexColorFloat:@"afafaf"];
    [self addSubview:self.descriptionLabel];
    self.descriptionLabel.numberOfLines = 0;
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.headIcon.mas_bottom).offset(20);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
}



- (void)setMusicianModel:(NSStarMusicianModel *)musicianModel{
    
    [self.headIcon setDDImageWithURLString:@"" placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    
    self.nameLabel.text = @"徐佳莹";
    self.briefLabe.text = @"创作女歌手，音乐人";
    
    
    NSString *contentStr  = @"    2010年发表单曲《空》收录在大石原唱音乐自选集发表作品:电视剧“我的经济适用男“片尾曲放开爱、戚薇电视剧”爱情自有天意“插曲《小小世界》、娄艺潇电视剧”爱的多米诺“片头曲《爱的多米诺》、阿悄戚薇《失窃之物》专辑主打歌《失窃之物》、box专辑《路》收录《双面人》钟纯研、单曲《@所有怀疑我的人》。";
    
    CGFloat contentHeight = [NSTool getHeightWithContent:contentStr width:ScreenWidth - 30 font:[UIFont systemFontOfSize:12] lineOffset:0];
    self.descriptionLabel.text = contentStr;
    
    [self.descriptionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    
    NSArray *bilities = @[@"作词",@"作曲",@"编曲",@"德玛西亚"];
    CGFloat currentOriginX = 100;
    for (NSInteger i = 0 ; i < 4; i ++) {
        NSBiaoqianView *biaoqianView = [[NSBiaoqianView alloc] initWithFrame:CGRectZero];
        biaoqianView.title = bilities[i];
        biaoqianView.origin = CGPointMake(currentOriginX, 65);
        
        currentOriginX += biaoqianView.width + 5 ;
        
        [self addSubview:biaoqianView];
    }
}


- (void)setupData{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
