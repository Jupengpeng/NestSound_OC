//
//  NSDraftListViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSDraftListViewController.h"
#import "NSDraftListModel.h"
#import "NSTool.h"
@interface NSDraftListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *draftListTab;
    NSInteger currentPage;
    NSString *url;
    UIImageView *emptyImage;
}
@property (nonatomic, strong) NSMutableArray *draftListArr;
@end
static NSString  * const draftCellIdifity = @"draftCell";
@implementation NSDraftListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUIAppearance];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.draftListArr.count) {
        
        [draftListTab setContentOffset:CGPointMake(0, -60) animated:YES];
        [draftListTab performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
    }
    
    
}
#pragma mark -fetchData
-(void)fetchDraftListDataIsLoadingMore:(BOOL)isLoadingMore
{
    if (!isLoadingMore) {
        currentPage = 1;
//        self.requestParams = @{@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],@"uid":JUserID,kIsLoadingMore:@(NO),@"token":LoginToken};
    }else{
        ++currentPage;
//        self.requestParams = @{@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],@"uid":JUserID,kIsLoadingMore:@(YES),@"token":LoginToken};
    }
    self.requestParams = @{@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],@"uid":JUserID,kIsLoadingMore:@(isLoadingMore),@"token":LoginToken};
    self.requestType = NO;
//    self.requestParams = @{@"page":[NSString stringWithFormat:@"%ld",currentPage],@"uid":JUserID};
    self.requestURL = draftListUrl;
    
}

#pragma mark --override action fetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:draftListUrl]) {
                NSDraftListModel * draftList = (NSDraftListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    [draftListTab.pullToRefreshView stopAnimating];
                    
                    self.draftListArr = [NSMutableArray arrayWithArray:draftList.draftList];
                }else{
                    [draftListTab.infiniteScrollingView stopAnimating];
                    
                    for (NSDraftModel *model in draftList.draftList) {
                        [self.draftListArr addObject:model];
                    }
                }
                
                [draftListTab reloadData];
                if (self.draftListArr.count) {
                    emptyImage.hidden = YES;
                } else {
                    emptyImage.hidden = NO;
                }
            } else if ([operation.urlTag isEqualToString:deleteDraftUrl]) {
                [[NSToastManager manager] showtoast:@"操作成功"];
            }
        }
    }
}
#pragma mark -configureAppearance
-(void)configureUIAppearance
{
    self.title = @"草稿箱";
    self.view.backgroundColor = KBackgroundColor;
    
    //draftListTableView
    draftListTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    
    draftListTab.delegate = self;
    
    draftListTab.dataSource = self;
    
    [self.view addSubview:draftListTab];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [draftListTab setTableFooterView:noLineView];
    
    WS(wSelf);
    
    //refresh
    [draftListTab addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchDraftListDataIsLoadingMore:NO];
        }
    }];
    
    //loadingMore]
    [draftListTab addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchDraftListDataIsLoadingMore:YES];
        }
    }];
    draftListTab.showsInfiniteScrolling = YES;
    
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.2_noDataImg"]];
    
    emptyImage.hidden = YES;
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [self.view addSubview:emptyImage];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.draftListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:draftCellIdifity];
    NSDraftModel *model = self.draftListArr[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:draftCellIdifity];
        if (model.title.length) {
            cell.textLabel.text = model.title;
        } else {
            cell.textLabel.text = @"未命名";
        }
        
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.text = [date datetoLongLongStringWithDate:model.createTime];
//        [NSString stringWithFormat:@"2016-08-%ld",(long)indexPath.row];
        
    }
    return cell;
}
#pragma mark collectionViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDraftModel * model = self.draftListArr[indexPath.row];    
    
    if ([_delegate respondsToSelector:@selector(selectDraft:withDraftTitle:)]) {
        
        [self.delegate selectDraft:model.content withDraftTitle:model.title];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDraftModel *model = self.draftListArr[indexPath.row];
    [self deleteDraftWithId:model.itemId];
    [self.draftListArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)deleteDraftWithId:(long)draftId {
    self.requestType = NO;
    self.requestParams = @{@"id":@(draftId),@"token":LoginToken};
    self.requestURL = deleteDraftUrl;
}
- (NSMutableArray *)draftListArr {
    if (!_draftListArr) {
        self.draftListArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _draftListArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
