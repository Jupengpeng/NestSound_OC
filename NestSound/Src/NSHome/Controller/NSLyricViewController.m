//
//  NSLyricViewController.m
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricViewController.h"
#import "NSLyricView.h"
#import "NSUserFeedbackViewController.h"
#import "NSLyricDetailModel.h"
#import "NSCommentViewController.h"


@interface NSLyricViewController ()<UMSocialUIDelegate>
{

    UIView *_bottomView;
    
    UIView *_maskView;
    
    UIView *_moreChoiceView;
    
    UIImage * tum ;
    //头像
    UIImageView * userIcon;
    
    UIButton * upVoteBtn;
    
    UIButton *collectionBtn;
    //作者名
    UILabel *_nameLabel;
    
    //日期
    UILabel * _dateLabel;
    
    //评论数
    long commentNum;
    
    //歌词
    NSLyricView * _lyricView;
    long itemId;
    long workAuthorId;
    NSString * shareURl;
    NSString * URl;
}

@property (nonatomic,strong) LyricDetailModel * lyricDetail;

@end

@implementation NSLyricViewController


-(instancetype)initWithItemId:(long)itemId_
{
    if (self = [super init]) {
        itemId = itemId_;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_moreChoice"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    
//    [self.navigationItem actionCustomRightBarButton:@"" nrlImage:@"2.0_moreChoice" hltImage:@"2.0_moreChoice" action:^{
//        
//        _maskView.hidden = NO;
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            
//            _moreChoiceView.y = ScreenHeight - _moreChoiceView.height;
//            
//        }];
//        
//    }];
    
    [self fetchData];
    
}

- (void)rightBarButtonClick:(UIBarButtonItem *)rightBarButton {
    
    
    _maskView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _moreChoiceView.y = ScreenHeight - _moreChoiceView.height;
        
    }];
    
}


#pragma mark -fetchData
-(void)fetchData
{
    self.requestType = YES;
    NSDictionary * dic = @{@"id": [NSString stringWithFormat:@"%ld",itemId],@"uid":@""};
    NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:YES];
    NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
    
    self.requestURL = [lyricDetailURL stringByAppendingString:str];
    URl = self.requestURL;
}



#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    
    NSLog(@"operer%@",operation.urlTag);
    
    
    
    if ([operation.urlTag isEqualToString:upvoteURL] || [operation.urlTag isEqualToString:collectURL]) {
        NSLog(@"ni daye");
        if (!parserObject.success) {
            [[NSToastManager manager] showtoast:@"操作成功"];
        }
    }else if([operation.urlTag isEqualToString:URl]) {
        if (!parserObject.success) {
            NSLyricDetailModel * lyric = (NSLyricDetailModel *)parserObject;
            [self setupBottomView];
            
            [self setupLyricView];
            
            [self moreChoice];

            
            self.lyricDetail = (LyricDetailModel *)lyric.lryicDetailModel;
                   }
    
//    }else if ([operation.urlTag isEqualToString:upvoteURL]||[operation.urlTag isEqualToString:collectURL]){
//        if (parserObject.success) {
//            
//        }
    }
    
}

- (void)setupBottomView {
    
    _bottomView = [[UIView alloc] init];
    
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        
        make.height.mas_equalTo(50);
    }];
    
    
    UIView *line = [self cuttingLine];
    
    [_bottomView addSubview:line];
    
    
    
    userIcon = [[UIImageView alloc] init];
    userIcon.userInteractionEnabled = YES;
    userIcon.layer.cornerRadius = 17;
    userIcon.layer.masksToBounds = YES;
    [_bottomView addSubview:userIcon];
    
    
    //头像
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
      
        
       
        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了头像");
    }];
    
    
    [userIcon addSubview:iconBtn];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView.mas_left).offset(15);
        
        make.top.equalTo(_bottomView.mas_top).offset(8);
        
        make.bottom.equalTo(_bottomView.mas_bottom).offset(-8);
        
        make.width.equalTo(iconBtn.mas_height);

    }];
    
    
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(userIcon);
        
    }];
    

    _nameLabel = [[UILabel alloc] init];
    
//    nameLabel.text = @"戴荃";
    
    _nameLabel.font = [UIFont systemFontOfSize:14];
    
    [_bottomView addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconBtn.mas_right).offset(5);
        
        make.top.equalTo(iconBtn.mas_top);
        
    }];
    



    //dateLabel
    _dateLabel = [[UILabel alloc] init];

    
//    dateLabel.text = @"2016-05-05";
    
    _dateLabel.font = [UIFont systemFontOfSize:10];
    
    [_bottomView addSubview:_dateLabel];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconBtn.mas_right).offset(5);
        
        make.bottom.equalTo(iconBtn.mas_bottom);
        
    }];
    
    
    //评论
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_comment_yes"] forState:UIControlStateNormal];
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        NSCommentViewController *commentVC = [[NSCommentViewController alloc] init];
        
        [self.navigationController pushViewController:commentVC animated:YES];

        NSLog(@"点击了评论");
        
    }];
    
    [_bottomView addSubview:commentBtn];
    
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_bottomView.mas_right).offset(-35);
        
        make.centerY.equalTo(_bottomView.mas_centerY);
        
    }];
    
    

    //评论数
    UILabel *numLabel = [[UILabel alloc] init];
    
    if (commentNum > 999) {
        
        numLabel.text = @"999+";
        
    } else if (commentNum < 1) {
        
        [commentBtn setImage:[UIImage imageNamed:@"2.0_comment_no"] forState:UIControlStateNormal];
        
    } else {
        
        numLabel.text = [NSString stringWithFormat:@"%ld",commentNum];
        
    }
    
    numLabel.textColor = [UIColor hexColorFloat:@"181818"];
    
    numLabel.font = [UIFont boldSystemFontOfSize:10];
    
    [commentBtn addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(commentBtn.mas_top).offset(1.5);
        
        make.left.equalTo(commentBtn.mas_centerX).offset(3);
        
        make.width.mas_equalTo(30);
        
    }];
    
    
    //点赞
    upVoteBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_upVote_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_upVote_selected"] forState:UIControlStateSelected];
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
        
        [self upvoteItemId:itemId _targetUID:workAuthorId _type:2 _isUpvote:NO];
        NSLog(@"点击了点赞");
        
    }];
    
    [_bottomView addSubview:upVoteBtn];
    
    [upVoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(commentBtn.mas_left).offset(-25);
        
        make.centerY.equalTo(_bottomView.mas_centerY);
       
    }];
    
    
    //收藏
    collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_collection_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_collection_selected"] forState:UIControlStateSelected];
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
        [self upvoteItemId:itemId _targetUID:workAuthorId _type:2 _isUpvote:YES];
        
        NSLog(@"点击了收藏");
        
    }];
    
    [_bottomView addSubview:collectionBtn];
    
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(upVoteBtn.mas_left).offset(-25);
        
        make.centerY.equalTo(_bottomView.mas_centerY);
        
    }];
    
    
}

#pragma mark -overrideUpvote
-(void)upvoteItemId:(long)itemId_ _targetUID:(long)targetUID_ _type:(long)type_ _isUpvote:(BOOL)isUpvote
{
    self.requestType = NO;
    self.requestParams = @{@"work_id":[NSNumber numberWithLong:itemId_],@"target_uid":[NSNumber numberWithLong:targetUID_],@"user_id":JUserID  ,@"wtype":[NSNumber numberWithLong:type_],@"token":LoginToken};
    if (isUpvote) {
        self.requestURL = upvoteURL;
    }else{
        self.requestURL = collectURL;
    }
}


- (void)setupLyricView {
    
    _lyricView = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 114)];
    
    _lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
    
    _lyricView.lyricText.showsVerticalScrollIndicator = NO;
    
    _lyricView.lyricText.editable = NO;
    
//    lyricView.lyricText.text = @"可可豆（词音：kekedou）亦称“可可子”。\n梧桐科常绿乔木可可树的果实，\n长卵圆形坚果的扁平种子，\n含油53%～58% 。\n榨出的可可脂有独特香味及融化性能。\n是可可树的产物。\n中国于1922年开始引种此种树木。\n可可喜生于温暖和湿润的气侯和富于有机质的冲积土所形成的缓坡上，\n在排水不良和重粘土上或常受台风侵袭的地方则不适宜生长。";
    
    [self.view addSubview:_lyricView];
}

- (void)moreChoice {
    
    _maskView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _maskView.backgroundColor = [UIColor lightGrayColor];
    
    _maskView.alpha = 0.5;
    
    [self.navigationController.view addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    _maskView.hidden = YES;
    
    [_maskView addGestureRecognizer:tap];
    
    
    NSArray *array = [[NSArray alloc] init];
    
    CGFloat moreChoiceViewH;
    
    #warning mark 需要判断是自己的歌词还是别人的歌词
    if (/* DISABLES CODE */ (1) == 1) {
        
        array = @[@"举报",@"分享",@"编辑"];
        
        moreChoiceViewH = 132;
    } else {
        
        array = @[@"举报",@"分享"];
        
        moreChoiceViewH = 88;
    }
    
    
    _moreChoiceView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, moreChoiceViewH)];
    
    _moreChoiceView.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.view addSubview:_moreChoiceView];
    
    
    for (int i = 0; i < array.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, _moreChoiceView.height / array.count * i, ScreenWidth, _moreChoiceView.height / array.count)];
        
        btn.tag = i;
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_moreChoiceView addSubview:btn];
        
        if (i != 0) {
            
            UIView *line = [self cuttingLine];
            
            [btn addSubview:line];
        }
        
    }
    
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn.tag == 0) {
        
        _maskView.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _moreChoiceView.y = ScreenHeight;
        }];
        
#ifdef debug
        NSLog(@"点击了举报");
#endif
        
        NSUserFeedbackViewController * feedBackVC = [[NSUserFeedbackViewController alloc] initWithType:@"post"];
        
        [self.navigationController pushViewController:feedBackVC animated:YES];
    
    } else if (btn.tag == 1) {
        
        _maskView.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _moreChoiceView.y = ScreenHeight;
        }];
        
        [Share ShareWithTitle:_lyricDetail.title andShareUrl:_lyricDetail.shareUrl andShareImage:_lyricDetail.titleImageUrl andShareText:_lyricDetail.title andVC:self];
        
        //        [UMSocialData defaultData].extConfig.title = @"分享的title";
        //        [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
        //        [UMSocialSnsService presentSnsIconSheetView:self
        //                                             appKey:umAppKey
        //                                          shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
        //                                         shareImage:[UIImage imageNamed:@"icon"]
        //                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
        //                                           delegate:self];
        
        NSLog(@"点击了分享");
    } else {
        
        _maskView.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _moreChoiceView.y = ScreenHeight;
        }];
        
         NSLog(@"点击了编辑");
    }
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        [[NSToastManager manager] showtoast:@"分享成功哦"];
        _maskView.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _moreChoiceView.y = ScreenHeight;
        }];

    }
}

- (void)tapClick:(UIGestureRecognizer *)tap {
    
    _maskView.hidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _moreChoiceView.y = ScreenHeight;
    }];
}

- (UIView *)cuttingLine {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    return line;
}


-(void)setLyricDetail:(LyricDetailModel *)lyricDetail
{
    _lyricDetail = lyricDetail;
    itemId = _lyricDetail.itemId;
    
#warning placeHolder
    [userIcon setDDImageWithURLString:_lyricDetail.headerUrl placeHolderImage:[UIImage imageNamed:@"2.0_accompany_highlighted"]];
    self.title = _lyricDetail.title;
    _nameLabel.text = _lyricDetail.author;
    _dateLabel.text = [date datetoStringWithDate:_lyricDetail.createDate];
    
    commentNum = _lyricDetail.commentNum;
    _lyricView.lyricText.text = _lyricDetail.lyrics;
    NSLog(@"_lyricView%@",_lyricView.lyricText);
    if (_lyricDetail.isZan == 1) {
        upVoteBtn.selected = YES;
    }else{
        upVoteBtn.selected = NO;
    }
    
    if (_lyricDetail.isCollect == 1) {
        
        collectionBtn.selected = YES;
    
    }else{
        
        collectionBtn.selected = NO;
    
    }
    workAuthorId = _lyricDetail.userId;
    
}

@end

