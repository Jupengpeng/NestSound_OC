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

@interface NSPlayMusicViewController () <UIScrollViewDelegate, AVAudioPlayerDelegate> {
    
    UIView *_maskView;
    AVPlayer * av;
    UIView *_moreChoiceView;
    NSString * url;
    NSString * playURL;
    UIImageView *backgroundImage;
    UIButton *collectionBtn;
    UIButton *upVoteBtn;
}

@property (nonatomic,strong) NSMusicListViewController * musicVc;

@property (nonatomic, weak) UIButton *playOrPauseBtn;

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

@property (nonatomic, weak) UISlider *progressBar;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) AVPlayerItem *musicItem;

@property (nonatomic, copy) NSString *ifUrl;

@property (nonatomic, weak) UIButton *loopBtn;

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
    
    if (self.playOrPauseBtn.selected) {
        
        [self addTimer];
    }
//    if (self.player == nil) {
    
        [self fetchPlayDataWithItemId:self.itemId];

//    }
    
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self removeTimer];
}


#pragma mark -fetchMusicDetailData
-(void)fetchPlayDataWithItemId:(long)musicItemId
{
    self.requestType = YES;
    NSDictionary * dic = @{@"id":[NSString stringWithFormat:@"%ld",musicItemId],@"openmodel":@"1",@"come":@"tuijian"};
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
    
    [self addTimer];
    
//    if ([self.player isPlaying]) {
    
//        self.playOrPauseBtn.selected = YES;
//    }
    
//    [self playMusic];
}

//播放音乐
- (void)playMusicUrl:(NSString *)musicUrl {
    
    WS(wSelf);
    
    AVPlayer *player = [NSPlayMusicTool playMusicWithUrl:musicUrl block:^(AVPlayerItem *musicItem) {
        
        wSelf.musicItem = musicItem;
    }];
    
    self.player = player;
    
    self.playOrPauseBtn.selected = YES;
    
    self.progressBar.value = 0;
    
    self.progressBar.maximumValue = self.musicDetail.mp3Times;
    
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
}

- (void)endPlaying {
    
    [self fetchPlayDataWithItemId:self.musicDetail.nextItemID];
    
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
        
        [Share ShareWithTitle:_musicDetail.title andShareUrl:_musicDetail.shareURL andShareImage:_musicDetail.titleImageURL andShareText:_musicDetail.title andVC:self];
        NSLog(@"点击了播放界面的分享");
        
    }];

    [self.view addSubview:shareBtn];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.top.equalTo(self.view.mas_top).offset(32);
        
    }];
    
    //播放暂停按钮
    UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
       
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_highlighted"] forState:UIControlStateHighlighted];
        
        [btn setImage:[UIImage imageNamed:@"2.0_pause_normal"] forState:UIControlStateSelected];
        
        [btn setImage:[UIImage imageNamed:@"2.0_pause_highlighted"] forState:UIControlStateSelected|UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        if (btn.selected) {
            
            [wSelf addTimer];
            [wSelf.player play];
//            [NSPlayMusicTool playMusicWithName:@"我的天空.mp3"];
            
        } else {
            
            [wSelf removeTimer];
            [wSelf.player pause];
//            [NSPlayMusicTool pauseMusicWithName:@"我的天空.mp3"];
        }
        NSLog(@"点击了播放和暂停按钮");
        
    }];
    
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
        
        NSWriteMusicViewController *musicView = [[NSWriteMusicViewController alloc] init];
        
        [self.navigationController pushViewController:musicView animated:YES];
        
        NSLog(@"点击了伴奏按钮");
        
    }];
    
    [self.view addSubview:accompanyBtn];
    
    [accompanyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.centerY.equalTo(playOrPauseBtn.mas_centerY);
        
    }];
    
    
    //上一首按钮
    UIButton *previousBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_previous_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_previous_highlighted"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
//        [wSelf playMusic];
        [wSelf fetchPlayDataWithItemId:wSelf.musicDetail.prevItemID];
        
        NSLog(@"点击了上一首按钮");
        
    }];
    
    [self.view addSubview:previousBtn];
    
    [previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5).offset(5);
        
        make.centerY.equalTo(playOrPauseBtn.mas_centerY);
        
    }];
    
    
    //下一首按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_next_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_next_highlighted"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        
//        [wSelf playMusic];
        [wSelf fetchPlayDataWithItemId:wSelf.musicDetail.nextItemID];
        
        NSLog(@"点击了下一首按钮");
        
    }];
    
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
        
        btn.selected = !btn.selected;
        
       [self upvoteItemId:self.musicDetail.itemID _targetUID:self.musicDetail.userID _type:1 _isUpvote:NO];
        
        NSLog(@"点击了播放页的收藏");
    }];
    
    [self.view addSubview:collectionBtn];
    
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(50);
        
        make.bottom.equalTo(playtime.mas_top).offset(-25);
        
        make.width.mas_equalTo(30);
        
        make.height.mas_equalTo(30);
    }];
    
    
    //点赞
   upVoteBtn  = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_upvote_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_upvote_selected"] forState:UIControlStateSelected];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        [self upvoteItemId:self.musicDetail.itemID _targetUID:self.musicDetail.userID _type:1 _isUpvote:YES];
        NSLog(@"点击了播放页的点赞");
    }];
    
    [self.view addSubview:upVoteBtn];
    
    [upVoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(collectionBtn.mas_right).offset(margin);
        
        make.centerY.equalTo(collectionBtn.mas_centerY);
        
        make.width.mas_equalTo(30);
        
        make.height.mas_equalTo(30);
    }];
    
    

    
    //评论
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_comment_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_comment_highlighted"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        _musicVc = [[NSMusicListViewController alloc] init];
        
        NSCommentViewController *commentVC = [[NSCommentViewController alloc] init];
        
        commentVC.musicName = wSelf.musicDetail.title;
        
        [self.navigationController pushViewController:commentVC animated:YES];
        
        
        NSLog(@"点击了播放页的评论");
    }];
    
    [self.view addSubview:commentBtn];
    
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(upVoteBtn.mas_right).offset(margin);
        
        make.centerY.equalTo(collectionBtn.mas_centerY);
        
        make.width.mas_equalTo(30);
        
        make.height.mas_equalTo(30);
    }];
    
    
    //评论数
    UILabel *numLabel = [[UILabel alloc] init];
    
    if (self.commentNum > 999) {
        
        numLabel.text = @"999+";
        
    } else if (self.commentNum < 1) {
        
        [commentBtn setImage:[UIImage imageNamed:@"2.0_noComment"] forState:UIControlStateNormal];
        
        [commentBtn setImage:[UIImage imageNamed:@"2.0_noComment"] forState:UIControlStateHighlighted];
        
    } else {
        
        numLabel.text = [NSString stringWithFormat:@"%ld",self.commentNum];
        
    }
    
    numLabel.textColor = [UIColor hexColorFloat:@"d5d5d5"];
    
    numLabel.font = [UIFont boldSystemFontOfSize:10];
    
    [commentBtn addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(commentBtn.mas_top).offset(6);
        
        make.left.equalTo(commentBtn.mas_centerX).offset(3);
        
        make.width.mas_equalTo(30);
        
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
    
//    lyricView.lyricText.text = @"月溅星河 长路漫漫\n风烟残尽 独影阑珊\n谁叫我身手不凡\n谁让我爱恨两难\n到后来 肝肠寸断\n幻世当空 恩怨休怀\n舍悟离迷 六尘不改\n且怒且悲且狂哉\n是人是鬼是妖怪\n不过是心有魔债\n叫一声佛祖 回头无岸\n跪一人为师 生死无关\n善恶浮世真假界\n尘缘散去不分明\n难断\n我要 这铁棒有何用\n我有 这变化又如何\n还是不安 还是氏惆\n金箍当头 欲说还休\n我要 这铁棒醉舞魔\n我有 这变化乱迷浊\n踏碎凌霄 放肆桀骜\n世恶道险 终究难逃\n这一棒\n叫你灰飞烟灭";
    
    self.lyricView = lyricView;
    
    lyricView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:lyricView];
    
    
    NSLyricView *describeView = [[NSLyricView alloc] initWithFrame:CGRectMake(scrollView.width, 0, scrollView.width, scrollView.height)];
    
    describeView.lyricText.backgroundColor = [UIColor clearColor];
    
    describeView.lyricText.textColor = [UIColor whiteColor];
    
    describeView.lyricText.textAlignment = NSTextAlignmentCenter;
    
    describeView.lyricText.showsVerticalScrollIndicator = NO;
    
    describeView.lyricText.editable = NO;
    
//    describeView.lyricText.text = @"《悟空》灵感来源于戴荃心中的悟空精神，叛逆、多变、乐观和坚持。从五岁的时候学习音乐开始到2015年，已经有30年了，遇到过被人欺骗、被人否定、被人不承认。觉得孙悟空就是要身经百战，要去打仗，打一次强一次。这首歌将戏曲和流行音乐相结合，应该让它以时代的声音表现出来。";
    
    self.describeView = describeView;
    
    [scrollView addSubview:describeView];
    
}


- (void)moreChoice {
    
    _maskView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _maskView.backgroundColor = [UIColor lightGrayColor];
    
    _maskView.alpha = 0.5;
    
    [self.view addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    _maskView.hidden = YES;
    
    [_maskView addGestureRecognizer:tap];
    
    
    _moreChoiceView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 88)];
    
    _moreChoiceView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_moreChoiceView];
    
    WS(wSelf);
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"举报" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        NSUserFeedbackViewController * reportVC = [[NSUserFeedbackViewController alloc] initWithType:@"post"];
        [wSelf.navigationController pushViewController:reportVC animated:YES];
        NSLog(@"点击了举报");
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
        NSUserPageViewController * userVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",self.musicDetail.userID]];
        userVC.who = Other;
        [wSelf.navigationController pushViewController:userVC animated:YES];
        NSLog(@"点击了进入个人主页");
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
        
        make.height.mas_equalTo(1);
        
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
    NSLog(@"定时器%ld",(NSInteger)self.progressBar.value);
    
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
        _totaltime.text = [NSTool stringFormatWithTimeLong:self.musicDetail.mp3Times];
        NSLog(@"%@",_totaltime.text);
        _commentNum = self.musicDetail.commentNum;
        _lyricView.lyricText.text = self.musicDetail.lyrics;
        playURL = self.musicDetail.playURL;
        
#warning placeHolder
        [backgroundImage setDDImageWithURLString:self.musicDetail.titleImageURL placeHolderImage:[UIImage imageNamed:@"2.0_accompany_highlighted"]];
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
    }
}


@end







