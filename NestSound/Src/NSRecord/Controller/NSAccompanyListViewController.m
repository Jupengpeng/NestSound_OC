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
    NSString * newUrl;
    NSString * hotUrl;
    
}
@end

static NSString * const accompanyCellIditify = @"NSAccompanyTableCell";

@implementation NSAccompanyListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchAccompanyData];
}


#pragma mark -fetchData
-(void)fetchAccompanyData
{
    if (dataAry.count == 0) {
        [accompanyListTabelView setContentOffset:CGPointMake(0, -60) animated:YES];
        [accompanyListTabelView performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
    }
    
}

#pragma mark -fetchAccommpanyListDataIsLoadMore
-(void)fetchAccompanyListDataWithIsLoadingMore:(BOOL)isLoadingMore{
    
       if (!isLoadingMore) {
        currentPage = 1;
           self.requestParams = @{kIsLoadingMore :@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    self.requestType = YES;
    NSDictionary * dic = @{@"page":[NSString stringWithFormat:@"%d",currentPage]};
    NSString * str = [NSTool encrytWithDic:dic];
    if (headerView.xinBtn.selected) {
        newUrl = [accompanyListURL stringByAppendingString:str];
        self.requestURL = newUrl;
   
    }else{
        hotUrl = [accompanyListURL stringByAppendingString:str];
        self.requestURL = hotUrl;
    }
    

    
}




#pragma mark - overrride FetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        NSAccommpanyListModel* listModel = (NSAccommpanyListModel *)parserObject;
        if (!operation.isLoadingMore) {
            
        
        
        if ([operation.urlTag isEqualToString:hotUrl]) {
            
            hotAccompanyAry = [NSMutableArray arrayWithArray:listModel.accommpanyList];
        }else{
            
            newAccompanyAry = [NSMutableArray arrayWithArray:listModel.accommpanyList];
            
        }
        
        }else{
            if ([operation.urlTag isEqualToString:hotUrl]) {
                if (listModel.accommpanyList.count == 0) {
                    
                }else{
                    
                    [hotAccompanyAry addObject:listModel.accommpanyList];
                }
                
               
            }else{
                
                if (listModel.accommpanyList.count == 0) {
                    
                }else{
                    
                     [newAccompanyAry addObject:listModel.accommpanyList];
                }
                
                
                
            }
        }
        if (headerView.xinBtn.selected) {
            dataAry = newAccompanyAry;
        }else{
            dataAry = hotAccompanyAry;
        }
        [accompanyListTabelView reloadData];
        if (!operation.isLoadingMore) {
            [accompanyListTabelView.pullToRefreshView stopAnimating];
        }else{
            accompanyListTabelView.showsInfiniteScrolling = YES;
        }
    }
    
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    //accompanyListTableView
    accompanyListTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    accompanyListTabelView.dataSource = self;
    accompanyListTabelView.delegate = self;
    headerView = [[NSAccompanyListHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    //set tableView headerView
    headerView.xinBtn.selected = YES;
    [headerView.xinBtn addTarget:self action:@selector(doNew) forControlEvents:UIControlEventTouchUpInside];
    [headerView.hotBtn addTarget:self action:@selector(doHot) forControlEvents:UIControlEventTouchUpInside];
    accompanyListTabelView.tableHeaderView = headerView;
    [accompanyListTabelView registerClass:[NSAccompanyTableCell class] forCellReuseIdentifier:accompanyCellIditify];
    
    [self.view addSubview:accompanyListTabelView];
    //constraints
    [accompanyListTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
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
    accompanyListTabelView.showsInfiniteScrolling = YES;
}

-(void)doNew
{
    headerView.xinBtn.selected = YES;
    headerView.hotBtn.selected = NO;
    [self fetchAccompanyListDataWithIsLoadingMore:NO];

}

-(void)doHot
{
    headerView.hotBtn.selected = YES;
    headerView.xinBtn.selected = NO;
    [self fetchAccompanyListDataWithIsLoadingMore:NO];

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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSAccompanyTableCell * accompanyCell = [tableView dequeueReusableCellWithIdentifier:accompanyCellIditify];
    
    accompanyCell.accompanyModel = dataAry[section];
    return accompanyCell;
    
}
#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //downLoading accompany and push to recordVC
    
    
}

@end
