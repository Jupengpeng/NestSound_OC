//
//  NSStarMusicianBottomCell.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSStarMusicianBottomCell.h"
#import "NSStarMusicianModel.h"
#import "UIButton+WebCache.h"

@interface NSStarMusicianBottomCell ()

@property (nonatomic,strong) UIButton *coverButton;

@property (nonatomic,strong) UILabel *songNameLabel;

@property (nonatomic,strong) UILabel *authorLabel;

@end

@implementation NSStarMusicianBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    
    self.coverButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        [btn setImage:[UIImage imageNamed:@"ic_bofang"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"ic_zanting"] forState:UIControlStateNormal];
        btn.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        
    } action:^(UIButton *btn) {
            
        if (self.clickBlock) {
            self.clickBlock(btn,self.musicianModel);
        }
        
    }];
    [self addSubview:self.coverButton];
    [self.coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(70);
    }];
    
    
    
    self.songNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.songNameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.songNameLabel.textColor = [UIColor hexColorFloat:@"9e9e9e"];
    
    [self addSubview:self.songNameLabel];
    
    [self.songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverButton.mas_right).offset(20);
        make.top.equalTo(self.mas_top).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    self.authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.authorLabel.font = [UIFont systemFontOfSize:13.0f];
    self.authorLabel.textColor = [UIColor hexColorFloat:@"9e9e9e"];
    
    [self addSubview:self.authorLabel];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverButton.mas_right).offset(20);
        make.top.equalTo(self.songNameLabel.mas_bottom).offset(18);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    
    
    
}

-(void)setMusicianModel:(NSWorklistModel *)musicianModel{
    _musicianModel = musicianModel;
    [self.coverButton sd_setBackgroundImageWithURL:[NSURL URLWithString:musicianModel.pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    self.songNameLabel.text  =[NSString stringWithFormat:@"歌曲名：%@",musicianModel.title ];
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@",musicianModel.name];

    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
