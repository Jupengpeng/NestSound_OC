//
//  NSAccompanyCategoryViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccompanyCategoryViewController.h"
#import "NSWriteMusicViewController.h"
#import "NSAccompanyTableCell.h"
#import "NSAccommpanyListModel.h"
#import "NSPlayMusicTool.h"
#import <AVFoundation/AVFoundation.h>
@interface NSAccompanyCategoryViewController ()
<UITableViewDataSource,
UITableViewDelegate>
{
    UITableView * accompanyListTabelView;
    
    int currentPage;
    
    NSString *newUrl;
    
    long classId;
    
    NSString *className;
}
@property (nonatomic, strong) NSMutableArray *categoryAryList;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) AVPlayer *player;
@end
static NSString * const accompanyCellIditify = @"NSAccompanyTableCell";
@implementation NSAccompanyCategoryViewController

- (instancetype)initWithCategoryId:(long)categoryId andCategoryName:(NSString *)categoryName {
    
    if (self = [super init]) {
        classId = categoryId;
        className = categoryName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayer)
                                                 name:@"pausePlayer"
                                               object:nil];
    [self setupCategoryListUI];
}
- (void)viewDidAppear:(BOOL)animated {
    if (self.categoryAryList.count == 0) {
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
    NSDictionary * dic = @{@"page":[NSString stringWithFormat:@"%d",currentPage],
                           @"cid":[NSNumber numberWithLong:classId],
                           @"name":[NSNull null],
                           @"type":[NSNull null]};
    NSString * str = [NSTool encrytWithDic:dic];
    
    newUrl = [accompanyCategoryListUrl stringByAppendingString:str];
    
    self.requestURL = newUrl;
    
}
#pragma mark - overrride FetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            
            NSAccommpanyListModel* listModel = (NSAccommpanyListModel *)parserObject;
            if (!operation.isLoadingMore) {
                
                self.categoryAryList = [NSMutableArray arrayWithArray:listModel.accommpanyList];
                
                //                if ([operation.urlTag isEqualToString:hotUrl]) {
                
                //                    hotAccompanyAry = [NSMutableArray arrayWithArray:listModel.simpleCategoryList.simpleCategory];
                //                }else{
                
                //                    newAccompanyAry = [NSMutableArray arrayWithArray:listModel.simpleCategoryList.simpleCategory];
                
                //                }
                
            }else{
                //                if ([operation.urlTag isEqualToString:hotUrl]) {
                //                    if (listModel.accommpanyList.count == 0) {
                //
                //                    }else{
                //
                //                        [hotAccompanyAry addObjectsFromArray:listModel.simpleCategoryList];
                //                    }
                //
                //
                //                }else{
                //
                //                    if (listModel.accommpanyList.count == 0) {
                //
                //                    }else{
                //
                //                        [newAccompanyAry addObjectsFromArray:listModel.simpleCategoryList];
                //
                //                    }
                //
                //                }
            }
            //            if (headerView.xinBtn.selected) {
            //                dataAry = newAccompanyAry;
            //            }else{
            //                dataAry = hotAccompanyAry;
            //            }
            
            if (!operation.isLoadingMore) {
                [accompanyListTabelView.pullToRefreshView stopAnimating];
                //                [accompanyListTabelView.pullToRefreshView stopAnimating];
            }else{
                [accompanyListTabelView.infiniteScrollingView stopAnimating];
                //                [accompanyListTabelView.infiniteScrollingView stopAnimating];
            }
            [accompanyListTabelView reloadData];
        }
    }
}
- (void)setupCategoryListUI {
    self.title = className;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    
    //accompanyListTableView
    accompanyListTabelView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, ScreenHeight) style:UITableViewStyleGrouped];
    accompanyListTabelView.dataSource = self;
    accompanyListTabelView.delegate = self;
    accompanyListTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [accompanyListTabelView registerClass:[NSAccompanyTableCell class] forCellReuseIdentifier:accompanyCellIditify];
    
    [self.view addSubview:accompanyListTabelView];
    //constraints
    
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
#pragma mark -TableDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoryAryList.count;
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
    
    accompanyCell.accompanyModel = self.categoryAryList[section];
    return accompanyCell;
    
}
#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //downLoading accompany and push to recordVC
    NSAccommpanyModel * accompany = self.categoryAryList[indexPath.section];
    NSWriteMusicViewController * writeMusicVC =[[NSWriteMusicViewController alloc] initWithItemId:accompany.itemID andMusicTime:accompany.mp3Times andHotMp3:accompany.mp3URL];
    for (NSAccommpanyModel *model in self.categoryAryList) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:model.mp3URL];
        writeMusicVC.urlStrArr = array;
    }
    writeMusicVC.accompanyId = indexPath.row;
    writeMusicVC.accompanyModel = accompany;
    
    [self.player pause];
    [NSPlayMusicTool stopMusicWithName:nil];
    
    [self.navigationController pushViewController:writeMusicVC animated:YES];
}

- (void)playerClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    if (btn == self.button) {
        
    } else {
        self.button.selected = NO;
    }
    NSAccompanyTableCell * cell = (NSAccompanyTableCell *)btn.superview.superview;
    
    if (btn.selected) {
        
        if (self.player) {
            
            [NSPlayMusicTool pauseMusicWithName:nil];
            
            self.player = [NSPlayMusicTool playMusicWithUrl:cell.accompanyModel.mp3URL block:^(AVPlayerItem *item) {}];
            
        } else {
            
            self.player = [NSPlayMusicTool playMusicWithUrl:cell.accompanyModel.mp3URL block:^(AVPlayerItem *item) {}];
        }
        
    } else {
        
        [NSPlayMusicTool pauseMusicWithName:nil];
//        self.player = [NSPlayMusicTool playMusicWithUrl:cell.accompanyModel.mp3URL block:^(AVPlayerItem *item) {}];
    }
    
    self.button = btn;
}

- (void)pausePlayer {
    [NSPlayMusicTool pauseMusicWithName:nil];
    self.button.selected = NO;
}
- (void)leftClick:(UIBarButtonItem *)barButtonItem {
    
    [NSPlayMusicTool pauseMusicWithName:nil];
    
    [NSPlayMusicTool stopMusicWithName:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)categoryAryList {
    if (!_categoryAryList) {
        self.categoryAryList = [NSMutableArray arrayWithCapacity:1];
    }
    return _categoryAryList;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pausePlayer" object:nil];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
