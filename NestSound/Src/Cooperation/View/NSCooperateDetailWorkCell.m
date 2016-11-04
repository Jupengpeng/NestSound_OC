//
//  NSCooperateDetailWorkCell.m
//  NestSound
//
//  Created by yintao on 2016/11/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperateDetailWorkCell.h"

#import "NSCooperationDetailModel.h"

@interface NSCooperateDetailWorkCell ()
{
    CoWorkModel *_coWorkModel;
}
@property (nonatomic,strong) UIImageView *portraitView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *musicAuthor;

@property (nonatomic,strong) UILabel *lyricAuthor;

@property (nonatomic,strong) UILabel *createDateLabel;

@property (nonatomic,strong) UIButton *acceptButton;

@end

@implementation NSCooperateDetailWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //背景
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,98)];
        backView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor hexColorFloat:@"f4f4f4"];
        [self insertSubview:backView aboveSubview:self.contentView];
        
        //封面图片
        self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 10, 76, 76)];
        self.portraitView.clipsToBounds = YES;
        self.portraitView.layer.cornerRadius = 3.0f;
        self.portraitView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.portraitView];

        //日期时间
        self.createDateLabel = [[UILabel alloc] init];
        self.createDateLabel.font = [UIFont systemFontOfSize:12.0f];
        self.createDateLabel.textAlignment = NSTextAlignmentRight;
        self.createDateLabel.textColor = [UIColor hexColorFloat:@"999999"];
        [self addSubview:self.createDateLabel];
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor hexColorFloat:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.titleLabel];
        
        self.musicAuthor = [[UILabel alloc] init];
        self.musicAuthor.textColor = [UIColor hexColorFloat:@"666666"];
        self.musicAuthor.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.musicAuthor];
        
        
        
        self.lyricAuthor = [[UILabel alloc] init];
        self.lyricAuthor.textColor = [UIColor hexColorFloat:@"666666"];
        self.lyricAuthor.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.lyricAuthor];
        
        self.acceptButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            [btn setTitle:@"采纳" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hexColorFloat:@"666666"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [btn setBackgroundColor:[UIColor hexColorFloat:@"ffd705"]];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 3.0f;
        } action:^(UIButton *btn) {
            
            if (self.acceptBlock) {
                self.acceptBlock (_coWorkModel.itemid);
            }
            
        }];
        
        [self addSubview:self.acceptButton];
        
    }
    return self;
}

- (void)setupDataWithCoWorkModel:(CoWorkModel *)model IsMine:(BOOL)isMine{
    _coWorkModel = model;
    if (isMine && !self.isAccepted) {
        self.acceptButton.hidden = NO;
    }else{
        self.acceptButton.hidden = YES;
    }
    
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]] ;
    
    self.titleLabel.text = [NSString stringWithFormat:@"歌曲名：%@",model.title];

    self.musicAuthor.text = [NSString stringWithFormat:@"作曲：%@",model.wUsername];
    self.lyricAuthor.text = [NSString stringWithFormat:@"作词：%@",model.lUsername];
//    @"2016.10.21  20:09"
    self.createDateLabel.text = [date datetoMonthStringWithDate:model.createtime format:@"YYYY.MM.dd HH:mm"];

}


- (void)setupDataWithIsMine:(BOOL)isMine{
    
    if (!isMine) {
        self.acceptButton.hidden = YES;
    }

    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]] ;
    self.titleLabel.text = [NSString stringWithFormat:@"歌曲名：%@",@"洋葱"];
    self.musicAuthor.text = [NSString stringWithFormat:@"作曲：%@",@"洋葱"];
    self.lyricAuthor.text = [NSString stringWithFormat:@"作词：%@",@"洋葱"];
    
    self.createDateLabel.text = @"2016.10.21  20:09";
}


- (void)layoutSubviews{
    
    [self.createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(18);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(12.0f);
        
    }];
    
    [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(52);
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(28);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(18);
        make.left.equalTo(self.portraitView.mas_right).offset(10);
        make.height.mas_equalTo(14.0f);
        make.right.equalTo(self.createDateLabel.mas_left).offset(-5);
        
    }];
    
    [self.musicAuthor mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.portraitView.mas_right).offset(10);
        make.height.mas_equalTo(14.0f);
        make.right.equalTo(self.acceptButton.mas_left).offset(- 5.0f);
    }];
    
    [self.lyricAuthor mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.musicAuthor.mas_bottom).offset(8);
        make.left.equalTo(self.portraitView.mas_right).offset(10);
        make.height.mas_equalTo(14.0f);
        make.right.equalTo(self.acceptButton.mas_left).offset(- 5.0f);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
