//
//  NSAccompanyListViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccompanyListViewController.h"
#import "NSAccompanyListHeaderView.h"
#import "NSAccompanyTableCell.h"
#import "NSAccommpanyListModel.h"
@interface NSAccompanyListViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    UITableView * accompanyListTabelView;
    NSAccompanyListHeaderView * headerView;
    NSMutableArray * hotAccompanyAry;
    NSMutableArray * newAccompanyAry;
    NSMutableArray * dataAry;
    int currentPage;
}
@end

static NSString * const accompanyCellIditify = @"NSAccompanyTableCell";

@implementation NSAccompanyListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
}


#pragma mark -fetchData
-(void)fetchAccompanyData
{
    if (dataAry.count == 0) {
        [accompanyListTabelView setContentOffset:CGPointMake(0, -60) animated:YES];
        [accompanyListTabelView performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
    }
    
    
//    self.requestType = YES;
//    self.requestParams = ;
//    self.requestURL = ;
}

#pragma mark -fetchAccommpanyListDataIsLoadMore
-(void)fetchAccompanyListDataWithIsLoadingMore:(BOOL)isLoadingMore{
    
    if (!isLoadingMore) {
        currentPage = 1;
    }else{
        ++currentPage;
    }
    self.requestType = YES;
//    self.requestParams = ;
//    self.requestURL = ;
    
}

#pragma mark - overrride FetchData
//-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
//{
//    if (!parserObject.success) {
//        NSAccommpanyListModel* listModel = (NSAccommpanyListModel *)parserObject;
//        if (!operation.isLoadingMore) {
//            
//        
//        
//        if ([operation.urlTag isEqualToString:]) {
//            
//            hotAccompanyAry = [NSMutableArray arrayWithArray:listModel.accommpanyList];
//        }else{
//            
//            newAccompanyAry = [NSMutableArray arrayWithArray:listModel.accommpanyList];
//            
//        }
//        
//        }else{
//            if ([operation.urlTag isEqualToString:]) {
//                
//                [hotAccompanyAry addObject:listModel.accommpanyList];
//            }else{
//                
//                 [newAccompanyAry addObject:listModel.accommpanyList];
//                
//            }
//        }
//        [accompanyListTabelView reloadData];
//        if (!operation.isLoadingMore) {
//            [accompanyListTabelView.pullToRefreshView stopAnimating];
//        }else{
//            accompanyListTabelView.showsInfiniteScrolling = NO;
//        }
//    }
//    
//}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    //accompanyListTableView
    accompanyListTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    accompanyListTabelView.dataSource = self;
    accompanyListTabelView.delegate = self;
    headerView = [[NSAccompanyListHeaderView alloc] init];
    //set tableView headerView
    accompanyListTabelView.tableHeaderView = headerView;
    [accompanyListTabelView registerClass:[NSAccompanyTableCell class] forCellReuseIdentifier:accompanyCellIditify];
    
    [self.view addSubview:accompanyListTabelView];
    //constraints
    [accompanyListTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.top.bottom.equalTo(self.view);
    }];
    
    WS(Wself);
    //refresh
    [accompanyListTabelView addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            [Wself fetchAccompanyListDataWithIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [accompanyListTabelView addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fetchAccompanyListDataWithIsLoadingMore:YES];
    }];
    accompanyListTabelView.showsInfiniteScrolling = NO;
}

#pragma mark -TableDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSAccompanyTableCell * accompanyCell = [tableView dequeueReusableCellWithIdentifier:accompanyCellIditify];
    
    accompanyCell.accompanyModel = dataAry[row];
    return accompanyCell;
    
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
