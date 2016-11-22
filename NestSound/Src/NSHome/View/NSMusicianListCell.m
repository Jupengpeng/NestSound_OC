//
//  NSMusicianListCell.m
//  NestSound
//
//  Created by yinchao on 2016/11/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicianListCell.h"
#import "NSBiaoqianView.h"
#import "NSInvitationListModel.h"
@interface NSMusicianListCell ()
{
    UIImageView *iconImgView;
    UIImageView *markImgView;
    UILabel     *nameLabel;
}
@end

@implementation NSMusicianListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupMusicianCellUI];
    }
    return self;
}
- (void)setupMusicianCellUI {
    //头像
    iconImgView = [[UIImageView alloc] init];
    
    iconImgView.userInteractionEnabled = YES;
    
    iconImgView.image = [UIImage imageNamed:@"2.0_weChat"];
    
    [self.contentView addSubview:iconImgView];
    
    iconImgView.clipsToBounds = YES;
    
    iconImgView.layer.cornerRadius = 20;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImgClick)];
    
//    [iconImgView addGestureRecognizer:tap];
    
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
        make.width.mas_equalTo(60);
        
        make.height.mas_equalTo(60);
        
    }];
    //标签
    markImgView = [[UIImageView alloc] init];
    
    markImgView.image = [UIImage imageNamed:@"2.3.1_musician_mark"];
    
    [self.contentView addSubview:markImgView];
    
    [markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(iconImgView.mas_right);
        
        make.bottom.equalTo(iconImgView.mas_bottom);
        
        
        
    }];
    //作者名
    nameLabel = [[UILabel alloc] init];
    
    nameLabel.font = [UIFont systemFontOfSize:14];
    
    nameLabel.textAlignment = NSTextAlignmentRight;
    
    nameLabel.text = @"疯子";
    
    [self.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImgView.mas_right).offset(10);
        
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
}
- (void)setMusicianModel:(InvitationModel *)musicianModel {
    _musicianModel = musicianModel;
    [iconImgView setDDImageWithURLString:musicianModel.headerUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    nameLabel.text = musicianModel.nickName;
    NSArray *bilities = [musicianModel.ability componentsSeparatedByString:@"/"];
    CGFloat currentOriginX = ScreenWidth-10;
    for (NSInteger i = bilities.count-1 ; i >= 0; i--) {
        NSBiaoqianView *biaoqianView = [[NSBiaoqianView alloc] initWithFrame:CGRectZero];
        biaoqianView.title = bilities[i];
        biaoqianView.origin = CGPointMake(currentOriginX-biaoqianView.width, 35);
        
        currentOriginX -= biaoqianView.width + 5 ;
        
        [self addSubview:biaoqianView];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
