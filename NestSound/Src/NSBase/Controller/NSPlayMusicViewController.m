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
#import "NSSelectLyricsViewController.h"
#import "NSLoginViewController.h"
#import "NSShareView.h"
#import "NSIndexModel.h"
#import "NSSongListModel.h"
#import "NSRollView.h"
@interface NSPlayMusicViewController () <UIScrollViewDelegate, AVAudioPlayerDelegate> {
    
    UIView *_maskView;
    AVPlayer * av;
    UIView *_moreChoiceView;
    NSString * url;
    NSString * playURL;
    UIImageView *backgroundImage;
    UIButton *collectionBtn;
    UIButton *upVoteBtn;
    UIButton *reportBtn;
    UIButton *personalBtn;
    UILabel * upvoteNumLabel;
    UILabel * collecNumLabel;
    UILabel * commentNumLabel;
    NSShareView *shareView;
    NSArray *shareArr;
}

@property (nonatomic,strong) NSMusicListViewController * musicVc;

@property (nonatomic, weak) UIPageControl *page;

//图片
@property (nonatomic, weak) UIImage *coverImage;

//歌名
@property (nonatomic, strong) NSRollView *songName;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayer)
                                                 name:@"pausePlayer"
                                               object:nil];
    
    if (self.playOrPauseBtn.selected) {
        
        if (!self.timer) {
            
            [self addTimer];
        }
    }
    
    [self fetchPlayDataWithItemId:self.itemUid];
    
    [self moreChoice];
    
    self.scrollV.contentOffset = CGPointMake(0, 0);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //耳机线控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnsState) name:@"changeBtnsState" object:nil];
    
    //毛玻璃效果
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    backgroundImage.contentMode =  UIViewContentModeScaleAspectFill;
    backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    backgroundImage.clipsToBounds  = YES;
    
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.alpha = 1.0;
    effectView.frame = backgroundImage.frame;
    [backgroundImage addSubview:effectView];
    
    UIImageView *transparentImage = [[UIImageView alloc] initWithFrame:backgroundImage.frame];
    UIImage * image = [UIImage imageNamed:@"2.0_background_transparent"];
    transparentImage.image = image;
    
    
    [self.view addSubview:backgroundImage];
    [backgroundImage addSubview:transparentImage];
    
    
    [self setupUI];
    
    
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self tapClick:nil];
    
    [self removeTimer];
}

- (void)changeBtnsState {
    upVoteBtn.selected = NO;
    collectionBtn.selected = NO;
}
#pragma mark -fetchMusicDetailData
-(void)fetchPlayDataWithItemId:(long)musicItemId
{
    
    self.requestType = YES;
    NSDictionary * dic;
    if (JUserID) {
        
        dic = @{@"id":[NSString stringWithFormat:@"%ld",musicItemId],@"uid":JUserID};
    }else{
        
        dic = @{@"id":[NSString stringWithFormat:@"%ld",musicItemId]};
    }
    NSString * str = [NSTool encrytWithDic:dic];
    url = [playMusicURL stringByAppendingString:str];
    self.requestURL = url;
    
}


#pragma mark -overriderActionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if ( requestErr) {
        
    } else {
        if (!parserObject.success) {
            /**
             *  下载歌曲 播放
             */
            if ([operation.urlTag isEqualToString:url]) {
                NSPlayMusicDetailModel * musicModel = (NSPlayMusicDetailModel *)parserObject;
                if ([[NSString stringWithFormat:@"%zd",musicModel.musicdDetail.userID] isEqualToString: JUserID]) {
                    if (self.isShow == 0) {
                        [reportBtn setTitle:@"将作品设为公开" forState:UIControlStateNormal];
                    } else {
                        [reportBtn setTitle:@"将作品设为私密" forState:UIControlStateNormal];
                    }
                    [personalBtn setTitle:@"取消" forState:UIControlStateNormal];
                } else {
                    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
                    [personalBtn setTitle:@"进入个人主页" forState:UIControlStateNormal];
                }
                self.musicDetail = musicModel.musicdDetail;
                
            }else if ([operation.urlTag isEqualToString:upvoteURL]) {
                if (upVoteBtn.selected == YES) {
                    self.musicDetail.zanNum = self.musicDetail.zanNum + 1;
                    upvoteNumLabel.text = [NSString  stringWithFormat:@"%ld",self.musicDetail.zanNum];
                }else{
                    self.musicDetail.zanNum = self.musicDetail.zanNum - 1;
                    upvoteNumLabel.text = [NSString  stringWithFormat:@"%ld",self.musicDetail.zanNum];
                }
                [[NSToastManager manager] showtoast:@"操作成功"];
            }else if ([operation.urlTag isEqualToString:collectURL]){
                if (collectionBtn.selected == YES) {
                    self.musicDetail.fovNum = self.musicDetail.fovNum + 1;
                    collecNumLabel.text = [NSString  stringWithFormat:@"%ld",self.musicDetail.fovNum];
                    
                }else{
                    self.musicDetail.fovNum = self.musicDetail.fovNum - 1;
                    collecNumLabel.text = [NSString  stringWithFormat:@"%ld",self.musicDetail.fovNum];
                }
                [[NSToastManager manager] showtoast:@"操作成功"];
            } else if ([operation.urlTag isEqualToString:changeMusicStatus]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserPageNotific" object:nil];
            }
        }else{
            
            [[NSToastManager manager] showtoast:@"亲，网络有些异常哦，请查看一下网络状态"];
        }
    }
}



//播放音乐
- (void)playMusicUrl:(NSString *)musicUrl {
    
    CHLog(@"--------musicUrl = %@",musicUrl);
    WS(wSelf);
    self.player = [NSPlayMusicTool playMusicWithUrl:musicUrl block:^(AVPlayerItem *musicItem) {
        
        wSelf.musicItem = musicItem;
        
    }];
    [self playMusicWithUrl:musicUrl];
    
    CMTime duration = self.player.currentItem.asset.duration;
    
    CGFloat seconds = CMTimeGetSeconds(duration);
    
    self.progressBar.maximumValue = seconds;
    
    self.totaltime.text = [NSString stringWithFormat:@"%02d:%02d",(int)seconds / 60, (int)seconds % 60];
    
    self.playOrPauseBtn.selected = YES;
    
    if (!self.timer) {
        
        [self addTimer];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
    /**
     *  切歌
     */
//    [[NSNotificationCenter defaultCenter] postNotificationName:ChangePlayItemNotification object:@(self.musicDetail.itemID)];
}

- (void)endPlaying {
    
    self.playOrPauseBtn.selected = NO;
    
    if (self.loopBtn.selected) {
        
        [self removeTimer];
        
        [self.player pause];
        
//        [NSPlayMusicViewController sharedPlayMusic].itemUid = 0;
        
        self.progressBar.value = 0;
        
        self.playtime.text = @"00:00";
        
        self.playOrPauseBtn.selected = NO;
        
        [NSPlayMusicTool stopMusicWithName:nil];
        //[self stopMusic];

        [self playMusicUrl:self.musicDetail.playURL];
    } else {
        
        if (self.songAry.count > 1) {
            self.progressBar.value = 0;
            
            self.playtime.text = @"00:00";
            
            [self nextBtnClick:nil];
            
        } else {
            
            /**
             *  <#Description#>
             */
            [self removeTimer];
            
            [self.player pause];
            
//            [NSPlayMusicViewController sharedPlayMusic].itemUid = 0;
            
            self.progressBar.value = 0;
            
            self.playtime.text = @"00:00";
            
            self.playOrPauseBtn.selected = NO;
            
            [NSPlayMusicTool stopMusicWithName:nil];
            //[self stopMusic];

            
            [self playMusicUrl:self.musicDetail.playURL];

        }
    }
    
}


- (void)setupUI {
    
    WS(wSelf);
    self.view.backgroundColor = [UIColor grayColor];
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
        
        make.width.mas_equalTo(30);
    }];
    
    //分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_share"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        _maskView.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            shareView.y = ScreenHeight - shareView.height;
        }];
        
    }];
    
    [self.view addSubview:shareBtn];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.top.equalTo(self.view.mas_top).offset(32);
        
        make.width.mas_equalTo(30);
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
        
        if (btn.selected) {
            [[NSToastManager manager] showtoast:@"顺序播放"];
        } else {
            [[NSToastManager manager] showtoast:@"单曲循环"];
        }
        
        btn.selected = !btn.selected;
        
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
        CHLog(@"%ld",_musicDetail.hotId);
        [self.navigationController pushViewController:musicView animated:YES];
        
    }];
    
    [self.view addSubview:accompanyBtn];
    
    [accompanyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.centerY.equalTo(playOrPauseBtn.mas_centerY);
        
    }];
    
    
    //上一首按钮

    UIButton *previousBtn = [[UIButton alloc] init];

    [previousBtn setImage:[UIImage imageNamed:@"2.0_previous_normal"] forState:UIControlStateNormal];
    
    [previousBtn setImage:[UIImage imageNamed:@"2.0_previous_highlighted"] forState:UIControlStateHighlighted];
    
    [previousBtn addTarget:self action:@selector(previousBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:previousBtn];
    
    [previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5).offset(5);
        
        make.centerY.equalTo(playOrPauseBtn.mas_centerY);
        
    }];
    
    
    //下一首按钮

    UIButton *nextBtn = [[UIButton alloc] init];
    
    [nextBtn setImage:[UIImage imageNamed:@"2.0_next_normal"] forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:@"2.0_next_highlighted"] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
        
        [btn setImage:[UIImage imageNamed:@"2.0_noComment"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_comment_highlighted"] forState:UIControlStateHighlighted];
        
    } action:^(UIButton *btn) {
        
        if (JUserID) {
            
            _musicVc = [[NSMusicListViewController alloc] init];
            
            NSCommentViewController *commentVC = [[NSCommentViewController alloc] initWithItemId:wSelf.musicDetail.itemID andType:1];
            
            commentVC.musicName = wSelf.musicDetail.title;
            
            [self.navigationController pushViewController:commentVC animated:YES];
            
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
        
        /**
         *  将暂停回传给前面的活动界面
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:PauseCurrentItemNotification object:@(self.musicDetail.itemID)];
        
    }
    
}

//previous song
- (void)previousBtnClick:(UIButton *)btn {
    
    if (self.songAry.count != 0) {
        self.songID = self.songID - 1;
        if (self.songID == -1) {
            self.itemUid   = [[self.songAry lastObject] longValue];
            self.songID = self.songAry.count - 1;
        }else{
            self.itemUid   = [self.songAry[self.songID] longValue];
        }
        [self fetchPlayDataWithItemId:self.itemUid];
        if ([self.from isEqualToString:@"gedan"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToRow" object:[NSString stringWithFormat:@"%ld",self.itemUid]];
            [NSPlayMusicViewController sharedPlayMusic].itemUid = self.itemUid;
        }
        if ([self.from isEqualToString:@"huodong"]) {
            /**
             *  切歌
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangePlayItemNotification object:@(self.musicDetail.itemID)];
            [NSPlayMusicViewController sharedPlayMusic].itemUid = self.itemUid;

        }
    }else{
        self.itemUid = self.musicDetail.prevItemID;
        [self fetchPlayDataWithItemId:self.musicDetail.prevItemID];
        if ([self.from isEqualToString:@"gedan"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToRow" object:[NSString stringWithFormat:@"%ld",self.musicDetail.nextItemID]];
            
        }
        if ([self.from isEqualToString:@"huodong"]) {
            /**
             *  切歌
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangePlayItemNotification object:@(self.itemUid)];
        }
    }
}

//next song
- (void)nextBtnClick:(UIButton *)btn {
    
    if (self.songAry.count != 0) {
        /**
         *  当前歌曲为歌单的最后一首，跳到第一首歌曲
         */
        if (self.songID == self.songAry.count - 1) {
            self.itemUid   = [[self.songAry firstObject] longValue];
            self.songID = 0;
        }else{
            /**
             *  下一首歌曲
             */
            self.songID = self.songID + 1;
            self.itemUid   = [self.songAry[self.songID] longValue];
        }
        [self fetchPlayDataWithItemId:self.itemUid];
        if ([self.from isEqualToString:@"gedan"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToRow" object:[NSString stringWithFormat:@"%ld",self.itemUid]];
        }
        if ([self.from isEqualToString:@"huodong"]) {
            /**
             *  切歌
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangePlayItemNotification object:@(self.itemUid)];
            
        }
    }else{
        self.itemUid = self.musicDetail.nextItemID;
        [self fetchPlayDataWithItemId:self.musicDetail.nextItemID];
        if ([self.from isEqualToString:@"gedan"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToRow" object:[NSString stringWithFormat:@"%ld",self.musicDetail.nextItemID]];
        }
        if ([self.from isEqualToString:@"huodong"]) {
            /**
             *  切歌
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangePlayItemNotification object:@(self.musicDetail.nextItemID)];
        }
    }
    
}

- (void)moreChoice {
    
    _maskView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _maskView.backgroundColor = [UIColor lightGrayColor];
    
    _maskView.alpha = 0.5;
    
    [self.view addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    _maskView.hidden = YES;
    
    [_maskView addGestureRecognizer:tap];
    // 分享弹框
    shareView = [[NSShareView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 180) withType:@"player"];
    shareArr = [NSArray arrayWithArray:shareView.shareArr];
    shareView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 7; i++) {
        UIButton *shareBtn = (UIButton *)[shareView viewWithTag:250+i];
        [shareBtn addTarget:self action:@selector(handleShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:shareView];
    
    _moreChoiceView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 90)];
    
    _moreChoiceView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_moreChoiceView];
    
    reportBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [reportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [reportBtn addTarget:self action:@selector(handleReportBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [_moreChoiceView addSubview:reportBtn];
    
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(_moreChoiceView);
        
        make.height.mas_equalTo(_moreChoiceView.height / 2);
        
    }];
    
    personalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    personalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [personalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [personalBtn addTarget:self action:@selector(handlePersonalBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)handleReportBtnEvent:(UIButton *)sender {
    CHLog(@"sender title%@",sender.currentTitle);
    int isShow;
    if ([sender.currentTitle isEqualToString:@"举报"]) {
        if (JUserID) {
            
            _maskView.hidden = YES;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                _moreChoiceView.y = ScreenHeight;
            }];
            
            NSUserFeedbackViewController * reportVC = [[NSUserFeedbackViewController alloc] initWithType:@"post"];
            [self.navigationController pushViewController:reportVC animated:YES];
            
        } else {
            
            [[NSToastManager manager] showtoast:@"请登录后再举报"];
        }
        
    } else if ([sender.currentTitle isEqualToString:@"将作品设为公开"]) {
        isShow = 1;
        
        [sender setTitle:@"将作品设为私密" forState:UIControlStateNormal];
    } else if ([sender.currentTitle isEqualToString:@"将作品设为私密"]) {
        isShow = 0;
        
        [sender setTitle:@"将作品设为公开" forState:UIControlStateNormal];
    }
    self.requestType = NO;
    self.requestParams = @{@"id":[NSNumber numberWithLong:self.musicDetail.itemID],@"is_issue":[NSNumber numberWithInt:isShow],@"token":LoginToken};
    self.requestURL = changeMusicStatus;
}
- (void)handlePersonalBtnEvent:(UIButton *)sender {

    if ([sender.currentTitle isEqualToString:@"取消"]) {
        [self tapClick:nil];
    } else if ([sender.currentTitle isEqualToString:@"进入个人主页"]) {
        
        _maskView.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _moreChoiceView.y = ScreenHeight;
            
        }];
        if (JUserID) {
            
            NSUserPageViewController * userVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",self.musicDetail.userID]];
            
            userVC.who = Other;
            [self.navigationController pushViewController:userVC animated:YES];
            
        } else {
            
            NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
            
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }
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
        shareView.y = ScreenHeight;
        
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


//progress
- (void)progressBarSlither:(UISlider *)progressBar {
    
    CMTime ctime = CMTimeMake(progressBar.value, 1);
    
    [self.musicItem seekToTime:ctime];
    
    self.playtime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)self.progressBar.value / 60, (NSInteger)progressBar.value % 60];
}


- (void)addTimer {
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(actionTiming) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)actionTiming {
    
    self.progressBar.value ++;
    
    CMTime ctime = self.musicItem.currentTime;
    UInt64 currentTimeSec = ctime.value/ctime.timescale;
    self.progressBar.value = currentTimeSec;
    
    self.playtime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)self.progressBar.value / 60, (NSInteger)self.progressBar.value % 60];
}

- (void)removeTimer {
    
    [self.timer invalidate];
    
    self.timer = nil;
}


-(void)setMusicDetail:(NSPlayMusicDetail *)musicDetail
{
    
    if (musicDetail.playURL != nil && ![musicDetail.playURL isEqualToString:self.ifUrl]) {
        _musicDetail = musicDetail;
        [self.songName removeFromSuperview];
        self.songName = [[NSRollView alloc] initWithFrame:CGRectMake(50, 32, ScreenWidth-100, 30)];
        _songName.text = [NSString stringWithFormat:@"%@    ",self.musicDetail.title];
        [self.view addSubview:_songName];
        
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
    }  else {
        
    }
    
    
    //评论数
    [self.commentBtn setImage:[UIImage imageNamed:@"2.0_noComment"] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"2.0_noComment"] forState:UIControlStateHighlighted];
    commentNumLabel.text = [NSString stringWithFormat:@"%ld",_musicDetail.commentNum];
    upvoteNumLabel.text = [NSString stringWithFormat:@"%ld",_musicDetail.zanNum];
    collecNumLabel.text = [NSString stringWithFormat:@"%ld",_musicDetail.fovNum];
    
}
//分享
- (void)handleShareAction:(UIButton *)sender {
    BOOL isShare;
    UMSocialUrlResource * urlResource  = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:self.musicDetail.playURL];
    [UMSocialData defaultData].extConfig.title = _musicDetail.title;
    
    NSDictionary *dic = shareArr[sender.tag-250];
    if (dic[@"type"] == UMShareToWechatSession) {
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,self.itemUid];
        isShare = YES;
    } else if (dic[@"type"] == UMShareToWechatTimeline) {
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,self.itemUid];
        isShare = YES;
    } else if (dic[@"type"] == UMShareToSina) {
        
        [UMSocialData defaultData].extConfig.sinaData.urlResource = urlResource;
        isShare = YES;
    } else if (dic[@"type"] == UMShareToQQ) {
        
        [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,self.itemUid];
        isShare = YES;
    } else if (dic[@"type"] == UMShareToQzone) {
        
        [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,self.itemUid];
        isShare = YES;
    } else if ([dic[@"type"] isEqualToString:@"copy"]) {
        
        [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,_musicDetail.prevItemID];
        [[NSToastManager manager] showtoast:@"复制成功"];
        isShare = NO;
    } else if ([dic[@"type"] isEqualToString:@"poster"]) {
        
        NSSelectLyricsViewController *selectLyricVC = [[NSSelectLyricsViewController alloc] init];
        selectLyricVC.lyrics = self.musicDetail.lyrics;
        selectLyricVC.lyricTitle = self.musicDetail.title;
        selectLyricVC.author = self.musicDetail.author;
        selectLyricVC.themeImg = self.musicDetail.titleImageURL;
        [self.navigationController pushViewController:selectLyricVC animated:YES];
        isShare = NO;
    }
    if (isShare) {
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[dic[@"type"]] content:_musicDetail.author image:[NSData dataWithContentsOfURL:[NSURL URLWithString:_musicDetail.titleImageURL]] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [self tapClick:nil];
                [[NSToastManager manager] showtoast:@"分享成功"];
            }
        }];
    }
    
    
//    if (sender.tag) {
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,self.itemUid];
//        
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:_musicDetail.author image:[NSData dataWithContentsOfURL:[NSURL URLWithString:_musicDetail.titleImageURL]] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
////                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//                [self tapClick:nil];
//                [[NSToastManager manager] showtoast:@"分享成功"];
//            }
//        }];
//    } else if ([sender.currentImage isEqual: [UIImage imageNamed:@"2.0_friends"]]) {
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,self.itemUid];
//        
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:_musicDetail.author image:[NSData dataWithContentsOfURL:[NSURL URLWithString:_musicDetail.titleImageURL]] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
////                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//                [[NSToastManager manager] showtoast:@"分享成功"];
//            }
//        }];
//    } else if ([sender.currentImage isEqual: [UIImage imageNamed:@"2.0_sina"]]) {
//        [UMSocialData defaultData].extConfig.sinaData.urlResource = urlResource;
//        
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",_musicDetail.author ,[NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,self.itemUid]] image:[NSData dataWithContentsOfURL:[NSURL URLWithString:_musicDetail.titleImageURL]] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
////                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//                [[NSToastManager manager] showtoast:@"分享成功"];
//            }
//        }];
//    } else if ([sender.currentImage isEqual: [UIImage imageNamed:@"2.0_qq"]]) {
//        [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,self.itemUid];
//        
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:_musicDetail.author image:[NSData dataWithContentsOfURL:[NSURL URLWithString:_musicDetail.titleImageURL]] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
////                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//                [[NSToastManager manager] showtoast:@"分享成功"];
//            }
//        }];
//    } else if ([sender.currentImage isEqual: [UIImage imageNamed:@"2.0_qZone"]]) {
//        [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,self.itemUid];
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:_musicDetail.author image:_musicDetail.titleImageURL  location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode == UMSResponseCodeSuccess) {
////                [wSelf.navigationController popToRootViewControllerAnimated:YES];
//                [[NSToastManager manager] showtoast:@"分享成功"];
//            }
//        }];
//    } else if ([sender.currentImage isEqual: [UIImage imageNamed:@"2.0_copy"]]) {
//        [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@?id=%ld",_musicDetail.shareURL,_musicDetail.prevItemID];
//        [[NSToastManager manager] showtoast:@"复制成功"];
//    } else if ([sender.currentImage isEqual: [UIImage imageNamed:@"2.0_lyricPoster"]]) {
//        
//        NSSelectLyricsViewController *selectLyricVC = [[NSSelectLyricsViewController alloc] init];
//        selectLyricVC.lyrics = self.musicDetail.lyrics;
//        selectLyricVC.lyricTitle = self.musicDetail.title;
//        selectLyricVC.author = self.musicDetail.author;
//        selectLyricVC.themeImg = self.musicDetail.titleImageURL;
//        [self.navigationController pushViewController:selectLyricVC animated:YES];
//    }
    
}

//播放器
//播放音乐
- (void)playMusicWithUrl:(NSString *)musicUrl{

    
    if (!self.player) {
        
        self.musicItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:musicUrl]];
        
        self.player = [AVPlayer playerWithPlayerItem:self.musicItem];
        
    }
    
    [self.player play];
    
}

//停止音乐
- (void)stopMusic {
    
    if (self.player||self.musicItem) {
        self.musicItem = nil;
        self.player = nil;
    }
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                CHLog(@" 暂停");
                [self playOrPauseBtnClick:self.playOrPauseBtn];
                break;
            case  UIEventSubtypeRemoteControlNextTrack:
                CHLog(@"下一首");
                [self nextBtnClick:nil];
                break;
            default:
                break;
        }
    }
}
- (void)pausePlayer {
    [self removeTimer];
    [self.player pause];
    self.playOrPauseBtn.selected = NO;
}


- (void)dealloc {
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeBtnsState" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pausePlayer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangePlayItemNotification object:nil];

}

@end







