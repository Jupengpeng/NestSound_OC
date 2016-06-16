//
//  NSSearchViewController.m
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSearchViewController.h"
#import "NSMusicViewController.h"
#import "NSSearchMusicTableView.h"
#import "NSSearchUserCollectionView.h"

@interface NSSearchViewController () <UIScrollViewDelegate, UISearchBarDelegate> {
    
    UIScrollView *_topScrollView;
    
    UIScrollView *_scrollView;
    
    UIView *_lineView;
    int currentPage;
    NSString * requestMusicURL;
    NSString * requestUserURL;
}


@end

@implementation NSSearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
}


-(void)fetchDataWithType:(int)type andIsLoadingMore:(BOOL)isLoadingMore
{
    self.requestType = YES;
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{kIsLoadingMore:@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
//    if (type == 1|| type == 2) {
//        
//            requestMusicURL =
//    }else{
//    
//    }
    
}

- (void)setupUI {
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 33)];
    
    _topScrollView.contentSize = CGSizeZero;
    
    [self.view addSubview:_topScrollView];
    
    NSArray *titleArray = @[@"歌曲",@"歌词",@"用户"];
    
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
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topScrollView.height, ScreenWidth, self.view.height - _topScrollView.height - 64)];
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth * titleArray.count, 0);
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    [self setupContent];
    
    
}



- (void)setupContent {
    
    //歌曲
    NSSearchMusicTableView *searchMusic = [[NSSearchMusicTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _scrollView.height)];
    
    searchMusic.tag = 1;
    
    [_scrollView addSubview:searchMusic];
    
    //歌词
    NSSearchMusicTableView *searchLyric = [[NSSearchMusicTableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, _scrollView.height)];
    
    searchLyric.tag = 2;
    
    [_scrollView addSubview:searchLyric];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 10;
    
    layout.minimumInteritemSpacing = 10;
    
    CGFloat itemW = (ScreenWidth - 60) / 4;
    
    layout.itemSize = CGSizeMake(itemW, itemW + itemW / 3);
    
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
    
    NSSearchUserCollectionView *searchUser = [[NSSearchUserCollectionView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, _scrollView.height) collectionViewLayout:layout];
    
    [_scrollView addSubview:searchUser];
    
    
    
}




- (void)titleBtnClick:(UIButton *)titleBtn {
    
    [_scrollView setContentOffset:CGPointMake(ScreenWidth * titleBtn.tag, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.x = titleBtn.width * titleBtn.tag;
    }];
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _lineView.x = scrollView.contentOffset.x / ScreenWidth * _lineView.width;
}


@end
