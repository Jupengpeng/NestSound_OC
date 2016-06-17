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
#import "NSDiscoverMoreLyricModel.h"
#import "NSSearchUserListModel.h"
#import "NSUserPageViewController.h"
@interface NSSearchViewController () <UIScrollViewDelegate, UISearchBarDelegate, NSSearchMusicTableViewDelegate, NSSearchUserCollectionViewDelegate> {
    
    UIScrollView *_topScrollView;
    
//    UIScrollView *_scrollView;
    
    UIView *_lineView;
    int currentPage;
    NSString * requestMusicURL;
    NSString * requestUserURL;
    NSMutableArray * musicDataAry;
    NSMutableArray * userDataAry;
}
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, copy) NSString *name;

@end

@implementation NSSearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}



- (void)fetchData:(NSString *)name {
    
    self.name = name;
    
    if (self.contentScrollView.contentOffset.x == 0) {
        
        [self fetchDataWithType:1 andIsLoadingMore:NO];
        
        NSLog(@"这是搜索的歌曲");
    } else if (self.contentScrollView.contentOffset.x == ScreenWidth) {
        [self fetchDataWithType:2 andIsLoadingMore:NO];
        NSLog(@"这是搜索的歌词");
    } else {
        [self fetchDataWithType:3 andIsLoadingMore:NO];
        NSLog(@"这是搜索的用户");
    }
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
    NSDictionary * dic = @{@"type":@(type),@"fansid":JUserID,@"page":@(currentPage),@"name":self.name};
    NSString * str = [NSTool encrytWithDic:dic];
    NSLog(@"%@",dic);
    NSLog(@"%@",str);
    if (type == 1|| type == 2) {
        requestMusicURL = [searchURL stringByAppendingString:str];
        self.requestURL = requestMusicURL;
    }else{
        requestUserURL = [searchURL stringByAppendingString:str];
        self.requestURL = requestUserURL;
    }
    
    
}


#pragma mark - override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
          NSSearchUserListModel * searchUser = (NSSearchUserListModel *)parserObject;
        if ([operation.urlTag isEqualToString:requestMusicURL]) {
            
            musicDataAry = [NSMutableArray arrayWithArray:searchUser.searchMusicList];
        }else if ([operation.urlTag isEqualToString:requestUserURL]){
          
            userDataAry = [NSMutableArray arrayWithArray:searchUser.searchUserList];
            
        }
        [self setupContent];
    }

}


#pragma mark -setupUI

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
    
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topScrollView.height, ScreenWidth, self.view.height - _topScrollView.height - 64)];
    
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * titleArray.count, 0);
    
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    
    self.contentScrollView.pagingEnabled = YES;
    
    self.contentScrollView.delegate = self;
    
    [self.view addSubview:self.contentScrollView];
    
    [self setupContent];
    
    
}



- (void)setupContent {
    
    //歌曲
    NSSearchMusicTableView *searchMusic = [[NSSearchMusicTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.contentScrollView.height)];
    
    searchMusic.tag = 1;
    searchMusic.DataAry = musicDataAry;
    searchMusic.delegate1 = self;
    
    [self.contentScrollView addSubview:searchMusic];
    
    //歌词
    NSSearchMusicTableView *searchLyric = [[NSSearchMusicTableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.contentScrollView.height)];
    
    searchLyric.tag = 2;
    searchLyric.DataAry = musicDataAry;
    searchLyric.delegate1 = self;
    
    [self.contentScrollView addSubview:searchLyric];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 10;
    
    layout.minimumInteritemSpacing = 10;
    
    CGFloat itemW = (ScreenWidth - 60) / 4;
    
    layout.itemSize = CGSizeMake(itemW, itemW + itemW / 3);
    
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
    
    NSSearchUserCollectionView *searchUser = [[NSSearchUserCollectionView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, self.contentScrollView.height) collectionViewLayout:layout];
    searchUser.delegate1 = self;
    searchUser.dataAry = userDataAry;
    [self.contentScrollView addSubview:searchUser];
    
    
    
}




- (void)titleBtnClick:(UIButton *)titleBtn {
    
    [self.contentScrollView setContentOffset:CGPointMake(ScreenWidth * titleBtn.tag, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.x = titleBtn.width * titleBtn.tag;
    }];
    
    
    if (titleBtn.tag == 0) {
        [self fetchDataWithType:1 andIsLoadingMore:NO];
        NSLog(@"这是搜索的歌曲");
    } else if (titleBtn.tag == 1) {
        [self fetchDataWithType:2 andIsLoadingMore:NO];

        NSLog(@"这是搜索的歌词");
    } else {
          [self fetchDataWithType:3 andIsLoadingMore:NO];
        NSLog(@"这是搜索的用户");
    }
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _lineView.x = scrollView.contentOffset.x / ScreenWidth * _lineView.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == 0) {
        [self fetchDataWithType:1 andIsLoadingMore:NO];
        NSLog(@"这是搜索的歌曲");
    } else if (scrollView.contentOffset.x == ScreenWidth) {
        [self fetchDataWithType:2 andIsLoadingMore:NO];
        NSLog(@"这是搜索的歌词");
    } else {
         [self fetchDataWithType:3 andIsLoadingMore:NO];
        NSLog(@"这是搜索的用户");
    }
}


- (void)searchMusicTableView:(NSSearchMusicTableView *)tableView {
    
    if ([self.delegate1 respondsToSelector:@selector(searchMusicTableView:)]) {
        
        [self.delegate1 searchMusicTableView:self];
    }
    
    NSLog(@"歌曲");
}

- (void)searchLyricTableView:(NSSearchMusicTableView *)tableView {
    
    if ([self.delegate1 respondsToSelector:@selector(searchLyricTableView:)]) {
        
        [self.delegate1 searchLyricTableView:self];
    }
    
    NSLog(@"歌词");
}

- (void)searchUserCollectionView:(NSSearchUserCollectionView *)collectionView withUserID:(long)userID {
    
    if ([self.delegate1 respondsToSelector:@selector(searchViewController:withUserID:)]) {
        
        [self.delegate1 searchViewController:self withUserID:userID];
    }
    
    NSLog(@"用户");
}

@end
