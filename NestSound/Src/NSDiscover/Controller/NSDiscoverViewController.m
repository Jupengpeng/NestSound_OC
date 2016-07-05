//
//  NSDiscoverViewController.m
//  NestSound
//
//  Created by Apple on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDiscoverViewController.h"
#import "NSMusicViewController.h"
#import "NSMusicListViewController.h"
#import "NSActivityViewController.h"
#import "NSPlayMusicViewController.h"
#import "NSSearchViewController.h"
#import "NSUserPageViewController.h"
#import "NSLyricViewController.h"
#import "NSLoginViewController.h"

@interface NSDiscoverViewController () <UIScrollViewDelegate, UISearchBarDelegate, NSSearchViewControllerDelegate> {
    
    UIScrollView *_topScrollView;
    
    UIScrollView *_scrollView;
    
    UIView *_lineView;
    
    UISearchBar *_search;
    UIImageView * playStatus;
    
//    UIView *_maskView;
    
    NSActivityViewController *activity;
    NSMusicViewController *music;
    NSMusicViewController *lyric;
    NSMusicListViewController *list;
}

@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;

@property (nonatomic, strong) NSSearchViewController *searchVC;

@property (nonatomic, strong) UIView *maskView;

@end

@implementation NSDiscoverViewController

- (NSPlayMusicViewController *)playSongsVC {
    
    if (!_playSongsVC) {
        
        _playSongsVC = [NSPlayMusicViewController sharedPlayMusic];
        
    }
    
    return _playSongsVC;
}

- (NSSearchViewController *)searchVC {
    
    if (!_searchVC) {
        
        _searchVC = [[NSSearchViewController alloc] init];
        
        _searchVC.delegate1 = self;
    }
    
    return _searchVC;
    
}

- (UIView *)maskView {
    
    if (!_maskView) {
        
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
        
        _maskView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
        
        _maskView.alpha = 0;
        
        [self.tabBarController.view addSubview:_maskView];
    }
    
    return _maskView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    if (self.playSongsVC.player == nil) {
        
    } else {
        
        if (self.playSongsVC.player.rate != 0.0) {
            [playStatus startAnimating];
        }else{
            [playStatus stopAnimating];
        }
    }


}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    playStatus  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 21)];
    
    playStatus.animationDuration = 0.8;
    playStatus.animationImages = @[[UIImage imageNamed:@"2.0_play_status_1"],
                                   [UIImage imageNamed:@"2.0_play_status_2"],
                                   [UIImage imageNamed:@"2.0_play_status_3"],
                                   [UIImage imageNamed:@"2.0_play_status_4"],
                                   [UIImage imageNamed:@"2.0_play_status_5"],
                                   [UIImage imageNamed:@"2.0_play_status_6"],
                                   [UIImage imageNamed:@"2.0_play_status_7"],
                                   [UIImage imageNamed:@"2.0_play_status_8"],
                                   [UIImage imageNamed:@"2.0_play_status_9"],
                                   [UIImage imageNamed:@"2.0_play_status_10"],
                                   [UIImage imageNamed:@"2.0_play_status_11"],
                                   [UIImage imageNamed:@"2.0_play_status_12"],
                                   [UIImage imageNamed:@"2.0_play_status_13"],
                                   [UIImage imageNamed:@"2.0_play_status_14"],
                                   [UIImage imageNamed:@"2.0_play_status_15"],
                                   [UIImage imageNamed:@"2.0_play_status_16"]];
    
    [playStatus stopAnimating];
    playStatus.userInteractionEnabled = YES;
    playStatus.image = [UIImage imageNamed:@"2.0_play_status_1"];
    UIButton * btn = [[UIButton alloc] initWithFrame:playStatus.frame ];
    [playStatus addSubview:btn];
    [btn addTarget:self action:@selector(musicPaly:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:playStatus];
    
    self.navigationItem.rightBarButtonItem = item;
    
    _search = [[UISearchBar alloc] init];
    
    _search.delegate = self;
    
    _search.placeholder = @"搜索";
    
    self.navigationItem.titleView = _search;
    
    
    [self setupUI];
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [_search setShowsCancelButton:YES animated:YES];
    
    self.maskView.alpha = 1;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.tabBarController.tabBar.hidden = YES;
    

    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [_search setShowsCancelButton:NO animated:YES];
    
    self.maskView.alpha = 0;
    
    [_search resignFirstResponder];
    
    _search.text = nil;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.maskView removeAllSubviews];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_musicNote"] style:UIBarButtonItemStylePlain target:self action:@selector(musicPaly:)];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [_search resignFirstResponder];
    
    [self.maskView addSubview:self.searchVC.view];
    
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    
    cancelBtn.enabled = YES; //把enabled设置为yes
    
    [self.searchVC fetchData:searchBar.text];
    
    
}


- (void)setupUI {
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 33)];
    
    _topScrollView.contentSize = CGSizeZero;
    
    [self.view addSubview:_topScrollView];
    
    NSArray *titleArray = @[@"活动",@"歌曲",@"歌词",@"榜单"];
    
    CGFloat W = ScreenWidth / titleArray.count;
    
    CGFloat H = _topScrollView.height;
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(W * i, 0, W, H)];
        
        [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        titleBtn.tag = i;
        
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topScrollView addSubview:titleBtn];
    }
    
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topScrollView.height - 3, ScreenWidth / titleArray.count, 3)];
    
    _lineView.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    [_topScrollView addSubview:_lineView];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topScrollView.height, ScreenWidth, self.view.height - _topScrollView.height - 113)];
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth * titleArray.count, 0);
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.pagingEnabled = YES;
    
//    _scrollView.bounces = NO;
    
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    [self setupContent];
    
    
}



- (void)setupContent {
    
    //活动
   activity = [[NSActivityViewController alloc] init];
    
    activity.view.frame = CGRectMake(0, 10, ScreenWidth, _scrollView.height);
    
    [self addChildViewController:activity];
    
    [_scrollView  addSubview:activity.view];
    
    //歌曲
    music = [[NSMusicViewController alloc] initWithIsMusic:YES];
    
    music.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, _scrollView.height);
    
    music.topTitle = LocalizedStr(@"热门歌曲");
    
    music.bottomTitle = LocalizedStr(@"最新歌曲");
    
    [self addChildViewController:music];
    
//    [_scrollView addSubview:music.view];
    
    //歌词
    
    lyric = [[NSMusicViewController alloc] initWithIsMusic:NO];
    
    lyric.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, _scrollView.height);
    
    lyric.topTitle = LocalizedStr(@"热门歌词");
    
    lyric.bottomTitle = LocalizedStr(@"最新歌词");
    
    [self addChildViewController:lyric];
    
   // [_scrollView addSubview:lyric.view];
    
    
    //榜单
    list = [[NSMusicListViewController alloc] init];
    
    list.view.frame = CGRectMake(ScreenWidth * 3, 0, ScreenWidth, _scrollView.height);
    
    [self addChildViewController:list];
    
//    [_scrollView addSubview:list.view];
    
    
}



- (void)titleBtnClick:(UIButton *)titleBtn {
    
    if (titleBtn.tag == 0) {
        
        NSLog(@"点击了活动");
       
    } else if(titleBtn.tag == 1) {
        
        NSLog(@"点击了歌曲");
    } else if (titleBtn.tag == 2) {
        
        NSLog(@"点击了歌词");
    } else {
        
        NSLog(@"点击了榜单");
    }
    
    [_scrollView setContentOffset:CGPointMake(ScreenWidth * titleBtn.tag, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.x = titleBtn.width * titleBtn.tag;
    }];
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _lineView.x = scrollView.contentOffset.x / ScreenWidth * _lineView.width;
    if (scrollView.contentOffset.x/ScreenWidth == 1) {
        [_scrollView addSubview:music.view];
    }
    else if(scrollView.contentOffset.x/ScreenWidth == 2){
        [_scrollView addSubview:lyric.view];
    }else if(scrollView.contentOffset.x /ScreenWidth == 3){
        [_scrollView addSubview:list.view];
    }
}




- (void)musicPaly:(UIBarButtonItem *)palyItem {
    
    if (self.playSongsVC.player == nil) {
        [[NSToastManager manager] showtoast:@"您还没有听过什么歌曲哟"];
    } else {
        
        [self.navigationController pushViewController:self.playSongsVC animated:YES];
    }
    
}


- (void)searchMusicViewController:(NSSearchViewController *)searchVC withItemId:(long)itemID {
    [self searchBarCancelButtonClicked:_search];
    NSPlayMusicViewController *playMusicVC = [NSPlayMusicViewController sharedPlayMusic] ;
    playMusicVC.itemUid = itemID;
    playMusicVC.from = @"homepage";
    playMusicVC.geDanID = 0;
    
    [self.navigationController pushViewController:playMusicVC animated:YES];
    
    NSLog(@"歌曲");
}

- (void)searchLyricViewController:(NSSearchViewController *)searchVC withItemId:(long)itemID {
    [self searchBarCancelButtonClicked:_search];
    NSLyricViewController *lyricVC = [[NSLyricViewController alloc] initWithItemId:itemID];
    
    [self.navigationController pushViewController:lyricVC animated:YES];
    
    NSLog(@"歌词");
}

- (void)searchViewController:(NSSearchViewController *)searchVC withUserID:(long)userID {
    
    if (JUserID) {
        
        [self searchBarCancelButtonClicked:_search];
        
        NSUserPageViewController *userPage = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",userID]];
        userPage.who = Other;
        
        [self.navigationController pushViewController: userPage animated:YES];
        
    } else {
        
        NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
}
@end









