//
//  NSCooperateDetailMainCell.m
//  NestSound
//
//  Created by yintao on 2016/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperateDetailMainCell.h"
#import "UIButton+Webcache.h"
#import "NSCooperationDetailModel.h"
@interface NSCooperateDetailMainCell ()
{
    NSCooperationDetailModel *_detailModel;
}

@property (nonatomic,strong) UIButton *portraitBtn;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *releaseTimeLabel;

@property (nonatomic,strong) UILabel *deadlineLabel;

@property (nonatomic,strong) UILabel *descriptionLabel;

@property (nonatomic,strong) UIView *lyricView;

@property (nonatomic,strong) UILabel *lyricTitleLabel;

@property (nonatomic,strong) UILabel *lyricAuthorLabel;

@property (nonatomic,strong) UILabel *lyricContentLabel;

@property (nonatomic,copy) NSCooperateDetailMainCellHeightBlock heightBlock;

@end

@implementation NSCooperateDetailMainCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.portraitBtn];
        [self addSubview:self.nameLabel];
        [self addSubview:self.releaseTimeLabel];
        [self addSubview:self.deadlineLabel];
        [self addSubview:self.descriptionLabel];
        [self addSubview:self.lyricView];
        [self.lyricView addSubview:self.lyricTitleLabel];
        [self.lyricView addSubview:self.lyricAuthorLabel];
        [self.lyricView addSubview:self.lyricContentLabel];
        
        UILabel *linelabel= [[UILabel alloc] init];
        linelabel.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
        [self addSubview:linelabel];
        
        
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(63);
            make.left.equalTo(self.mas_left).offset(11);
            make.right.equalTo(self.mas_right).offset(-11);
            
        }];
        
        [linelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descriptionLabel.mas_bottom).offset(11);
            make.left.equalTo(self.mas_left).offset(11.0f);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(0.5);
            
        }];
        
        [self.lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(linelabel.mas_bottom);
            make.width.mas_equalTo(ScreenWidth);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(100);
        }];
        
        
        [self.lyricTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lyricView.mas_top).offset(11);
            make.width.mas_equalTo(ScreenWidth);
            make.centerX.equalTo(self.mas_centerX);
        }];

        
        [self.lyricAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lyricTitleLabel.mas_bottom).offset(10.0f);
            make.width.mas_equalTo(ScreenWidth);

            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.lyricContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lyricAuthorLabel.mas_bottom).offset(10.0f);
            make.width.mas_equalTo(ScreenWidth);

            make.centerX.equalTo(self.mas_centerX);
            
        }];

        
    }
    
    return self;
}


- (void)showDataWithModel:(NSCooperationDetailModel *)model completion:(NSCooperateDetailMainCellHeightBlock)completion{

    _detailModel = model;
    
    self.heightBlock = completion;
    [self.portraitBtn sd_setImageWithURL:[NSURL URLWithString:model.userInfo.headurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    
    self.nameLabel.text = model.userInfo.nickname;
//    @"2016.08.12  20:34"
    self.releaseTimeLabel.text =  [date datetoMonthStringWithDate:model.demandInfo.createtime format:@"YYYY.MM.dd HH:mm"];
//    @"10.21
    self.deadlineLabel.text = [NSString stringWithFormat:@"至%@过期",[date datetoMonthStringWithDate:model.demandInfo.endtime format:@"MM.dd"]];

    self.descriptionLabel.text = model.demandInfo.requirement;
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.paragraphSpacing = 8 ;
    paragraphStyle.lineSpacing = 13.0f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    /*
    @"夜风凛凛 独回望旧事前尘\
    \n是以往的我 充满怒愤\
    \n诬告与指责积压着满肚气不愤\
    \n对谣言反应 甚为着紧\
    \n受了教训 得了书经的指引\
    \n现已看得透 不再自困\
    \n但觉有分数\
    \n不再像以往那般笨\
    \n抹泪痕轻快笑着行\
    \n冥冥中都早注定你富或贫\
    \n是错永不对真永是真\
    \n任你怎说安守我本份\
    \n始终相信沉默是金\
    \n是非有公理 慎言莫冒犯别人\
    \n遇上冷风雨休太认真"
     **/
    self.lyricContentLabel.attributedText = [[NSAttributedString alloc] initWithString:model.demandInfo.lyrics attributes:attributes];
    self.lyricTitleLabel.text = model.demandInfo.title;
    self.lyricAuthorLabel.text = [NSString stringWithFormat:@"作词：%@",model.userInfo.nickname];
    
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)layoutSubviews{

    

    [self.lyricView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetMaxY(self.lyricContentLabel.frame) + 11);
    }];
    

    CGFloat currentHeight = CGRectGetMaxY(self.lyricContentLabel.frame) + 11 + CGRectGetMaxY(self.descriptionLabel.frame) + 11;
    if (currentHeight == self.height) {
        return;
    }else{
        
        if (self.heightBlock) {
            self.heightBlock(currentHeight);
        }
        
    }
    
}

#pragma mark - lazy load

- (UIButton *)portraitBtn{
    if (!_portraitBtn) {
        _portraitBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(11, 11, 42, 42);
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 21;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        } action:^(UIButton *btn) {
            
            if (self.userClickBlock) {
                self.userClickBlock([NSString stringWithFormat:@"%ld",(long)_detailModel.userInfo.uid]);
            }
            
            
        }];
    }
    return _portraitBtn;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(63, 13, 100, 14);
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = [UIColor hexColorFloat:@"181818"];
    }
    return _nameLabel;
}

- (UILabel *)releaseTimeLabel{
    if (!_releaseTimeLabel) {
        _releaseTimeLabel = [UILabel new];
        _releaseTimeLabel.frame = CGRectMake(63, 33, 100, 12);
        _releaseTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        _releaseTimeLabel.textColor = [UIColor hexColorFloat:@"666666"];
    }
    return _releaseTimeLabel;
}

- (UILabel *)deadlineLabel{
    if (!_deadlineLabel) {
        _deadlineLabel = [[UILabel alloc] init];
        _deadlineLabel.frame = CGRectMake(ScreenWidth - 120, 30, 110, 18);
        _deadlineLabel.textAlignment = NSTextAlignmentRight;
        _deadlineLabel.font = [UIFont systemFontOfSize:18.0f];
        _deadlineLabel.textColor = [UIColor hexColorFloat:@"666666"];
    }
    return _deadlineLabel;
}

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.textColor = [UIColor hexColorFloat:@"999999"];
        _descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _descriptionLabel;
}

- (UIView *)lyricView{
    if (!_lyricView) {
        _lyricView = [[UIView alloc] init];
    }
    return _lyricView;
}

- (UILabel *)lyricTitleLabel{
    if (!_lyricTitleLabel) {
        _lyricTitleLabel = [[UILabel alloc] init];
        _lyricTitleLabel.textAlignment = NSTextAlignmentCenter;
        _lyricTitleLabel.textColor = [UIColor hexColorFloat:@"333333"];
        _lyricTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _lyricTitleLabel;
}

- (UILabel *)lyricAuthorLabel{
    if (!_lyricAuthorLabel) {
        _lyricAuthorLabel = [[UILabel alloc] init];
        _lyricAuthorLabel.textAlignment = NSTextAlignmentCenter;
        _lyricAuthorLabel.textColor = [UIColor hexColorFloat:@"333333"];
        _lyricAuthorLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _lyricAuthorLabel;
}

- (UILabel *)lyricContentLabel{
    if (!_lyricContentLabel) {
        _lyricContentLabel = [[UILabel alloc] init];
        _lyricContentLabel.numberOfLines = 0;
        _lyricContentLabel.textColor = [UIColor hexColorFloat:@"666666"];
        _lyricContentLabel.font = [UIFont systemFontOfSize:14.0f];
        _lyricContentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lyricContentLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
