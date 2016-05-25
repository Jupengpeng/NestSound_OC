//
//  NSUpvoteMessageCell.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUpvoteMessageCell.h"

@interface NSUpvoteMessageCell()
{
    UIImageView * headerImage;
    UIImageView * titlePage;
    UIView * bkView;
    UILabel * nickNameLabel;
    UILabel * upvoteLabel;
    UILabel * createDateLabel;
    UILabel * authorNameLabel;
    UILabel * workNameLabel;
    
}
@end


@implementation NSUpvoteMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUIAppearance];
    }
    return self;
}

#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    //headerImage
    headerImage = [[UIImageView alloc] init];
    headerImage.layer.borderWidth =1 ;
    headerImage.layer.borderColor = [UIColor hexColorFloat:@"f0f0f0"].CGColor;
    headerImage.layer.cornerRadius = 18;
    headerImage.layer.masksToBounds = YES;
    [self.contentView addSubview:headerImage];
    
    //nickNameLabel
    nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.font = [UIFont systemFontOfSize:16];
    nickNameLabel.textColor = [UIColor hexColorFloat:@"181818"];
    [self.contentView addSubview:nickNameLabel];
    
    //bkview
    bkView = [[UIView alloc] init];
    bkView.backgroundColor = [UIColor hexColorFloat:@"f0f0f0"];
    bkView.layer.cornerRadius = 10;
    bkView.layer.masksToBounds = YES;
    [self.contentView addSubview:bkView];
    
    //upvoteLabel
    upvoteLabel = [[UILabel alloc] init];
    upvoteLabel.font = [UIFont systemFontOfSize:11];
    upvoteLabel.textColor = [UIColor hexColorFloat:@"666666"];
    [self.contentView addSubview:upvoteLabel];
    
    //date
    createDateLabel = [[UILabel alloc] init];
    createDateLabel.font = [UIFont systemFontOfSize:11];
    createDateLabel.textColor = [UIColor hexColorFloat:@"999999"];
    [self.contentView addSubview:createDateLabel];
    
    //worknameLabel
    workNameLabel = [[UILabel alloc] init];
    workNameLabel.font = [UIFont systemFontOfSize:14];
    workNameLabel.textColor = [UIColor hexColorFloat:@"181818"];
    [self.contentView addSubview:workNameLabel];
    
    //authorLabel
    authorNameLabel = [[UILabel alloc] init];
    authorNameLabel.font = [UIFont systemFontOfSize:11];
    authorNameLabel.textColor = [UIColor hexColorFloat:@"666666"];
    [self.contentView addSubview:authorNameLabel];

}

#pragma mark -layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(36);
    }];
    
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(12);
        make.left.equalTo(headerImage.mas_right).with.offset(10);
    }];
    
    [upvoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameLabel.mas_right).with.offset(6);
        make.bottom.equalTo(nickNameLabel.mas_bottom);
    }];
    
    [createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameLabel.mas_left);
        make.top.equalTo(nickNameLabel.mas_bottom).with.offset(6);
    }];
    
    [bkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImage.mas_left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.top.equalTo(headerImage.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
    }];
    
    [titlePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bkView.mas_left);
        make.top.equalTo(bkView.mas_top);
        make.bottom.equalTo(bkView.mas_bottom);
        make.width.mas_equalTo(75);
    }];
    
    [workNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlePage.mas_right).with.offset(10);
        make.top.equalTo(titlePage.mas_top).with.offset(20);
        make.right.equalTo(bkView.mas_right).with.offset(-10);
        
    }];
    
    [authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workNameLabel.mas_left);
        make.top.equalTo(workNameLabel.mas_bottom).with.offset(10);
        make.right.equalTo(workNameLabel.mas_right);
    }];
    
}


#pragma mark setter & getter
-(void)setHeadUrl:(NSString *)headUrl
{
    _headUrl = headUrl;
    [headerImage setDDImageWithURLString:_headUrl placeHolderImage:[UIImage imageNamed:@"2.0_addPicture"]];
}

-(void)setIsUpvote:(BOOL)isUpvote
{
    if (isUpvote) {
        upvoteLabel.text = LocalizedStr(@"prompt_userUpvote");
    }else{
        upvoteLabel.text = LocalizedStr(@"prompt_userCollection");
    }
}

-(void)setCreateDate:(NSString *)createDate
{
    _createDate = createDate;
    createDateLabel.text = _createDate;
}

-(void)setTitlePageUrl:(NSString *)titlePageUrl
{
    _titlePageUrl = titlePageUrl;
    [titlePage setDDImageWithURLString:_titlePageUrl placeHolderImage:[UIImage imageNamed:@"2.0_addPicture"]];
}

-(void)setWorkName:(NSString *)workName
{
    _workName = workName;
    workNameLabel.text = _workName;
    
}

-(void)setAuthorName:(NSString *)authorName
{
    _authorName = authorName;
    authorNameLabel.text = _authorName;
}
@end
