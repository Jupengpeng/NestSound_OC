//
//  NSDiscoverViewController.m
//  NestSound
//
//  Created by Apple on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDiscoverViewController.h"
#import "NSMusicViewController.h"
#import "NSActivityViewController.h"
#import "NSDiscoverLyricViewCOntroller.h"
#import "NSMusicListViewController.h"

@interface NSDiscoverViewController () <UIScrollViewDelegate, UISearchBarDelegate> {
    
    UIScrollView *_topScrollView;
    
    UIScrollView *_scrollView;
    
    UIView *_lineView;
    
    UISearchBar *_search;
    
    UIView *_maskView;
    NSActivityViewController *activity;
    NSMusicViewController *music;
    NSDiscoverLyricViewCOntroller *lyric;
    NSMusicListViewController *list;
}

@end

@implementation NSDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _search = [[UISearchBar alloc] init];
    
    _search.delegate = self;
    
    _search.placeholder = @"搜索";
    
    self.navigationItem.titleView = _search;
    
    
    
    [self setupUI];
    
    
    _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    _maskView.backgroundColor = [UIColor darkGrayColor];
    
    _maskView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    [_maskView addGestureRecognizer:tap];
    
    [self.view addSubview:_maskView];
    

    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [_search setShowsCancelButton:YES animated:YES];
    
    _maskView.alpha = 0.5;
    
    NSLog(@"进入编辑");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [_search setShowsCancelButton:NO animated:YES];
    
    _maskView.alpha = 0;
    
    [_search resignFirstResponder];
}

- (void)tapClick:(UIGestureRecognizer *)tap {
    
    _maskView.alpha = 0;
    
    [_search setShowsCancelButton:NO animated:YES];
    
    [_search resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    _maskView.alpha = 0;
    
    [_search setShowsCancelButton:NO animated:YES];
    
    [_search resignFirstResponder];
    
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
    music = [[NSMusicViewController alloc] init];
    
    music.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, _scrollView.height);
    
    [self addChildViewController:music];
    
//    [_scrollView addSubview:music.view];
    
    //歌词
    lyric = [[NSDiscoverLyricViewCOntroller alloc] init];
    
    lyric.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, _scrollView.height);
    
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


@end









