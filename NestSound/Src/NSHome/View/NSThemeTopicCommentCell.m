//
//  NSThemeTopicCommentCell.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/16.
//  Copyright © 2016年 yinchao. All rights reserved.
//
static NSInteger const kLabelTag = 200;

#import "NSThemeTopicCommentCell.h"
#import "NSJoinedWorkListModel.h"
#import "UIButton+WebCache.h"
#import "NSTool.h"
#import "NSThemeCommentCell.h"
#import "NSUserPageViewController.h"
@interface NSThemeTopicCommentCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton *headerIcon;
@property (nonatomic,strong) UILabel *releaserLabel;
@property (nonatomic,strong) UILabel *releaseTimeLabel;
@property (nonatomic,strong) UILabel *songName;
@property (nonatomic,strong) UILabel *authorLabel;
@property (nonatomic,strong) UILabel *watchedCount;
@property (nonatomic,strong) UILabel *favourateCount;
@property (nonatomic,strong) UILabel *collectedCount;


@property (nonatomic,strong) UIImageView *songCoverImageView;

//@property (nonatomic,strong) UITableView *commentTextView;

@property (nonatomic,strong) UIButton *moreCommentButton;

@property (nonatomic,strong) UIButton *commentButton;

@property(nonatomic,strong) UITableView *tableView;

@end


@implementation NSThemeTopicCommentCell

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
    
    self.clipsToBounds = YES;
    
    /**
     *  头像
     */
    self.headerIcon = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 45/2.0f;
        btn.contentMode = UIViewContentModeScaleAspectFill;
    } action:^(UIButton *btn) {
        [self userButtonClick:btn];
        
    }];

    [self addSubview:self.headerIcon];
    
    [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
    }];
    
    
    self.releaserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
    self.releaserLabel.font = [UIFont systemFontOfSize:14.0f];
    self.releaserLabel.textColor = [UIColor hexColorFloat:@"222222"];
    [self addSubview:self.releaserLabel];
    
    [self.releaserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIcon.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(14.0f);
    }];
    
    
    self.releaseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 13)];
    self.releaseTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.releaseTimeLabel.textColor = [UIColor hexColorFloat:@"a3a3a3"];
    [self addSubview:self.releaseTimeLabel];
    
    [self.releaseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIcon.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(33);
    }];
    
    self.songCoverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.songCoverImageView.clipsToBounds = YES;
    self.songCoverImageView.userInteractionEnabled = YES;
    self.songCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.songCoverImageView];
    [self.songCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.headerIcon.mas_bottom).offset(10);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(76);
    }];
    
    self.songCoverButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        btn.frame = CGRectMake(0, 0, 76, 76);
        btn.clipsToBounds = YES;
        
    } action:^(UIButton *btn) {
        [self coverButtonClick:btn];
    }];
    
    [self addSubview:self.songCoverButton];
    
    [self.songCoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.headerIcon.mas_bottom).offset(10);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(76);
    }];
    
    self.songName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    self.songName.textColor = [UIColor hexColorFloat:@"7d7d7d"];
    self.songName.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.songName];
    [self.songName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.songCoverButton.mas_right).offset(10.0f);
        make.top.equalTo(self.mas_top).offset(70);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    self.authorLabel.textColor = [UIColor hexColorFloat:@"7d7d7d"];
    self.authorLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.songCoverButton.mas_right).offset(10.0f);
        make.top.equalTo(self.songName.mas_bottom).offset(12);
        make.right.equalTo(self.mas_right).offset(-15);
        
    }];
    
    /**
     查看数
     
     */
    UIImageView *watchedimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IC_yanjing"]];
    [self addSubview:watchedimageView];
    
    [watchedimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.songCoverButton.mas_right).offset(10.0f);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(12);
    }];
    
    self.watchedCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 11)];
    self.watchedCount.textColor = [UIColor hexColorFloat:@"a3a3a3"];
    self.watchedCount.font = [UIFont systemFontOfSize:11.0f];
    
    [self addSubview:self.watchedCount];
    
    [self.watchedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(watchedimageView.mas_right).offset(10);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(12);
    }];
    /**
     喜欢数量
     
     - returns: <#return value description#>
     */
    UIImageView *favourateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_dianzan"]];
    [self addSubview:favourateImageView];
    
    [favourateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(watchedimageView.mas_right).offset(60);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(12);
    }];
    
    self.favourateCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 11)];
    self.favourateCount.textColor = [UIColor hexColorFloat:@"a3a3a3"];
    self.favourateCount.font = [UIFont systemFontOfSize:11.0f];
    
    [self addSubview:self.favourateCount];
    
    [self.favourateCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(favourateImageView.mas_right).offset(10);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(12);
    }];
    
    /**
     收藏数量
     
     - returns: <#return value description#>
     */
    UIImageView *collectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_soucang"]];
    [self addSubview:collectionImageView];
    [collectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(favourateImageView.mas_right).offset(60);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(12);
    }];
    
    self.collectedCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 11)];
    self.collectedCount.textColor = [UIColor hexColorFloat:@"a3a3a3"];
    self.collectedCount.font = [UIFont systemFontOfSize:11.0f];
    
    [self addSubview:self.collectedCount];
    
    [self.collectedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collectionImageView.mas_right).offset(10);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(12);
    }];
    
    
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        btn.backgroundColor = [UIColor hexColorFloat:@"f6f6f6"];
        [btn setTitle:@"评论..." forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor hexColorFloat:@"7d7d7d"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    } action:^(UIButton *btn) {
        /**
         *  发起评论
         */
        [self launchCommentClick:btn];
    }];
    
    [self addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    
//    [self addSubview:self.tableView];
    
    /**
     *  更多评论点击
     *  @return <#return value description#>
     */
    self.moreCommentButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitleColor:[UIColor hexColorFloat:@"808080"] forState:UIControlStateNormal];
//        [btn setTitle:[NSString stringWithFormat:@"更多%ld条评论>>",self.workDetailModel.commentnum] forState:UIControlStateNormal];
        [btn setTitle:@"更多评论" forState:UIControlStateNormal];

        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    } action:^(UIButton *btn) {
        /**
         *  更多评论
         */
        [self moreCommentClick:btn];
    }];
    self.moreCommentButton.clipsToBounds = YES;
    [self addSubview:self.moreCommentButton];
    [self.moreCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(15.0f);
        make.bottom.equalTo(self.commentButton.mas_top).offset(-5.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.songCoverButton.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(20 * 3);
    }];
}



- (void)setWorkDetailModel:(NSJoinedWorkDetailModel *)workDetailModel{
//    self.headerIcon.image = [UIImage imageNamed:@"2.0_placeHolder_long"];

    _workDetailModel = workDetailModel;
    
    
    if (workDetailModel.isMusic) {
        [self.songCoverButton setImage:[UIImage imageNamed:@"2.0_play"] forState:UIControlStateNormal];
        [self.songCoverButton setImage:[UIImage imageNamed:@"2.0_suspended"] forState:UIControlStateSelected];
    }else{
        
    }
    
    [self.headerIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:workDetailModel.headurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"] ];
    [self.songCoverImageView setDDImageWithURLString:workDetailModel.pic placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];

    

    /**
     * 封面点击状态
     */
    self.songCoverButton.selected = workDetailModel.isPlay;
    
    
    self.releaserLabel.text = workDetailModel.nickname;
    self.releaseTimeLabel.text = [NSTool updateTimeForCreateTimeIntrval:workDetailModel.jointime];
    self.songName.text = [NSString stringWithFormat:@"歌曲名：%@",workDetailModel.title];
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@",workDetailModel.nickname];
    self.watchedCount.text = [NSString stringWithFormat:@"%ld",(long)workDetailModel.looknum];
    self.favourateCount.text = [NSString stringWithFormat:@"%ld",(long)workDetailModel.zannum];
    self.collectedCount.text = [NSString stringWithFormat:@"%ld",(long)workDetailModel.fovnum];
    
    
    
    /**
     *  设置评论

     */

    if (workDetailModel.commentnum > 3) {
        
        self.tableView.height = 20 * 3;
        [self.moreCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        
    }else{
        
        [self.moreCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20 * workDetailModel.commentnum);
    }];
    }
    
    [self.tableView reloadData];
}



#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_workDetailModel.commentnum > 3) {
        
        return 3;
        
    }else{
        
        return _workDetailModel.commentnum;
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSThemeCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSThemeCommentCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentLabel.tag = kLabelTag + indexPath.row;
    NSJoinWorkCommentModel *commentModel = self.workDetailModel.workCommonList[indexPath.row];
    
    cell.commentModel = commentModel;

    cell.commetorClickBlock = ^(NSInteger uid){
        if (self.commetorClickBlock) {
            self.commetorClickBlock(uid);
        }
    };
    
    return cell;
}

#pragma make - 

#pragma mark - TTTAttributedLabelDelegate




#pragma mark button's actions

- (void)userButtonClick:(UIButton *)button{
    
    if (self.headerClickBlock) {
        self.headerClickBlock(self.workDetailModel);
    }
    
}

- (void)coverButtonClick:(UIButton *)button{
    button.selected = !button.selected;
    self.workDetailModel.isPlay = button.selected;
    
    
    if (self.workCoverBlock) {
        self.workCoverBlock(self.workDetailModel,button);
    }
}


- (void)moreCommentClick:(UIButton *)button{
    if (self.moreCommentClick) {
        self.moreCommentClick(0,nil);
    }
}

- (void)launchCommentClick:(UIButton *)button{
    if (self.launchCommentClick) {
        self.launchCommentClick(0,nil);
    }
}



#pragma mark lazy init

- (UITableView *)tableView{
    if (!_tableView) {
        
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 280)];
    [_tableView registerClass:[NSThemeCommentCell class] forCellReuseIdentifier:@"NSThemeCommentCellID"];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
