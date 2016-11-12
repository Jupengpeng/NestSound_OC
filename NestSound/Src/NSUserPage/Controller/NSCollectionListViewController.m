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
    NSIndexPath *index;
}

@property (nonatomic, strong) UITableView *collectionTab;
@property (nonatomic, strong) NSMutableArray *myCollectionAry;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end
static NSString *collectionCellIdentifier = @"collectionCellIdentifier";
@implementation NSCollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionListUI];
    [self fetchCollectionDataWithIsLoadingMore:NO];
    //无数据
    
    [self.view addSubview:self.noDataView];
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
    if (self.viewType == CollectionViewType) {
        dic = @{@"uid":JUserID,@"token":LoginToken,@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:3]};
    } else {
        dic = @{@"uid":JUserID,@"token":LoginToken,@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:5]};
    }
    
    NSString * str = [NSTool encrytWithDic:dic];
    if (self.viewType == CollectionViewType) {
        url = [userMLICListUrl stringByAppendingString:str];
    } else {
        url = [myUserCenterListUrl stringByAppendingString:str];
    }
    
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
                    if (self.viewType == CollectionViewType) {
                        self.myCollectionAry = [NSMutableArray arrayWithArray:discoverMore.moreLyricList];
                    } else {
                        self.myCollectionAry = [NSMutableArray arrayWithArray:discoverMore.cooperateProduct];
                        for (NSCooperateProductModel *model in self.myCollectionAry) {
                            [self.itemArray addObject:@(model.itemid)];
                        }
                    }
                    
                }else{
                    [_collectionTab.infiniteScrollingView stopAnimating];
                    if (self.viewType == CollectionViewType) {
                        [self.myCollectionAry addObjectsFromArray:discoverMore.moreLyricList];
                    } else {
                        [self.myCollectionAry addObjectsFromArray:discoverMore.cooperateProduct];
                        for (NSCooperateProductModel *model in self.myCollectionAry) {
                            [self.itemArray addObject:@(model.itemid)];
                        }
                    }
                }
                if (!self.myCollectionAry.count) {
                    self.noDataView.hidden = NO;
                }else{
                    self.noDataView.hidden = YES;
                    
                }
                [_collectionTab reloadData];
                if (!self.myCollectionAry.count) {
                    emptyImage.hidden = NO;
                }
                
            } else if([operation.urlTag isEqualToString:deleteCooperationProductUrl] || [operation.urlTag isEqualToString:collectURL]) {
                [self.myCollectionAry removeObjectAtIndex:index.row];
                //
                [_collectionTab deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationLeft];
            }
        }
    }
}
- (void)configureCollectionListUI {
    if (self.viewType == CollectionViewType) {
        
        self.title = @"我的收藏";
        
    } else {
        
        self.title = @"合作作品";
    }
    
    self.collectionTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _collectionTab.delegate = self;
    
    _collectionTab.dataSource = self;
//    if (self.viewType == CollectionViewType) {
//        _collectionTab.rowHeight = 80;
//    } else {
        _collectionTab.rowHeight = 90;
//    }
    _collectionTab.backgroundColor = [UIColor whiteColor];
    
    [_collectionTab registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:collectionCellIdentifier];
    
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    _collectionTab.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_collectionTab];
    
    [_collectionTab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_collectionTab setTableFooterView:noLineView];
    
    WS(wSelf);
    [_collectionTab addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchCollectionDataWithIsLoadingMore:NO];
        }
        
    }];
    [_collectionTab addDDInfiniteScrollingWithActionHandler:^{
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
    if (self.viewType == CollectionViewType) {
        
        cell.myMusicModel = _myCollectionAry[indexPath.row];
    } else {
        cell.coWorkModel = _myCollectionAry[indexPath.row];
    }
    cell.numLabel.hidden = YES;
    cell.secretImgView.hidden = YES;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSPlayMusicViewController * playVC = [[NSPlayMusicViewController alloc] init];
    if (self.viewType == CollectionViewType) {
        NSMyMusicModel * myMusic = _myCollectionAry[indexPath.row];
        if (myMusic.type == 2) {
            NSLyricViewController * lyricVC =[[NSLyricViewController alloc] initWithItemId:myMusic.itemId];
            [self.navigationController pushViewController:lyricVC animated:YES];
        } else {
            playVC.itemUid = myMusic.itemId;
            playVC.from = @"myfov";
            playVC.geDanID = 0;
            [self.navigationController pushViewController:playVC animated:YES];
        }
    } else {
        NSCooperateProductModel *workModel = _myCollectionAry[indexPath.row];
        playVC.itemUid = workModel.itemid;
        playVC.songID = indexPath.row;
        playVC.songAry = self.itemArray;
        playVC.isCoWork = YES;
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if (self.viewType == CollectionViewType) {
            self.requestType = NO;
            NSMyMusicModel * myMode = _myCollectionAry[indexPath.row];
            //删除收藏
            
            self.requestParams = @{@"work_id":@(myMode.itemId),@"target_uid":@(myMode.userID),@"user_id":JUserID,@"token":LoginToken,@"wtype":@(myMode.type),};
            self.requestURL = collectURL;
        } else {
            self.requestType = NO;
            NSCooperateProductModel * workModel = _myCollectionAry[indexPath.row];
            //删除合作作品
            self.requestParams = @{@"uid":JUserID,@"itemid":@(workModel.itemid),@"token":LoginToken};
            self.requestURL = deleteCooperationProductUrl;
        
        }
        index = indexPath;
        
//        [_myCollectionAry removeObjectAtIndex:indexPath.row];
//        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        self.itemArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemArray;
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
