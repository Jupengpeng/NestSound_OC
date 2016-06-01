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

@interface NSDiscoverViewController () <UIScrollViewDelegate, UISearchBarDelegate> {
    
    UIScrollView *_topScrollView;
    
    UIScrollView *_scrollView;
    
    UIView *_lineView;
    
    UISearchBar *_search;
    
    UIView *_maskView;
    NSActivityViewController *activity;
    NSMusicViewController *music;
    NSMusicViewController *lyric;
    NSMusicListViewController *list;
}

@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;


@property (nonatomic, strong) NSSearchViewController *searchVC;

@end

@implementation NSDiscoverViewController

//- (NSPlayMusicViewController *)playSongsVC {
//    
//    if (!_playSongsVC) {
//        
//        _playSongsVC = [NSPlayMusicViewController sharedPlayMusic];
//        
//    }
//    
//    return _playSongsVC;
//}

- (NSSearchViewController *)searchVC {
    
    if (!_searchVC) {
        
        _searchVC = [[NSSearchViewController alloc] init];
        
    }
    
    return _searchVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_musicNote"] style:UIBarButtonItemStylePlain target:self action:@selector(musicPaly:)];
    
    
    _search = [[UISearchBar alloc] init];
    
    _search.delegate = self;
    
    _search.placeholder = @"搜索";
    
    self.navigationItem.titleView = _search;
    
    
    [self setupUI];
    
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    
    _maskView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    _maskView.alpha = 0;
    
    [self.tabBarController.view addSubview:_maskView];
    

    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [_search setShowsCancelButton:YES animated:YES];
    
    _maskView.alpha = 1;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    NSLog(@"进入搜索编辑");

    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [_search setShowsCancelButton:NO animated:YES];
    
    _maskView.alpha = 0;
    
    [_search resignFirstResponder];
    
    _search.text = nil;
    
    [_maskView removeAllSubviews];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_musicNote"] style:UIBarButtonItemStylePlain target:self action:@selector(musicPaly:)];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [_search resignFirstResponder];
    
    [_maskView addSubview:self.searchVC.view];
    
    NSLog(@"点击搜索");
    
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
    
    _lineView.backgroundColor = [UIColor orangeColor];
    
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
    
    activity.view.frame = CGRectMake(0, _scrollView.y, ScreenWidth, _scrollView.height);
    
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
        
        NSLog(@"没有音乐");
        
    } else {
        
        if (self.playSongsVC.player.playing) {
            
            
        }
        
        
        
        [self.navigationController pushViewController:self.playSongsVC animated:YES];
    }
    
    
}



@end









