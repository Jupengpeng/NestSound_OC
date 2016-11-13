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
#import "NSNewMusicTableViewCell.h"
#import "NSSearchUserCollectionViewCell.h"
#import "NSPlayMusicViewController.h"
#import "NSLyricViewController.h"
#import "NSLoginViewController.h"
@interface NSSearchViewController () <UIScrollViewDelegate, UISearchBarDelegate, NSSearchMusicTableViewDelegate, NSSearchUserCollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate> {
    
    UIScrollView *_topScrollView;
    
//    UIScrollView *_scrollView;
    
    UIView *_lineView;
    int currentPage;
    long searchType;
    NSString * requestMusicURL;
    NSString * requestUserURL;
    NSMutableArray * musicDataAry;
    NSMutableArray * lyricDataAry;
    NSMutableArray * userDataAry;
    UIImageView *emptyOneImage;
    UIImageView *emptyTwoImage;
    UIImageView *emptyThreeImage;
    NSSearchMusicTableView *searchMusic;
    NSSearchMusicTableView *searchLyric;
    UITableView *musicTableView;
    UITableView *lyricTableView;
    UICollectionView *userCollectionView;
}
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, copy) NSString *name;

@end

static NSString * const musicCellIdentify = @"musicTableCell";
static NSString * const lyricCellIdentify = @"lyricTableCell";
static NSString * const userCellIdentify = @"userCollectionCell";
@implementation NSSearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)fetchData:(NSString *)name {
    
    self.name = name;
    [musicDataAry removeAllObjects];
    [lyricDataAry removeAllObjects];
    [userDataAry removeAllObjects];
    if (self.contentScrollView.contentOffset.x == 0) {
        
        [self fetchDataWithType:1 andIsLoadingMore:NO];
        
    } else if (self.contentScrollView.contentOffset.x == ScreenWidth) {
        [self fetchDataWithType:2 andIsLoadingMore:NO];
    } else {
        [self fetchDataWithType:3 andIsLoadingMore:NO];
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
    
    
    NSDictionary *dic;
    
    if (JUserID) {
        
        dic = @{@"type":@(type),@"fansid":JUserID,@"page":@(currentPage),@"name":self.name};
    } else {
        dic = @{@"type":@(type),@"page":@(currentPage),@"name":self.name};
    }
    
    NSString * str = [NSTool encrytWithDic:dic];
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
    if (requestErr) {
        [musicTableView.pullToRefreshView stopAnimating];
        [lyricTableView.pullToRefreshView stopAnimating];
        [userCollectionView.pullToRefreshView stopAnimating];
        [musicTableView.infiniteScrollingView stopAnimating];
        
    } else {
        if (!parserObject.success) {
            NSSearchUserListModel * searchUser = (NSSearchUserListModel *)parserObject;
            if ([operation.urlTag isEqualToString:requestMusicURL]) {
                if (searchType == 1) {
                    if (!operation.isLoadingMore) {
                        [musicTableView.pullToRefreshView stopAnimating];
                        musicDataAry = [NSMutableArray arrayWithArray:searchUser.searchMusicList];
                    } else {
                        [musicTableView.infiniteScrollingView stopAnimating];
                        [musicDataAry addObjectsFromArray:searchUser.searchMusicList];
                    }
                    if (musicDataAry.count) {
                        emptyOneImage.hidden = YES;
                    } else {
                        emptyOneImage.hidden = NO;
                    }
                    [musicTableView reloadData];
                } else {
                    if (!operation.isLoadingMore) {
                        [lyricTableView.pullToRefreshView stopAnimating];
                        lyricDataAry = [NSMutableArray arrayWithArray:searchUser.searchMusicList];
                    } else {
                        [lyricTableView.infiniteScrollingView stopAnimating];
                        [musicDataAry addObjectsFromArray:searchUser.searchMusicList];
                    }
                    if (lyricDataAry.count) {
                        emptyTwoImage.hidden = YES;
                    } else {
                        emptyTwoImage.hidden = NO;
                    }
                    [lyricTableView reloadData];
                }
                
            }else if ([operation.urlTag isEqualToString:requestUserURL]){
                if (!operation.isLoadingMore) {
                    [userCollectionView.pullToRefreshView stopAnimating];
                    userDataAry = [NSMutableArray arrayWithArray:searchUser.searchUserList];
                } else {
                    [userCollectionView.infiniteScrollingView stopAnimating];
                    [userDataAry addObjectsFromArray:searchUser.searchUserList];
                }
                if (userDataAry.count) {
                    emptyThreeImage.hidden = YES;
                } else {
                    emptyThreeImage.hidden = NO;
                }
                [userCollectionView reloadData];
                
            }
        }
    }
}


#pragma mark -setupUI

- (void)setupUI {
    
    searchType = 1;
    
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
        
        titleBtn.tag = i + 100;
        
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topScrollView addSubview:titleBtn];
    }
    
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topScrollView.height - 3, ScreenWidth / titleArray.count, 3)];
    
    _lineView.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    [_topScrollView addSubview:_lineView];
    
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topScrollView.height, ScreenWidth, self.view.height - _topScrollView.height - 64)];
    
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * titleArray.count, 0);
    
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    
    self.contentScrollView.pagingEnabled = YES;
    
    self.contentScrollView.delegate = self;
    
    [self.view addSubview:self.contentScrollView];
    
    musicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.contentScrollView.frame)) style:UITableViewStylePlain];
    
    musicTableView.delegate = self;
    
    musicTableView.dataSource = self;
    
    musicTableView.rowHeight = 80;
    
    musicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    musicTableView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [musicTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:musicCellIdentify];
    
    [self.contentScrollView addSubview:musicTableView];
    
    emptyOneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyOneImage.hidden = YES;
    
    emptyOneImage.centerX = ScreenWidth/2;
    
    emptyOneImage.y = 100;
    
    [self.contentScrollView addSubview:emptyOneImage];
    
    WS(Wself);
    //refresh
    [musicTableView addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            [Wself fetchDataWithType:1 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [musicTableView addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fetchDataWithType:1 andIsLoadingMore:YES];
    }];
    //歌词
    lyricTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.contentScrollView.frame)) style:UITableViewStylePlain];
    
    lyricTableView.delegate = self;
    
    lyricTableView.dataSource= self;
    
    lyricTableView.rowHeight = 80;
    
    lyricTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    lyricTableView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [lyricTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:lyricCellIdentify];
    
    [self.contentScrollView addSubview:lyricTableView];
    
    emptyTwoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyTwoImage.hidden = YES;
    
    emptyTwoImage.centerX = 3*ScreenWidth/2;
    
    emptyTwoImage.y = 100;
    
    [self.contentScrollView addSubview:emptyTwoImage];
    
    //refresh
    [lyricTableView addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            [Wself fetchDataWithType:2 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [lyricTableView addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fetchDataWithType:2 andIsLoadingMore:YES];
    }];
    //用户
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 10;
    
    layout.minimumInteritemSpacing = 10;
    
    CGFloat itemW = (ScreenWidth - 50) / 3;
    
    layout.itemSize = CGSizeMake(itemW, itemW + itemW / 3);
    
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
    
    userCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(2 * ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.contentScrollView.frame)) collectionViewLayout:layout];
    
    userCollectionView.dataSource = self;
    
    userCollectionView.delegate = self;
    
    userCollectionView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [userCollectionView registerClass:[NSSearchUserCollectionViewCell class] forCellWithReuseIdentifier:userCellIdentify];
    
    [self.contentScrollView addSubview:userCollectionView];
    
    //refresh
    [userCollectionView addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            [Wself fetchDataWithType:3 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [userCollectionView addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fetchDataWithType:3 andIsLoadingMore:YES];
    }];
//    [self setupContent];
    emptyThreeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyThreeImage.hidden = YES;
    
    emptyThreeImage.centerX = 5*ScreenWidth/2;
    
    emptyThreeImage.y = 100;
    
    [self.contentScrollView addSubview:emptyThreeImage];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  searchType == 1 ? musicDataAry.count : lyricDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == musicTableView) {
        
        NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:musicCellIdentify forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
        
        cell.myMusicModel = musicDataAry[indexPath.row];
        cell.secretImgView.hidden = YES;
        return cell;
    } else {
        NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyricCellIdentify forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
        
        cell.myMusicModel = lyricDataAry[indexPath.row];
        cell.secretImgView.hidden = YES;
        return cell;
    }
    
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == musicTableView) {
        NSMyMusicModel *model = musicDataAry[indexPath.row];
        if ([self.delegate1 respondsToSelector:@selector(searchMusicViewController:withItemId:withType:)]) {
            
            [self.delegate1 searchMusicViewController:self withItemId:model.itemId withType:model.type];
        }
        
    } else if (tableView == lyricTableView) {
        NSMyMusicModel *model = lyricDataAry[indexPath.row];
        if ([self.delegate1 respondsToSelector:@selector(searchLyricViewController:withItemId:)]) {
            
            [self.delegate1 searchLyricViewController:self withItemId:model.itemId];
        }
        
    }
}
#pragma mark - UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return userDataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSSearchUserModel * user = userDataAry[indexPath.row];
    
    NSSearchUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userCellIdentify forIndexPath:indexPath];
    
    cell.searchUser = user;
    return cell;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSSearchUserModel * user = userDataAry[indexPath.row];

    if ([self.delegate1 respondsToSelector:@selector(searchViewController:withUserID:)]) {
        
        [self.delegate1 searchViewController:self withUserID:user.userID];
    }
}



- (void)setupContent {
    searchType = 1;
    //歌曲
    searchMusic = [[NSSearchMusicTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.contentScrollView.height)];
    
    searchMusic.tag = 1;
    searchMusic.DataAry = musicDataAry;
    searchMusic.delegate1 = self;
    
    [self.contentScrollView addSubview:searchMusic];
    
    //歌词
    searchLyric = [[NSSearchMusicTableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.contentScrollView.height)];
    
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
    
    [self.contentScrollView setContentOffset:CGPointMake(ScreenWidth * (titleBtn.tag-100), 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.x = titleBtn.width * (titleBtn.tag-100);
    }];
    searchType = titleBtn.tag - 99;
    
    if (titleBtn.tag == 100) {
        if (musicDataAry.count) {
            [musicTableView reloadData];
        } else {
            [self fetchDataWithType:1 andIsLoadingMore:NO];
        }
    } else if (titleBtn.tag == 101) {
        if (lyricDataAry.count) {
            [lyricTableView reloadData];
        } else {
            [self fetchDataWithType:2 andIsLoadingMore:NO];
        }
    } else {
        if (userDataAry.count) {
            [userCollectionView reloadData];
        } else {
            [self fetchDataWithType:3 andIsLoadingMore:NO];
        }
    }
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        _lineView.x = scrollView.contentOffset.x / ScreenWidth * _lineView.width;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.contentScrollView) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:scrollView.contentOffset.x / ScreenWidth + 100];
        [self titleBtnClick:btn];
//        if (scrollView.contentOffset.x == 0) {
//            searchType = 1;
//            if (musicDataAry.count) {
//                [musicTableView reloadData];
//            } else {
//                [self fetchDataWithType:1 andIsLoadingMore:NO];
//            }
//        } else if (scrollView.contentOffset.x == ScreenWidth) {
//            searchType = 2;
//            if (lyricDataAry.count) {
//                [lyricTableView reloadData];
//            } else {
//                [self fetchDataWithType:2 andIsLoadingMore:NO];
//            }
//        } else {
//            searchType = 3;
//            [self fetchDataWithType:3 andIsLoadingMore:NO];
//        }
    }
    
}


- (void)searchMusicTableView:(NSSearchMusicTableView *)tableView withItemId:(long)itemID {
    
    if ([self.delegate1 respondsToSelector:@selector(searchMusicViewController:withItemId:withType:)]) {
        
        [self.delegate1 searchMusicViewController:self withItemId:itemID withType:1];
    }
    
}

- (void)searchLyricTableView:(NSSearchMusicTableView *)tableView withItemId:(long)itemID {
    
    if ([self.delegate1 respondsToSelector:@selector(searchLyricViewController:withItemId:)]) {
        
        [self.delegate1 searchLyricViewController:self withItemId:itemID];
    }
    
}

- (void)searchUserCollectionView:(NSSearchUserCollectionView *)collectionView withUserID:(long)userID {
    
    if ([self.delegate1 respondsToSelector:@selector(searchViewController:withUserID:)]) {
        
        [self.delegate1 searchViewController:self withUserID:userID];
    }
    
}

@end
