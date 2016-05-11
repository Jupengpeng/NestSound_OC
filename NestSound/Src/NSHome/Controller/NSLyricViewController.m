//
//  NSLyricViewController.m
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricViewController.h"
#import "NSLyricView.h"

@interface NSLyricViewController () {
    
    UIView *_bottomView;
    
    UIView *_maskView;
    
    UIView *_moreChoiceView;
    
}

@end
static NSString *num = @"7473";
@implementation NSLyricViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"悟空";
    
    [self.navigationItem actionCustomRightBarButton:@"" nrlImage:@"2.0_moreChoice" hltImage:@"2.0_moreChoice" action:^{
        
        _maskView.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _moreChoiceView.y = ScreenHeight - _moreChoiceView.height;
            
        }];
        
    }];
    
    [self setupBottomView];
    
    [self setupLyricView];
    
    [self moreChoice];
}

- (void)setupBottomView {
    
    _bottomView = [[UIView alloc] init];
    
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        
        make.height.mas_equalTo(44);
    }];
    
    
    UIView *line = [self cuttingLine];
    
    [_bottomView addSubview:line];
    
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"img_01"] forState:UIControlStateNormal];
        
        btn.layer.cornerRadius = 14;
        
        btn.clipsToBounds = YES;

        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了头像");
    }];
    
    [_bottomView addSubview:iconBtn];
    
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_bottomView.mas_left).offset(15);
        
        make.top.equalTo(_bottomView.mas_top).offset(8);
        
        make.bottom.equalTo(_bottomView.mas_bottom).offset(-8);
        
        make.width.equalTo(iconBtn.mas_height);
        
    }];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    
    nameLabel.text = @"戴荃";
    
    nameLabel.font = [UIFont systemFontOfSize:14];
    
    [_bottomView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconBtn.mas_right).offset(5);
        
        make.top.equalTo(iconBtn.mas_top);
        
    }];
    
    
    UILabel *dateLabel = [[UILabel alloc] init];
    
    dateLabel.text = @"2016-05-05";
    
    dateLabel.font = [UIFont systemFontOfSize:10];
    
    [_bottomView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconBtn.mas_right).offset(5);
        
        make.bottom.equalTo(iconBtn.mas_bottom);
        
    }];
    
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_comment_yes"] forState:UIControlStateNormal];
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了评论");
    }];
    
    [_bottomView addSubview:commentBtn];
    
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_bottomView.mas_right).offset(-35);
        
        make.centerY.equalTo(_bottomView.mas_centerY);
        
    }];
    
    
    UILabel *numLabel = [[UILabel alloc] init];
    
    if ([num intValue] > 999) {
        
        numLabel.text = @"999+";
        
    } else if ([num intValue] < 1) {
        
        [commentBtn setImage:[UIImage imageNamed:@"2.0_comment_no"] forState:UIControlStateNormal];
        
    } else {
        
        numLabel.text = num;
        
    }
    
    numLabel.textColor = [UIColor hexColorFloat:@"181818"];
    
    numLabel.font = [UIFont boldSystemFontOfSize:10];
    
    [commentBtn addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(commentBtn.mas_top).offset(1.5);
        
        make.left.equalTo(commentBtn.mas_centerX).offset(3);
        
        make.width.mas_equalTo(30);
        
    }];
    
    
    UIButton *upVoteBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_upVote_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_upVote_selected"] forState:UIControlStateSelected];
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
        NSLog(@"点击了点赞");
        
    }];
    
    [_bottomView addSubview:upVoteBtn];
    
    [upVoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(commentBtn.mas_left).offset(-25);
        
        make.centerY.equalTo(_bottomView.mas_centerY);
       
    }];
    
    
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_collection_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_collection_selected"] forState:UIControlStateSelected];
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
        NSLog(@"点击了收藏");
        
    }];
    
    [_bottomView addSubview:collectionBtn];
    
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(upVoteBtn.mas_left).offset(-25);
        
        make.centerY.equalTo(_bottomView.mas_centerY);
        
    }];
    
    
}

- (void)setupLyricView {
    
    NSLyricView *lyricView = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 108)];
    
    lyricView.lyricText.text = @"可可豆（词音：kekedou）亦称“可可子”。\n梧桐科常绿乔木可可树的果实，\n长卵圆形坚果的扁平种子，\n含油53%～58% 。\n榨出的可可脂有独特香味及融化性能。\n是可可树的产物。\n中国于1922年开始引种此种树木。\n可可喜生于温暖和湿润的气侯和富于有机质的冲积土所形成的缓坡上，\n在排水不良和重粘土上或常受台风侵袭的地方则不适宜生长。";
    
    [self.view addSubview:lyricView];
}

- (void)moreChoice {
    
    _maskView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _maskView.backgroundColor = [UIColor lightGrayColor];
    
    _maskView.alpha = 0.5;
    
    [self.navigationController.view addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    _maskView.hidden = YES;
    
    [_maskView addGestureRecognizer:tap];
    
    
    _moreChoiceView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 134)];
    
    _moreChoiceView.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.view addSubview:_moreChoiceView];
    
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"举报" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了举报");
    }];
    
    [_moreChoiceView addSubview:reportBtn];
    
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(_moreChoiceView);
        
        make.height.mas_equalTo(_moreChoiceView.height / 3);
        
    }];
    

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"分享" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了分享");
    }];
    
    [_moreChoiceView addSubview:shareBtn];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_moreChoiceView);
        
        make.top.equalTo(reportBtn.mas_bottom);
        
        make.height.equalTo(reportBtn.mas_height);
        
    }];
    
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了编辑");
    }];
    
    [_moreChoiceView addSubview:editBtn];
    
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_moreChoiceView);
        
        make.top.equalTo(shareBtn.mas_bottom);
        
        make.height.equalTo(shareBtn.mas_height);
        
    }];
    
    
    UIView *line1 = [self cuttingLine];
    
    UIView *line2 = [self cuttingLine];
    
    [shareBtn addSubview:line1];
    
    [editBtn addSubview:line2];
    
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


@end













