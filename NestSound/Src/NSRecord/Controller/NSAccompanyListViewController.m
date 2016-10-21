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
#import "NSAccompanyCategoryCell.h"
#import "NSAccompanyCategoryViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSAccompanyTableCell.h"
#import "NSAccommpanyListModel.h"
#import "NSAccompanyListFilterView.h"


static NSString * const accompanyData   = @"accompanyData";
static NSString * const simpleSingle  = @"simpleSingle";
static NSString * const accompanyCategory = @"accompanyCategory";
static NSString * const accompanyList = @"accompanyList";
@interface NSAccompanyListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _currentPage;
    
    NSInteger _sortType;
    
    
    long _classId;
    
    NSString *_className;
    
    NSString *_accompanyTypeListURL;
    NSString *_accompanyDetailListUrl;
    
    YYCache *_cache;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *categoryAryList;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIButton *button;


/**
 *  清唱
 */
@property (nonatomic,strong) NSSimpleSingModel *simpleSingModel;
/**
 *  类型筛选器
 */
@property (nonatomic,strong) NSAccompanyListFilterView *filterView;


/**
 *  缓存
 */
@property (nonatomic, strong) NSMutableArray * simpleSingAry;

@property (nonatomic, strong) NSMutableArray * accompanyCategoryAry;


@end

static NSString * const accompanyCellIditify = @"NSAccompanyTableCell";

@implementation NSAccompanyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayer)
                                                 name:@"pausePlayer"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayer) name:AVAudioSessionInterruptionNotification object:nil];
    

    [self getCache];
    [self setupUI];
    [self fetchAccompanyListData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.filterView dismiss];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (self.categoryAryList.count == 0) {
//        [self.tableView setContentOffset:CGPointMake(0, -60) animated:YES];
//        [self.tableView performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
//        
//    }
}

/**
 *  获取缓存
 */
- (void)getCache{
    _cache = [YYCache cacheWithName:accompanyData];
    self.simpleSingAry = [NSMutableArray arrayWithArray:(NSArray *)[_cache objectForKey:simpleSingle]];
    self.accompanyCategoryAry = [NSMutableArray arrayWithArray:(NSArray *)[_cache objectForKey:accompanyCategory]];
    self.categoryAryList = [NSMutableArray arrayWithArray:(NSArray *)[_cache objectForKey:accompanyList]];
    if (self.accompanyCategoryAry.count) {
        NSAccommpanyListModel* listModel = [[NSAccommpanyListModel alloc]init];;
        listModel.simpleCategoryList.simpleCategory = [self.accompanyCategoryAry mutableCopy];
        listModel.simpleList.simpleSingList = self.simpleSingAry.firstObject;
        [self setupHeaderViewWithSimpleSing:listModel.simpleList.simpleSingList];
        [self setupFilterViewUIWith:listModel];
    }
}
- (void)setupUI{
    
    self.title = @"原唱伴奏";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    
    [self.view addSubview:self.tableView];
    WS(weakSelf);
    [self.tableView addDDPullToRefreshWithActionHandler:^{
        [weakSelf fetchAccompanyListDataWithIsLoadingMore:NO];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchAccompanyListDataWithIsLoadingMore:YES];
    }];
    
    
}

- (void)setupFilterViewUIWith:(NSAccommpanyListModel *)accompanyListModel{
    
    self.filterView = [[NSAccompanyListFilterView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight) listModel:accompanyListModel];
    
    WS(weakSelf);
    
    
    self.filterView.confirmBlock = ^(NSInteger sortIndex,NSInteger categoryIndex,NSSimpleCategoryModel *categoryModel){
        CHLog(@"选择了：%@  id 为 :%d",categoryModel.categoryName,categoryModel.categoryId);
        _classId = categoryModel.categoryId;
        _sortType = sortIndex;
        [weakSelf fetchAccompanyListDataWithIsLoadingMore:NO];
        
    };
    if (self.filterView.superview) {
        [self.filterView removeFromSuperview];
    }
    [self.navigationController.view addSubview:self.filterView];
    
    UIImageView *shaixuanView  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 16)];
    shaixuanView.userInteractionEnabled = NO;
    shaixuanView.image = [UIImage imageNamed:@"ic_saixuan"];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40) ];
    [btn addSubview:shaixuanView];
    [btn addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    /**
     *  各项初始化城第一个
     */
    [self.filterView setOriginalStateWithIndex:0];
    
}


- (void)setupHeaderViewWithSimpleSing:(NSSimpleSingModel *)simpleSing {
    CGFloat contentWidth = ScreenWidth - 30;
    CGFloat contentHeight = contentWidth * 125/345;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, contentHeight + 20)];

    UIButton *contentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.5, ScreenWidth,  contentHeight + 19)];
    [contentButton addTarget:self action:@selector(simpleSingClick:) forControlEvents:UIControlEventTouchUpInside];
    contentButton.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:contentButton];
    
    
    
    UIImageView *backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9.5, contentWidth, contentHeight)];
    
    [backImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    backImgView.contentMode =  UIViewContentModeScaleAspectFill;
    
    backImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    backImgView.clipsToBounds  = YES;
    backImgView.layer.cornerRadius = 3.0;
    [contentButton addSubview:backImgView];
    
    [backImgView setDDImageWithURLString:simpleSing.titleImageUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
    
    self.tableView.tableHeaderView = headerView;
}
/**
 *  清唱
 *
 *  @param clickButton <#clickButton description#>
 */
- (void)simpleSingClick:(UIButton *)clickButton{
    NSSimpleSingModel *simpleSing = self.simpleSingModel;
    if ([[NSSingleTon viewFrom].viewTag isEqualToString:@"writeView"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clearRecordNotification" object:nil userInfo:@{@"accompanyId":@(simpleSing.itemID),@"accompanyTime":[NSNumber numberWithLong:simpleSing.playTimes],@"accompanyUrl":simpleSing.playUrl}];
    } else {
        
        NSWriteMusicViewController * writeMusicVC =[[NSWriteMusicViewController alloc] initWithItemId:simpleSing.itemID andMusicTime:simpleSing.playTimes andHotMp3:simpleSing.playUrl];
        [NSSingleTon viewFrom].controllersNum = 2;
        if (self.aid.length) {
            writeMusicVC.aid = self.aid;
            
        }
        [self.navigationController pushViewController:writeMusicVC animated:YES];
        
    }
}

- (void)filterClick:(UIButton *)button{
    [self.filterView showWithCompletion:^(BOOL finished) {
        
    }];
}


#pragma mark 播放器方法

//播放结束代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self pausePlayer];
    
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

#pragma mark -fetchAccommpanyListDataIsLoadMore
/**
 *  请求伴奏类型列表
 */
-(void)fetchAccompanyListData{
    
    _currentPage = 1;
    self.requestType = YES;
    NSDictionary * dic = @{@"page":[NSString stringWithFormat:@"%d",_currentPage]};
    NSString * str = [NSTool encrytWithDic:dic];
    _accompanyTypeListURL = [accompanyListURL stringByAppendingString:str];
    self.requestURL = _accompanyTypeListURL;
    
}

#pragma mark -fetchAccommpanyListDataIsLoadMore
-(void)fetchAccompanyListDataWithIsLoadingMore:(BOOL)isLoadingMore{
    
    if (!isLoadingMore) {
        _currentPage = 1;
        self.requestParams = @{kIsLoadingMore :@(NO)};
    }else{
        ++_currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    self.requestType = YES;
//    NSString *type;
//    NSDictionary * dic = [NSDictionary dictionary];
//    if ([_className isEqualToString:@"最新"]) {
//        type = @"new";
//    } else if ([_className isEqualToString:@"热门"]) {
//        type = @"hot";
//    } else {
//        type = @"";
//    }
    NSString *type;
    NSDictionary * dic = nil;

    if (_sortType == 0) {
        type = @"new";
    }else{
        type = @"hot";
    }
    if (type.length) {
        dic = @{@"page":[NSString stringWithFormat:@"%d",_currentPage],
                @"cid":[NSNumber numberWithLong:_classId],
                @"name":[NSNull null],
                @"type":type};
    } else {
        dic = @{@"page":[NSString stringWithFormat:@"%d",_currentPage],
                @"cid":[NSNumber numberWithLong:_classId],
                @"name":[NSNull null],
                @"type":[NSNull null]};
    }
    NSString * str = [NSTool encrytWithDic:dic];
    
    _accompanyDetailListUrl = [accompanyCategoryListUrl stringByAppendingString:str];
    
    self.requestURL = _accompanyDetailListUrl;
    
}


#pragma mark - overrride FetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:_accompanyDetailListUrl]) {

                /**
                 *  具体伴奏列表
                 */
                NSAccommpanyListModel* listModel = (NSAccommpanyListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    
                    [self.tableView.pullToRefreshView stopAnimating];
                    
                    self.categoryAryList = [NSMutableArray arrayWithArray:listModel.accommpanyList];
                    [_cache setObject:self.categoryAryList forKey:accompanyList];

                }else{
                    
                    [self.tableView.infiniteScrollingView stopAnimating];
                    
                    [self.categoryAryList addObjectsFromArray:listModel.accommpanyList];
                    [_cache setObject:self.categoryAryList forKey:accompanyList];

                    
                }
            }else if ([operation.urlTag isEqualToString:_accompanyTypeListURL]){
                [_cache removeAllObjects];

                /**
                 *  伴奏类型列表
                 */
                
                NSAccommpanyListModel* listModel = (NSAccommpanyListModel *)parserObject;
                
                if (listModel.simpleCategoryList.simpleCategory.count) {
                    /**
                     *  缓存
                     */
                    self.accompanyCategoryAry = [NSMutableArray arrayWithArray:listModel.simpleCategoryList.simpleCategory];
                    [_cache setObject:self.accompanyCategoryAry forKey:accompanyCategory];
                    
                    CHLog(@"%@",[_cache objectForKey:accompanyCategory]);
                    /**
                     *  设置 筛选器
                     */
                    [self setupFilterViewUIWith:listModel];
                }
                if (listModel.simpleList.simpleSingList.itemID) {
                    
                    /**
                     *  缓存
                     */
                    [self.simpleSingAry removeAllObjects];
                    [self.simpleSingAry addObject:listModel.simpleList.simpleSingList];
                    [_cache setObject:self.simpleSingAry forKey:simpleSingle];
                    
                    
                    
                    self.simpleSingModel = listModel.simpleList.simpleSingList;
                    [self setupHeaderViewWithSimpleSing:self.simpleSingModel];
                }
                
            }
                

            
            [self.tableView reloadData];
        }
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.categoryAryList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 3*ScreenHeight/25 + 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSAccompanyTableCell * accompanyCell = [tableView dequeueReusableCellWithIdentifier:accompanyCellIditify];
    
    [accompanyCell.btn addTarget:self action:@selector(playerClick:) forControlEvents:UIControlEventTouchUpInside];
    accompanyCell.btn.tag = indexPath.section;
    accompanyCell.btn.selected = NO;
    
    accompanyCell.accompanyModel = self.categoryAryList[section];
    return accompanyCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAccommpanyModel * accompany = self.categoryAryList[indexPath.section];
    //downLoading accompany and push to recordVC
    if ([[NSSingleTon viewFrom].viewTag isEqualToString:@"writeView"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clearRecordNotification" object:nil userInfo:@{@"accompanyId":@(accompany.itemID),@"accompanyTime":[NSNumber numberWithLong:accompany.mp3Times],@"accompanyUrl":accompany.mp3URL}];
        
    } else {
        
        NSWriteMusicViewController * writeMusicVC =[[NSWriteMusicViewController alloc] initWithItemId:accompany.itemID andMusicTime:accompany.mp3Times andHotMp3:accompany.mp3URL];
        [NSSingleTon viewFrom].controllersNum = 3;
        if (self.aid.length) {
            writeMusicVC.aid = self.aid;
        }
        
        [self pausePlayer];
        [self.navigationController pushViewController:writeMusicVC animated:YES];
    }
}

#pragma mark - lazy init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth , ScreenHeight - 1) style:UITableViewStylePlain];
        
        _tableView.backgroundColor = [UIColor hexColorFloat:kAppLineRgbValue];
        [_tableView registerClass:[NSAccompanyTableCell class] forCellReuseIdentifier:accompanyCellIditify];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
    }
    return _tableView;
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
