//
//  NSCollectionListViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/20.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCollectionListViewController.h"
#import "NSNewMusicTableViewCell.h"
#import "NSPlayMusicViewController.h"
#import "NSLyricViewController.h"
#import "NSDiscoverMoreLyricModel.h"
@interface NSCollectionListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int currentPage;
    NSString *url;
    UIImageView *emptyImage;
}

@property (nonatomic, strong) UITableView *collectionTab;
@property (nonatomic, strong) NSMutableArray *myCollectionAry;
@end
static NSString *collectionCellIdentifier = @"collectionCellIdentifier";
@implementation NSCollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionListUI];
    [self fetchCollectionDataWithIsLoadingMore:NO];
}
- (void)fetchCollectionDataWithIsLoadingMore:(BOOL)isLoadingMore {
    self.requestType = YES;
    NSDictionary * dic;
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{kIsLoadingMore :@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    dic = @{@"uid":JUserID,@"token":LoginToken,@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:3]};
    NSString * str = [NSTool encrytWithDic:dic];
    url = [userMLICListUrl stringByAppendingString:str];
    self.requestURL = url;
}
#pragma mark -override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if ( requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                NSDiscoverMoreLyricModel * discoverMore = (NSDiscoverMoreLyricModel *)parserObject;
                if (!operation.isLoadingMore) {
                    [_collectionTab.pullToRefreshView stopAnimating];
                    self.myCollectionAry = [NSMutableArray arrayWithArray:discoverMore.moreLyricList];
                    
                }else{
                    [_collectionTab.infiniteScrollingView stopAnimating];
                    [self.myCollectionAry addObjectsFromArray:discoverMore.moreLyricList];
                                    }
                [_collectionTab reloadData];
                if (!self.myCollectionAry.count) {
                    emptyImage.hidden = NO;
                }
                
            }
        }
    }
}
- (void)configureCollectionListUI {
    self.title = @"收藏";
    
    self.collectionTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _collectionTab.delegate = self;
    
    _collectionTab.dataSource = self;
    
    _collectionTab.rowHeight = 80;
    
    _collectionTab.backgroundColor = [UIColor whiteColor];
    
    [_collectionTab registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:collectionCellIdentifier];
    
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionTab.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_collectionTab];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_collectionTab setTableFooterView:noLineView];
    
    WS(wSelf);
    [_collectionTab addInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchCollectionDataWithIsLoadingMore:YES];
        }
    }];
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyImage.hidden = YES;
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [self.view addSubview:emptyImage];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myCollectionAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionCellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cell.mas_left);
    }];
    cell.myMusicModel = _myCollectionAry[indexPath.row];
    cell.numLabel.hidden = YES;
    cell.secretImgView.hidden = YES;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMyMusicModel * myMusic = _myCollectionAry[indexPath.row];
    if (myMusic.type == 1) {
        NSPlayMusicViewController * playVC = [[NSPlayMusicViewController alloc] init];
        playVC.itemUid = myMusic.itemId;
        playVC.from = @"myfov";
        playVC.geDanID = 0;
//        BOOL isH = false;
//        for (id vc in self.navigationController.childViewControllers) {
//            if ([vc isKindOfClass:[NSPlayMusicViewController class]]) {
//                isH = YES;
//            }
//        }
//        if (isH) {
//            [self.navigationController popToViewController:playVC animated:YES];
//        }else{
            [self.navigationController pushViewController:playVC animated:YES];
//        }

    }else{
        NSLyricViewController * lyricVC =[[NSLyricViewController alloc] initWithItemId:myMusic.itemId];
        [self.navigationController pushViewController:lyricVC animated:YES];
        
    }
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
