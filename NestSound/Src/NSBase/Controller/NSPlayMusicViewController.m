//
//  NSPlayMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPlayMusicViewController.h"
#import "NSPlayMusicTool.h"

@interface NSPlayMusicViewController ()

@property (nonatomic, weak) UIButton *playOrPauseBtn;

@end
#warning mark 给评论数赋值的时候别忘了删掉下面这行代码
static NSString *num = @"7473";
@implementation NSPlayMusicViewController


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        self.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        
        [window addSubview:self.view];
    }
    
    return self;
}

- (void)showPlayMusic {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.y = 0;
        
    }];
        
    [NSPlayMusicTool playMusicWithName:@"悟空.mp3"];
    
    self.playOrPauseBtn.selected = YES;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image  = [UIImage imageNamed:@"img_05"];
    
    image = [image applyBlurWithRadius:8 tintColor:[UIColor colorWithWhite:1.0 alpha:0.3] saturationDeltaFactor:1.8 maskImage:nil];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    backgroundImage.image = image;
    
    
    UIImageView *transparentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_background_transparent"]];
    
    transparentImage.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [backgroundImage addSubview:transparentImage];
    
    
    [self.view addSubview:backgroundImage];
    
    
    [self setupUI];
    
}


- (void)setupUI {
    
    WS(wSelf);
    
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_dismiss"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            wSelf.view.y = ScreenHeight;
        }];
        
    }];
    
    [self.view addSubview:dismissBtn];
    
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(15);
        
        make.top.equalTo(self.view.mas_top).offset(32);
        
    }];
    
    
    //歌名
    UILabel *songName = [[UILabel alloc] init];
    
    songName.textColor = [UIColor whiteColor];
    
    songName.text = @"我在那一角落患过伤风";
    
    [self.view addSubview:songName];
    
    [songName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(32);
        
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
    //分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
       
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_share"] forState:UIControlStateNormal];
        
        
    } action:^(UIButton *btn) {
        
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
            
            [NSPlayMusicTool playMusicWithName:@"悟空.mp3"];
        } else {
            
            [NSPlayMusicTool pauseMusicWithName:@"悟空.mp3"];
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
        
        [NSPlayMusicTool stopMusicWithName:@"我的天空.mp3"];
        
        [NSPlayMusicTool playMusicWithName:@"悟空.mp3"];
        
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
        
        [NSPlayMusicTool stopMusicWithName:@"悟空.mp3"];
        
        [NSPlayMusicTool playMusicWithName:@"我的天空.mp3"];
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
    
    playtime.text = @"00:36";
    
    [self.view addSubview:playtime];
    
    [playtime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(15);
        
        make.bottom.equalTo(playOrPauseBtn.mas_top).offset(-20);
        
    }];
    
    
    //总时间
    UILabel *totaltime = [[UILabel alloc] init];
    
    totaltime.textColor = [UIColor whiteColor];
    
    totaltime.font = [UIFont systemFontOfSize:10];
    
    totaltime.text = @"03:47";
    
    [self.view addSubview:totaltime];
    
    [totaltime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        make.bottom.equalTo(playOrPauseBtn.mas_top).offset(-20);
        
    }];
    
    
//    //总进度条
//    UIView *totalProgressBar = [[UIView alloc] init];
//    
//    totalProgressBar.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:totalProgressBar];
//    
//    [totalProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(playtime.mas_right).offset(10);
//        
//        make.right.equalTo(totaltime.mas_left).offset(-10);
//        
//        make.centerY.equalTo(playtime.mas_centerY);
//        
//        make.height.mas_equalTo(2);
//        
//    }];
//    
//    
//    
//    //进度条
//    UIView *progressBar = [[UIView alloc] init];
//    
//    progressBar.backgroundColor = [UIColor hexColorFloat:@"ffce00"];
//    
//    [self.view addSubview:progressBar];
//    
//    [progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(totalProgressBar.mas_left);
//        
//        make.width.mas_equalTo(10);
//        
//        make.centerY.equalTo(totalProgressBar.mas_centerY);
//        
//        make.height.mas_equalTo(2);
//        
//    }];
    
    
    //进度条
    UISlider *progressBar = [[UISlider alloc] init];
    
    [progressBar setThumbImage:[UIImage imageNamed:@"2.0_playSongs_dot"] forState:UIControlStateNormal];
    
    progressBar.minimumTrackTintColor = [UIColor hexColorFloat:@"ffce00"];
    
    progressBar.maximumTrackTintColor = [UIColor whiteColor];
    
    [progressBar addTarget:self action:@selector(progressBarSlither:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:progressBar];
    
    [progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(playtime.mas_right).offset(10);
        
        make.right.equalTo(totaltime.mas_left).offset(-10);
        
        make.centerY.equalTo(playtime.mas_centerY);
        
    }];
    
    
    //四个按钮的间距
    CGFloat margin = (ScreenWidth - 220) / 3;
    
    //收藏
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_collection_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_collection_selected"] forState:UIControlStateSelected];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
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
    UIButton *upVoteBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_upvote_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_upvote_selected"] forState:UIControlStateSelected];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
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
    
    if ([num intValue] > 999) {
        
        numLabel.text = @"999+";
        
    } else if ([num intValue] < 1) {
        
        [commentBtn setImage:[UIImage imageNamed:@"2.0_noComment"] forState:UIControlStateNormal];
        
    } else {
        
        numLabel.text = num;
        
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
        
        NSLog(@"点击了播放页的更多");
    }];
    
    [self.view addSubview:moreBtn];
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-50);
        
        make.centerY.equalTo(collectionBtn.mas_centerY);
        
        make.width.mas_equalTo(30);
        
        make.height.mas_equalTo(30);
    }];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, ScreenHeight - 270)];
    
    scrollView.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:scrollView];
    
    NSLog(@"%@",NSStringFromCGRect(collectionBtn.frame));
}

- (void)progressBarSlither:(UISlider *)progressBar {
    
    NSLog(@"%f",progressBar.value);
}



@end







