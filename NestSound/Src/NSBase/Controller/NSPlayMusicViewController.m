//
//  NSPlayMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPlayMusicViewController.h"
#import "NSPlayMusicTool.h"
#import "NSMusicListViewController.h"
#import "NSLyricView.h"
#import "NSCommentViewController.h"
#import "NSPlayMusicDetailModel.h"
#import <AVFoundation/AVFoundation.h>
#import "NSUserFeedbackViewController.h"
#import "NSUserPageViewController.h"
#import "NSWriteMusicViewController.h"
#import "NSLoginViewController.h"

@interface NSPlayMusicViewController () <UIScrollViewDelegate, AVAudioPlayerDelegate> {
    
    UIView *_maskView;
    AVPlayer * av;
    UIView *_moreChoiceView;
    NSString * url;
    NSString * playURL;
    UIImageView *backgroundImage;
    UIButton *collectionBtn;
    UIButton *upVoteBtn;
    UILabel * upvoteNumLabel;
    UILabel * collecNumLabel;
    UILabel * commentNumLabel;
}

@property (nonatomic,strong) NSMusicListViewController * musicVc;

@property (nonatomic, weak) UIPageControl *page;

//图片
@property (nonatomic, weak) UIImage *coverImage;

//歌名
@property (nonatomic, weak) UILabel *songName;

//评论数
@property (nonatomic, assign) long commentNum;

//总时间
@property (nonatomic, weak) UILabel *totaltime;

//播放时间
@property (nonatomic, weak) UILabel *playtime;

//歌词
@property (nonatomic, weak) NSLyricView *lyricView;

//描述
@property (nonatomic, weak)  NSLyricView *describeView;

@property (nonatomic, strong) UIScrollView *scrollV;


@property (nonatomic, weak) UIButton *commentBtn;

@property (nonatomic, weak) UISlider *progressBar;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) AVPlayerItem *musicItem;

@property (nonatomic, copy) NSString *ifUrl;

@property (nonatomic, weak) UIButton *loopBtn;

@property (nonatomic,strong) UILabel * numLabel;

@end

static id _instance;

@implementation NSPlayMusicViewController

+ (instancetype)sharedPlayMusic {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+ (instancetype)alloc {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super alloc] init];
    });
    
    return _instance;
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    AVAudioSession * session =[ AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    if (self.playOrPauseBtn.selected) {
        
        [self addTimer];
    }
    
    [self fetchPlayDataWithItemId:self.itemId];
    
    self.scrollV.contentOffset = CGPointMake(0, 0);
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self removeTimer];
}


#pragma mark -fetchMusicDetailData
-(void)fetchPlayDataWithItemId:(long)musicItemId
{
    self.requestType = YES;
    NSDictionary * dic;
    if (self.geDanID!=0) {
        dic = @{@"id":[NSString stringWithFormat:@"%ld",musicItemId],@"openmodel":@(1),@"come":self.from,@"gedanid":@(self.geDanID)};
    }else{
<<<<<<< HEAD
        dic = @{@"id":[NSString stringWithFormat:@"%ld",musicItemId],@"openmodel":@(1),@"come":self.from,@"gedanid":@(self.geDanID)};
=======
        dic = @{@"id":[NSString stringWithFormat:@"%ld",musicItemId],@"openmodel":@"1",@"come":self.from};
>>>>>>> 1ff6631bbe688576f32fb1c68a740b18f229bdc9
    }
    NSString * str = [NSTool encrytWithDic:dic];
    url = [playMusicURL stringByAppendingString:str];
    self.requestURL = url;
    
}


#pragma mark -overriderActionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        if ([operation.urlTag isEqualToString:url]) {
            NSPlayMusicDetailModel * musicModel = (NSPlayMusicDetailModel *)parserObject;
            self.musicDetail = musicModel.musicdDetail;
        }
    }else{
        
        [[NSToastManager manager] showtoast:@"亲，网络有些异常哦，请查看一下网络状态"];
    }
    if ([operation.urlTag isEqualToString:upvoteURL] || [operation.urlTag isEqualToString:collectURL]) {
        if (!parserObject.success) {
            [[NSToastManager manager] showtoast:@"操作成功"];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.alpha = 0.9;
    effectView.frame = backgroundImage.frame;
    
    [backgroundImage addSubview:effectView];
    
    UIImageView *transparentImage = [[UIImageView alloc] initWithFrame:backgroundImage.frame];
    UIImage * image = [UIImage imageNamed:@"2.0_background_transparent"];
    //    [image applyBlurWithRadius:0.8 tintColor:[UIColor colorWithWhite:1.0 alpha:0.3] saturationDeltaFactor:0.5 maskImage:nil];
    transparentImage.image = image;
    
    
    [self.view addSubview:backgroundImage];
    [backgroundImage addSubview:transparentImage];
    
    
    [self setupUI];
    
    [self moreChoice];
    
}

//播放音乐
- (void)playMusicUrl:(NSString *)musicUrl {
    
    WS(wSelf);
    
    self.player = [NSPlayMusicTool playMusicWithUrl:musicUrl block:^(AVPlayerItem *musicItem) {
        
        wSelf.musicItem = musicItem;
    }];
    
    
    self.playOrPauseBtn.selected = YES;
    
    self.progressBar.maximumValue = self.musicDetail.mp3Times;
    
    if (!self.timer) {
        
        [self addTimer];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
}

- (void)endPlaying {
    
    if (self.loopBtn.selected) {
        
        [self removeTimer];
        
        [self.player pause];
        
        self.player = nil;
        
        self.progressBar.value = 0;
        
        self.playtime.text = @"00:00";
        
        self.playOrPauseBtn.selected = NO;
        
        [NSPlayMusicTool stopMusicWithName:nil];
        
        [self playMusicUrl:self.musicDetail.playURL];
    } else {
        
        [self removeTimer];
        
        if (self.musicDetail.nextItemID) {
            
            [self fetchPlayDataWithItemId:self.musicDetail.nextItemID];
            
        } else {
            
            [self removeTimer];
            
            [self.player pause];
            
            self.player = nil;
            
            self.progressBar.value = 0;
            
            self.playtime.text = @"00:00";
            
            self.playOrPauseBtn.selected = NO;
            
            [NSPlayMusicTool stopMusicWithName:nil];
        }
    }
    
    NSLog(@"播放结束");
}


- (void)setupUI {
    
    WS(wSelf);
    
    //pop按钮
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_pop"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        [wSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [self.view addSubview:popBtn];
    
    [popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(15);
        
        make.top.equalTo(self.view.mas_top).offset(32);
        
        make.width.mas_equalTo(50);
    }];
    
    
    //歌名
    UILabel *songName = [[UILabel alloc] init];
    
    songName.textColor = [UIColor whiteColor];
    
    //    songName.text = @"我在那一角落患过伤风";
    
    self.songName = songName;
    
    [self.view addSubview:songName];
    
    [songName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(32);
        
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
    //分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_share"] forState:UIControlStateNormal];
        
        
    } action:^(UIButton *btn) {
        
        [Share ShareWithTitle:_musicDetail.title andShareUrl:[NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,_musicDetail.itemID] andShareImage:_musicDetail.titleImageURL andShareText:_musicDetail.title andVC:self];
        NSLog(@"点击了播放界面的分享");
        
    }];
    
    [self.view addSubview:shareBtn];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.top.equalTo(self.view.mas_top).offset(32);
        
    }];
    
    //播放暂停按钮
    UIButton *playOrPauseBtn = [[UIButton alloc] init];
    
    [playOrPauseBtn setImage:[UIImage imageNamed:@"2.0_playSongs_normal"] forState:UIControlStateNormal];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"2.0_playSongs_highlighted"] forState:UIControlStateHighlighted];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"2.0_pause_normal"] forState:UIControlStateSelected];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"2.0_pause_highlighted"] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.playOrPauseBtn = playOrPauseBtn;
    
    [self.view addSubview:playOrPauseBtn];
    
    [playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    
    
    //循环按钮
    UIButton *loopBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_orderPlay_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_orderPlay_highlighted"] forState:UIControlStateHighlighted];
        
        [btn setImage:[UIImage imageNamed:@"2.0_repeatOne_normal"] forState:UIControlStateSelected];
        
        [btn setImage:[UIImage imageNamed:@"2.0_repeatOne_highlighted"] forState:UIControlStateSelected|UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
        NSLog(@"点击了循环播放按钮");
        
    }];
    
    self.loopBtn = loopBtn;
    
    [self.view addSubview:loopBtn];
    
    [loopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(15);
        
        make.centerY.equalTo(playOrPauseBtn.mas_centerY);
        
    }];
    
    
    //伴奏按钮
    UIButton *accompanyBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_accompany_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_accompany_highlighted"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        [wSelf.player pause];
        
        playOrPauseBtn.selected = NO;
        
        NSWriteMusicViewController *musicView = [[NSWriteMusicViewController alloc] initWithItemId:_musicDetail.hotId andMusicTime:_musicDetail.hotMp3Times andHotMp3:_musicDetail.hotMP3];
        
        [self.navigationController pushViewController:musicView animated:YES];
        
        NSLog(@"点击了伴奏按钮");
        
    }];
    
    [self.view addSubview:accompanyBtn];
    
    [accompanyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.centerY.equalTo(playOrPauseBtn.mas_centerY);
        
    }];
    
    
    //上一首按钮
<<<<<<< HEAD
    UIButton *previousBtn = [[UIButton alloc] init];

    [previousBtn setImage:[UIImage imageNamed:@"2.0_previous_normal"] forState:UIControlStateNormal];
    
    [previousBtn setImage:[UIImage imageNamed:@"2.0_previous_highlighted"] forState:UIControlStateHighlighted];
    
    [previousBtn addTarget:self action:@selector(previousBtnClick:) forControlEvents:UIControlEventTouchUpInside];
=======
    UIButton *previousBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_previous_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_previous_highlighted"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        //        [wSelf playMusic];
        [wSelf fetchPlayDataWithItemId:wSelf.musicDetail.prevItemID];
        
        NSLog(@"点击了上一首按钮");
        
    }];
>>>>>>> 1ff6631bbe688576f32fb1c68a740b18f229bdc9
    
    [self.view addSubview:previousBtn];
    
    [previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5).offset(5);
        
        make.centerY.equalTo(playOrPauseBtn.mas_centerY);
        
    }];
    
    
    //下一首按钮
<<<<<<< HEAD
    UIButton *nextBtn = [[UIButton alloc] init];
    
    [nextBtn setImage:[UIImage imageNamed:@"2.0_next_normal"] forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:@"2.0_next_highlighted"] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
=======
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_next_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_next_highlighted"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        
        //        [wSelf playMusic];
        [wSelf fetchPlayDataWithItemId:wSelf.musicDetail.nextItemID];
        
        NSLog(@"点击了下一首按钮");
        
    }];
>>>>>>> 1ff6631bbe688576f32fb1c68a740b18f229bdc9
    
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.5).offset(-5);
        
        make.centerY.equalTo(playOrPauseBtn.mas_centerY);
    }];
    
    
    //播放时间
    UILabel *playtime = [[UILabel alloc] init];
    
    playtime.textColor = [UIColor whiteColor];
    
    playtime.font = [UIFont systemFontOfSize:10];
    
    playtime.text = @"00:00";
    
    self.playtime = playtime;
    
    [self.view addSubview:playtime];
    
    [playtime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(15);
        
        make.bottom.equalTo(playOrPauseBtn.mas_top).offset(-20);
        
    }];
    
    
    //总时间
    UILabel *totaltime = [[UILabel alloc] init];
    
    totaltime.textColor = [UIColor whiteColor];
    
    totaltime.font = [UIFont systemFontOfSize:10];
    
    self.totaltime = totaltime;
    
    [self.view addSubview:totaltime];
    
    [totaltime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.bottom.equalTo(playOrPauseBtn.mas_top).offset(-20);
        
    }];
    
    
    //进度条
    UISlider *progressBar = [[UISlider alloc] init];
    
    [progressBar setThumbImage:[UIImage imageNamed:@"2.0_playSongs_dot"] forState:UIControlStateNormal];
    
    progressBar.minimumTrackTintColor = [UIColor hexColorFloat:@"ffce00"];
    
    progressBar.maximumTrackTintColor = [UIColor whiteColor];
    
    progressBar.minimumValue = 0;
    
    [progressBar addTarget:self action:@selector(progressBarSlither:) forControlEvents:UIControlEventValueChanged];
    
    self.progressBar = progressBar;
    
    [self.view addSubview:progressBar];
    
    [progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(55);
        
        make.right.equalTo(self.view.mas_right).offset(-55);
        
        make.centerY.equalTo(playtime.mas_centerY);
        
    }];
    
    
    //四个按钮的间距
    CGFloat margin = (ScreenWidth - 220) / 3;
    
    //收藏
    collectionBtn  = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_collection_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_collection_selected"] forState:UIControlStateSelected];
        
    } action:^(UIButton *btn) {
        
        if (JUserID) {
            
            btn.selected = !btn.selected;
            
            [self upvoteItemId:self.musicDetail.itemID _targetUID:self.musicDetail.userID _type:1 _isUpvote:NO];
            
            NSLog(@"点击了播放页的收藏");
        } else {
            
            [[NSToastManager manager] showtoast:@"请登录后再收藏"];
        }
        
    }];
    
    [self.view addSubview:collectionBtn];
    
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(50);
        
        make.bottom.equalTo(playtime.mas_top).offset(-25);
        
        make.width.mas_equalTo(30);
        
        make.height.mas_equalTo(30);
    }];
    
    //collectNumLabel
    collecNumLabel = [[UILabel alloc] init];
    collecNumLabel.font = [UIFont systemFontOfSize:11];
    collecNumLabel.textAlignment = NSTextAlignmentCenter;
    collecNumLabel.textColor = [UIColor hexColorFloat:@"d6cdcb"];
    [self.view addSubview:collecNumLabel];
    
    [collecNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(collectionBtn.mas_centerX);
        make.top.equalTo(collectionBtn.mas_bottom).offset(5);
    }];
    
    
    
    //点赞
    upVoteBtn  = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_upvote_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_upvote_selected"] forState:UIControlStateSelected];
        
    } action:^(UIButton *btn) {
        
        if (JUserID) {
            
            btn.selected = !btn.selected;
            [self upvoteItemId:self.musicDetail.itemID _targetUID:self.musicDetail.userID _type:1 _isUpvote:YES];
            NSLog(@"点击了播放页的点赞");
        } else {
            
            [[NSToastManager manager] showtoast:@"请登录后再点赞"];
        }
        
    }];
    
    [self.view addSubview:upVoteBtn];
    
    [upVoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(collectionBtn.mas_right).offset(margin);
        
        make.centerY.equalTo(collectionBtn.mas_centerY);
        
        make.width.mas_equalTo(30);
        
        make.height.mas_equalTo(30);
    }];
    
    //upvoteNumLabel
    upvoteNumLabel = [[UILabel alloc] init];
    upvoteNumLabel.font = [UIFont systemFontOfSize:11];
    upvoteNumLabel.textAlignment = NSTextAlignmentCenter;
    upvoteNumLabel.textColor = [UIColor hexColorFloat:@"d6cdcb"];
    [self.view addSubview:upvoteNumLabel];
    
    [upvoteNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(upVoteBtn.mas_centerX);
        make.top.equalTo(upVoteBtn.mas_bottom).offset(5);
    }];
    
    //评论
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_comment_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_comment_highlighted"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        if (JUserID) {
            
            _musicVc = [[NSMusicListViewController alloc] init];
            
            NSCommentViewController *commentVC = [[NSCommentViewController alloc] initWithItemId:wSelf.musicDetail.itemID andType:1];
            
            commentVC.musicName = wSelf.musicDetail.title;
            
            [self.navigationController pushViewController:commentVC animated:YES];
            
            NSLog(@"点击了播放页的评论");
        } else {
            
            [[NSToastManager manager] showtoast:@"请登录后查看评论"];
        }
        
    }];
    
    self.commentBtn = commentBtn;
    
    [self.view addSubview:commentBtn];
    
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(upVoteBtn.mas_right).offset(margin);
        
        make.centerY.equalTo(collectionBtn.mas_centerY);
        
        make.width.mas_equalTo(30);
        
        make.height.mas_equalTo(30);
    }];
    
    
    //commentNumLabe
    commentNumLabel = [[UILabel alloc] init];
    commentNumLabel.font = [UIFont systemFontOfSize:11];
    commentNumLabel.textAlignment = NSTextAlignmentCenter;
    commentNumLabel.textColor = [UIColor hexColorFloat:@"d6cdcb"];
    [self.view addSubview:commentNumLabel];
    
    [commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(commentBtn.mas_centerX);
        make.top.equalTo(commentBtn.mas_bottom).offset(5);
        
    }];
    
    //更多
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_more_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_more_highlighted"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        _maskView.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _moreChoiceView.y = ScreenHeight - _moreChoiceView.height;
            
        }];
        
        NSLog(@"点击了播放页的更多");
    }];
    
    [self.view addSubview:moreBtn];
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-50);
        
        make.centerY.equalTo(collectionBtn.mas_centerY);
        
        make.width.mas_equalTo(30);
        
        make.height.mas_equalTo(30);
    }];
    
    
    //歌词和简介的scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 70, ScreenWidth - 30, ScreenHeight - 280)];
    
    scrollView.delegate = self;
    
    scrollView.showsVerticalScrollIndicator = NO;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //    scrollView.bounces = NO;
    
    scrollView.contentSize = CGSizeMake((ScreenWidth - 30) * 2, 0);
    
    scrollView.pagingEnabled = YES;
    
    self.scrollV = scrollView;
    
    [self.view addSubview:scrollView];
    
    NSLog(@"%@",NSStringFromCGRect(collectionBtn.frame));
    
    
    //page
    UIPageControl *page = [[UIPageControl alloc] init];
    
    page.numberOfPages = 2;
    
    page.pageIndicatorTintColor = [UIColor hexColorFloat:@"c1c1c1"];
    
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    self.page = page;
    
    [self.view addSubview:page];
    
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.bottom.equalTo(collectionBtn.mas_top).offset(10);
        
    }];
    
    //歌词
    NSLyricView *lyricView = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
    
    lyricView.lyricText.backgroundColor = [UIColor clearColor];
    
    lyricView.lyricText.textColor = [UIColor whiteColor];
    
    lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
    
    lyricView.lyricText.showsVerticalScrollIndicator = NO;
    
    lyricView.lyricText.editable = NO;
    
    self.lyricView = lyricView;
    
    lyricView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:lyricView];
    
    
    NSLyricView *describeView = [[NSLyricView alloc] initWithFrame:CGRectMake(scrollView.width, 0, scrollView.width, scrollView.height)];
    
    describeView.lyricText.backgroundColor = [UIColor clearColor];
    
    describeView.lyricText.textColor = [UIColor whiteColor];
    
    describeView.lyricText.textAlignment = NSTextAlignmentCenter;
    
    describeView.lyricText.showsVerticalScrollIndicator = NO;
    
    describeView.lyricText.editable = NO;
    
    self.describeView = describeView;
    
    [scrollView addSubview:describeView];
    
}

//播放暂停点击事件
- (void)playOrPauseBtnClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        
        
        if (self.musicDetail.playURL != nil) {
            
            //                [wSelf addTimer];
            
            [self playMusicUrl:self.ifUrl];
            
        } else {
            [self addTimer];
            [self.player play];
        }
        
    } else {
        
        [self removeTimer];
        [self.player pause];
        
    }
    NSLog(@"点击了播放和暂停按钮");
    
}

//上一首歌的点击事件
- (void)previousBtnClick:(UIButton *)btn {
    
//    if (self.musicDetail.prevItemID) {
//        
//        [self removeTimer];
//    }
    
    [self fetchPlayDataWithItemId:self.musicDetail.prevItemID];
    
    NSLog(@"点击了上一首按钮");
    
}

//下一首歌曲的点击事件
- (void)nextBtnClick:(UIButton *)btn {
    
//    if (self.musicDetail.nextItemID) {
//        
//        [self removeTimer];
//    }
    
    [self fetchPlayDataWithItemId:self.musicDetail.nextItemID];
    
    NSLog(@"点击了下一首按钮");
}

- (void)moreChoice {
    
    _maskView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _maskView.backgroundColor = [UIColor lightGrayColor];
    
    _maskView.alpha = 0.5;
    
    [self.view addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    _maskView.hidden = YES;
    
    [_maskView addGestureRecognizer:tap];
    
    
    _moreChoiceView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 90)];
    
    _moreChoiceView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_moreChoiceView];
    
    WS(wSelf);
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"举报" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        if (JUserID) {
            
            _maskView.hidden = YES;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                _moreChoiceView.y = ScreenHeight;
            }];
            
            NSUserFeedbackViewController * reportVC = [[NSUserFeedbackViewController alloc] initWithType:@"post"];
            [wSelf.navigationController pushViewController:reportVC animated:YES];
            NSLog(@"点击了举报");
        } else {
            
            [[NSToastManager manager] showtoast:@"请登录后再举报"];
        }
    }];
    
    [_moreChoiceView addSubview:reportBtn];
    
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(_moreChoiceView);
        
        make.height.mas_equalTo(_moreChoiceView.height / 2);
        
    }];
    
    
    UIButton *personalBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"进入个人主页" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        if (JUserID) {
            
            NSUserPageViewController * userVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",self.musicDetail.userID]];
            userVC.who = Other;
            [self.navigationController pushViewController:userVC animated:YES];
            NSLog(@"点击了进入个人主页");
        } else {
            
            _maskView.hidden = YES;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                _moreChoiceView.y = ScreenHeight;
                
            }];
            
            
            NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
            
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }];
    
    [_moreChoiceView addSubview:personalBtn];
    
    [personalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_moreChoiceView);
        
        make.top.equalTo(reportBtn.mas_bottom);
        
        make.height.equalTo(reportBtn.mas_height);
        
    }];
    
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    [reportBtn addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.bottom.equalTo(reportBtn.mas_bottom);
        
        make.height.mas_equalTo(0.5);
        
    }];
    
}


#pragma mark -OverrideUpvote
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

- (void)tapClick:(UIGestureRecognizer *)tap {
    
    _maskView.hidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _moreChoiceView.y = ScreenHeight;
    }];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger pageNum = scrollView.contentOffset.x / scrollView.width;
    
    switch (pageNum) {
        case 0:
            
            self.page.currentPage = 0;
            break;
            
        case 1:
            
            self.page.currentPage = 1;
            break;
        default:
            break;
    }
    
}


//进度条数值
- (void)progressBarSlither:(UISlider *)progressBar {
    
    CMTime ctime = CMTimeMake(progressBar.value, 1);
    
    [self.musicItem seekToTime:ctime];
    
    NSLog(@"%f",progressBar.value);
}


- (void)addTimer {
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(actionTiming) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)actionTiming {
    
    self.progressBar.value ++;
    NSLog(@"定时器%ld",(long)self.progressBar.value);
    
    CMTime ctime = self.musicItem.currentTime;
    UInt64 currentTimeSec = ctime.value/ctime.timescale;
    self.progressBar.value = currentTimeSec;
    
    self.playtime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)self.progressBar.value / 60, (NSInteger)self.progressBar.value % 60];
}

- (void)removeTimer {
    
    [self.timer invalidate];
    
    self.timer = nil;
}


- (void)dealloc {
    
    [self removeTimer];
    
}


-(void)setMusicDetail:(NSPlayMusicDetail *)musicDetail
{
    
    if (musicDetail.playURL != nil && ![musicDetail.playURL isEqualToString:self.ifUrl]) {
        
        _musicDetail = musicDetail;
        _songName.text = self.musicDetail.title;
<<<<<<< HEAD
        self.totaltime.text = [NSTool stringFormatWithTimeLong:self.musicDetail.mp3Times];
        NSLog(@"%@",self.totaltime.text);
        //        commentNumLabel.text = [NSString stringWithFormat:@"%ld",_musicDetail.commentNum];
        //        upvoteNumLabel.text = [NSString stringWithFormat:@"%ld",_musicDetail.zanNum];
        //        collecNumLabel.text = [NSString stringWithFormat:@"%ld",_musicDetail.fovNum];
        
        
=======
        _totaltime.text = [NSTool stringFormatWithTimeLong:self.musicDetail.mp3Times];
        NSLog(@"%@",_totaltime.text);
>>>>>>> 1ff6631bbe688576f32fb1c68a740b18f229bdc9
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc ] init];
        paragraphStyle.lineSpacing = 10;
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor whiteColor]};
        _lyricView.lyricText.attributedText = [[NSAttributedString alloc] initWithString:self.musicDetail.lyrics attributes:attributes];
        _lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
        
        playURL = self.musicDetail.playURL;
        if (self.musicDetail.detaile!=nil&&self.musicDetail.detaile.length!=0) {
            self.describeView.lyricText.text = [NSString stringWithFormat:@"歌曲描述:%@",self.musicDetail.detaile];
        }else{
            self.describeView.lyricText.text = @"亲,singer并木有添加描述哦";
        }
        [backgroundImage setDDImageWithURLString:self.musicDetail.titleImageURL placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
        if (self.musicDetail.isZan == 1) {
            upVoteBtn.selected = YES;
        }else{
            upVoteBtn.selected = NO;
        }
        if (self.musicDetail.isCollection == 1) {
            collectionBtn.selected = YES;
        }else{
            collectionBtn.selected = NO;
        }
        
        [self playMusicUrl:self.musicDetail.playURL];
        
        self.ifUrl = musicDetail.playURL;
    } else if(![musicDetail.playURL isEqualToString:self.ifUrl] && musicDetail.playURL != nil) {
        
        self.progressBar.value = 0;
        
        [self removeTimer];
        
        self.playtime.text = @"00:00";
        
        self.playOrPauseBtn.selected = NO;
        
    }
    
    
    //评论数
    
    [self.commentBtn setImage:[UIImage imageNamed:@"2.0_noComment"] forState:UIControlStateNormal];
    
    [self.commentBtn setImage:[UIImage imageNamed:@"2.0_noComment"] forState:UIControlStateHighlighted];
    commentNumLabel.text = [NSString stringWithFormat:@"%ld",_musicDetail.commentNum];
    NSLog(@"comme%ld",_musicDetail.commentNum);
    upvoteNumLabel.text = [NSString stringWithFormat:@"%ld",_musicDetail.zanNum];
    collecNumLabel.text = [NSString stringWithFormat:@"%ld",_musicDetail.fovNum];
    
}


@end







