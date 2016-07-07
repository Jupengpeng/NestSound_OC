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
#import "NSWriteMusicViewController.h"
#import "NSPlayMusicTool.h"
#import <AVFoundation/AVFoundation.h>

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
    NSInteger tages;
    
}

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIButton *btn;

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
    tages = 200;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    [self fetchAccompanyData];
}

- (void)leftClick:(UIBarButtonItem *)barButtonItem {
    
    [NSPlayMusicTool pauseMusicWithName:nil];
    
    [NSPlayMusicTool stopMusicWithName:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
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
                    
                    [hotAccompanyAry addObjectsFromArray:listModel.accommpanyList];
                }
                
               
            }else{
                
                if (listModel.accommpanyList.count == 0) {
                    
                }else{
                    
                     [newAccompanyAry addObjectsFromArray:listModel.accommpanyList];
                    
                }
               
            }
        }
        if (headerView.xinBtn.selected) {
            dataAry = newAccompanyAry;
        }else{
            dataAry = hotAccompanyAry;
        }
        
        if (!operation.isLoadingMore) {
            [accompanyListTabelView.pullToRefreshView stopAnimating];
        }else{
            [accompanyListTabelView.infiniteScrollingView stopAnimating];
        }
        [accompanyListTabelView reloadData];
    }
    
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    //accompanyListTableView
    accompanyListTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    accompanyListTabelView.dataSource = self;
    accompanyListTabelView.delegate = self;
//    accompanyListTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    headerView = [[NSAccompanyListHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    //set tableView headerView
    headerView.xinBtn.selected = YES;
    [headerView.xinBtn addTarget:self action:@selector(doNew) forControlEvents:UIControlEventTouchUpInside];
    [headerView.hotBtn addTarget:self action:@selector(doHot) forControlEvents:UIControlEventTouchUpInside];
    [headerView.singBtn addTarget:self action:@selector(doSingNoAccompany) forControlEvents:UIControlEventTouchUpInside];
    
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
#pragma mark -newAccompany
-(void)doNew
{
    headerView.xinBtn.selected = YES;
    headerView.hotBtn.selected = NO;
    [self fetchAccompanyListDataWithIsLoadingMore:NO];

}
#pragma mark -hotAccompany
-(void)doHot
{
    headerView.hotBtn.selected = YES;
    headerView.xinBtn.selected = NO;
    [self fetchAccompanyListDataWithIsLoadingMore:NO];

}

#pragma mark - sing no accompany
-(void)doSingNoAccompany
{
    NSWriteMusicViewController * writeMusicVC =[[NSWriteMusicViewController alloc] initWithItemId:108 andMusicTime:300 andHotMp3:@"http://audio.yinchao.cn/empty_hot_temp.mp3"];
    [self.navigationController pushViewController:writeMusicVC animated:YES];

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
    return 3*ScreenHeight/25;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSAccompanyTableCell * accompanyCell = [tableView dequeueReusableCellWithIdentifier:accompanyCellIditify];
    
    [accompanyCell.btn addTarget:self action:@selector(playerClick:) forControlEvents:UIControlEventTouchUpInside];
    accompanyCell.btn.tag = indexPath.section;
    accompanyCell.btn.selected = NO;

    if (tages == accompanyCell.btn.tag) {
        accompanyCell.btn.selected = YES;
    }
        accompanyCell.accompanyModel = dataAry[section];
    return accompanyCell;
    
}
#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //downLoading accompany and push to recordVC
    NSAccommpanyModel * accompany = dataAry[indexPath.section];
    NSWriteMusicViewController * writeMusicVC =[[NSWriteMusicViewController alloc] initWithItemId:accompany.itemID andMusicTime:accompany.mp3Times andHotMp3:accompany.mp3URL];
    
    writeMusicVC.accompanyModel = accompany;
    
    [NSPlayMusicTool pauseMusicWithName:nil];
    
    [NSPlayMusicTool stopMusicWithName:nil];
    
    [self.navigationController pushViewController:writeMusicVC animated:YES];
}

- (void)playerClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    NSAccompanyTableCell * cell = (NSAccompanyTableCell *)btn.superview.superview;
    
    if (btn.selected) {
        
        if (self.player) {
            
            [NSPlayMusicTool pauseMusicWithName:nil];
            
            self.player = [NSPlayMusicTool playMusicWithUrl:cell.accompanyModel.mp3URL block:^(AVPlayerItem *item) {}];
            
            self.btn.selected = NO;
            tages = cell.btn.tag;
        } else {
            
            self.player = [NSPlayMusicTool playMusicWithUrl:cell.accompanyModel.mp3URL block:^(AVPlayerItem *item) {}];
            tages = cell.btn.tag;
        }
        
    } else {
        
        [NSPlayMusicTool pauseMusicWithName:nil];
        tages = 200;
    }
    
    self.btn = btn;
}


@end
