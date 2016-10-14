//
//  NSPreserveSelectViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/20.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveSelectViewController.h"
#import "NSPreserveApplyController.h"
#import "NSUnPreserveListModel.h"
@interface NSPreserveSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_topScrollView;
    UITableView *musicTableView;
    UITableView *lyricTableView;
    UIView *_lineView;
    int currentPage;
    NSString *url;
    long productType;
    UIImageView *musicEmptyImage;
    UIImageView *lyricEmptyImage;
}
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *musicDataAry;
@property (nonatomic, strong) NSMutableArray *lyricDataAry;
@end
static NSString * const productCellIdentifier = @"productCellIdentifier";
@implementation NSPreserveSelectViewController
- (NSMutableArray *)dataArr {
    if (!_musicDataAry) {
        self.musicDataAry = [NSMutableArray array];
    }
    return _musicDataAry;
}
- (NSMutableArray *)lyricDataAry {
    if (!_lyricDataAry) {
        self.lyricDataAry = [NSMutableArray array];
    }
    return _lyricDataAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configurePreserveSelectView];
    
    [self fectProductDataWithProductType:1 IsLoadingMore:NO];
}
- (void)fectProductDataWithProductType:(long)type IsLoadingMore:(BOOL)isLoadingMore {
    self.requestType = NO;
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{kIsLoadingMore :@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
//    @"page":[NSNumber numberWithInt:currentPage],
    self.requestParams = @{@"uid":JUserID,@"token":LoginToken,@"sort_id":[NSNumber numberWithLong:type],@"page":[NSNumber numberWithInt:currentPage]};
 
    self.requestURL = unPreservedListUrl;
}
#pragma mark -override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if ( requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:unPreservedListUrl]) {
                
                NSUnPreserveListModel * unPreserveModel = (NSUnPreserveListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    if (productType == 1) {
                        [musicTableView.pullToRefreshView stopAnimating];

                        self.musicDataAry = [NSMutableArray arrayWithArray:unPreserveModel.unPreserveList];
 
                    } else {
                        [lyricTableView.pullToRefreshView stopAnimating];
                        self.lyricDataAry = [NSMutableArray arrayWithArray:unPreserveModel.unPreserveList];
                    }
                    
                }else{
                    if (productType == 1) {
                        [musicTableView.infiniteScrollingView stopAnimating];
                        [self.musicDataAry addObjectsFromArray:unPreserveModel.unPreserveList];
                    } else {
                        [lyricTableView.infiniteScrollingView stopAnimating];
                        [self.lyricDataAry addObjectsFromArray:unPreserveModel.unPreserveList];
                    }
                    
                }
                if (self.musicDataAry.count) {
                    musicEmptyImage.hidden = YES;
                } else {
                    musicEmptyImage.hidden = NO;
                }
                if (self.lyricDataAry.count) {
                    lyricEmptyImage.hidden = YES;
                } else {
                    lyricEmptyImage.hidden = NO;
                }
                if (productType == 1) {
                    [musicTableView reloadData];
                } else {
                    [lyricTableView reloadData];
                }
                
            }
        }
    }
}
- (void)configurePreserveSelectView {
    
    self.title = @"作品列表";
    self.view.backgroundColor = KBackgroundColor;
    productType = 1;
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 33)];
    _topScrollView.backgroundColor = KBackgroundColor;
    _topScrollView.contentSize = CGSizeZero;
    
    [self.view addSubview:_topScrollView];
    
    NSArray *titleArray = @[@"歌曲",@"歌词"];
    
    CGFloat W = ScreenWidth / titleArray.count;
    
    CGFloat H = _topScrollView.height;
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake((W + 1) * i, 1, W, H-2)];
        
        titleBtn.backgroundColor = [UIColor whiteColor];
        
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
    
    musicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.contentScrollView.frame)) style:UITableViewStyleGrouped];
    
    musicTableView.delegate = self;
    
    musicTableView.dataSource = self;
    
//    musicTableView.rowHeight = 80;
    
    musicTableView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    musicTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    musicTableView.alwaysBounceVertical = YES;
//    [musicTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:musicCellIdentify];
    
    [self.contentScrollView addSubview:musicTableView];
    
    WS(Wself);
    //refresh
    [musicTableView addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            [Wself fectProductDataWithProductType:1 IsLoadingMore:NO];
        }
    }];
    //loadingMore
    [musicTableView addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fectProductDataWithProductType:1 IsLoadingMore:YES];
    }];
    
    musicEmptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    musicEmptyImage.hidden = YES;
    
    musicEmptyImage.centerX = ScreenWidth/2;
    
    musicEmptyImage.y = 100;
    
    [self.contentScrollView addSubview:musicEmptyImage];
    //歌词
    lyricTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.contentScrollView.frame)) style:UITableViewStyleGrouped];
    
    lyricTableView.delegate = self;
    
    lyricTableView.dataSource= self;
    
//    lyricTableView.rowHeight = 80;
    
    lyricTableView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    lyricTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    lyricTableView.alwaysBounceVertical = YES;
//    [lyricTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:lyricCellIdentify];
    
    [self.contentScrollView addSubview:lyricTableView];
    //refresh
    [lyricTableView addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            [Wself fectProductDataWithProductType:2 IsLoadingMore:NO];
        }
    }];
    //loadingMore
    [lyricTableView addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fectProductDataWithProductType:2 IsLoadingMore:YES];
    }];
    lyricEmptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    lyricEmptyImage.hidden = YES;
    
    lyricEmptyImage.centerX = 3*ScreenWidth/2;
    
    lyricEmptyImage.y = 100;
    
    [self.contentScrollView addSubview:lyricEmptyImage];
    
}
- (void)titleBtnClick:(UIButton *)titleBtn {
    
    [self.contentScrollView setContentOffset:CGPointMake(ScreenWidth * (titleBtn.tag-100), 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.x = titleBtn.width * (titleBtn.tag-100);
    }];
    productType = titleBtn.tag - 99;
    
    if (titleBtn.tag == 100) {
        if (self.musicDataAry.count) {
//            [musicTableView reloadData];
        } else {
            [self fectProductDataWithProductType:1 IsLoadingMore:NO];
        }
    } else if (titleBtn.tag == 101) {
        if (self.lyricDataAry.count) {
//            [lyricTableView reloadData];
        } else {
            [self fectProductDataWithProductType:2 IsLoadingMore:NO];
        }
    }

}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        _lineView.x = scrollView.contentOffset.x / ScreenWidth * _lineView.width;
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return productType == 1 ? self.musicDataAry.count : self.lyricDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:productCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    if (productType == 1) {
        NSUnPreserveModel *model = self.musicDataAry[indexPath.row];
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = [date datetoLongLongStringWithDate:model.time];
    } else {
        NSUnPreserveModel *model = self.lyricDataAry[indexPath.row];
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = [date datetoLongLongStringWithDate:model.time];
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSPreserveApplyController *preserveController = [[NSPreserveApplyController alloc] init];
    preserveController.sortId = [NSString stringWithFormat:@"%ld",productType];

    if (productType == 1) {
        NSUnPreserveModel *model = self.musicDataAry[indexPath.row];
        preserveController.itemUid = [model.productId longLongValue];
    } else {
        NSUnPreserveModel *model = self.lyricDataAry[indexPath.row];
        preserveController.itemUid = [model.productId longLongValue];

    }
    [self.navigationController pushViewController:preserveController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
