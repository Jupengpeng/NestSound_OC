//
//  ThemeActivityController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

static NSInteger const kButtonTag = 450;


#import "NSThemeActivityController.h"
#import "MainTouchTableTableView.h"
#import "MYSegmentView.h"
#import "NSThemeTopicTopView.h"
#import "NSThemeCommentController.h"
#import "NSStarMusicianListController.h"
#import "NSActivityJoinerListController.h"
#import "NSUserPageViewController.h"
#import "NSActivityDetailModel.h"
#import "NSActivityJoinerListModel.h"
#import "NSWriteLyricViewController.h"
#import "NSAccompanyListViewController.h"
#import "NSLoginViewController.h"
#import "NSUserWorkListController.h"
#import "NSPlayMusicViewController.h"
@interface NSThemeActivityController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TTTAttributedLabelDelegate,UIAlertViewDelegate>
{
    CGFloat _topViewHeight;
    CGFloat _refreshOriginY;
    
    BOOL _actDetailLoaded;
    BOOL _joinerListLoaded;
    
    
    BOOL _isRefresh;
    BOOL _isLoadMore;
    
    UIView *_moreChoiceView;
    UIView *_maskView;
    UIImageView *_playStatus;
    /**
     *  是否已经发布过
     */
    BOOL _isPublished;
}
@property (nonatomic,strong) MainTouchTableTableView *mainTableView;

@property (nonatomic,strong) NSThemeTopicTopView *topView;

@property (nonatomic, strong) MYSegmentView * RCSegView;
/**
 *  我要参加按钮
 */
@property (nonatomic,strong) UIButton *wantJoinInButton;

@property (nonatomic,assign) NSInteger page;

/**
 *  0：最新  1：最热
 */
@property (nonatomic,assign) NSInteger sort;

@property (nonatomic,strong)  NSThemeCommentController *leftController;
@property (nonatomic,strong) NSThemeCommentController *rightController;


@property (nonatomic,strong) NSPlayMusicViewController *playSongsVC;
/**
 *  数据源
 */

@property (nonatomic,strong) NSMutableArray *joinerList;

@property (nonatomic,strong) NSActivityDataModel *actDataModel;
/**
 *  框架业务处理
 */
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
/**
 *   tableView的上一个 是否可移动状态
 */
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@end

@implementation NSThemeActivityController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupUI];

//    [self fetchIndexData];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.playSongsVC.player == nil) {
        
    } else {
        
        if (self.playSongsVC.player.rate != 0.0) {
            [_playStatus startAnimating];
        }else{
            [_playStatus stopAnimating];
        }
    }
    if (self.needRefresh) {
        [self refreshData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    self.needRefresh = NO;
//    [self.mainTableView removeObserver:self.mainTableView.pullToRefreshView forKeyPath:@"contentOffset"];
//    [self.mainTableView removeObserver:self.mainTableView.pullToRefreshView forKeyPath:@"frame"];
}

- (void)refreshData{
    
    [self.mainTableView.pullToRefreshView stopAnimating];
    [self.mainTableView.pullToRefreshView startAnimating];
    [self fetchActivityDetailData];
    
}

- (void)fetchActivityDetailData{
    
    
    [self.mainTableView.pullToRefreshView startAnimating];

    /**
     *  重新发起
     */
    _actDetailLoaded =NO;
    _joinerListLoaded = NO;
    

    /**
     *  活动详情
     */
    self.requestType = NO;
    self.requestParams = @{@"aid":(self.aid.length ? self.aid: @"5"),
                                 @"uid":JUserID};
    self.requestURL =  activityDetailUrl;

    /**
     *  参与用户列表
     */
    self.requestParams = @{@"aid":(self.aid.length ? self.aid: @"5"),
                           @"page":[NSString stringWithFormat:@"%d",1]};
    

    self.requestURL = joinedUserListUrl;
    
    /**
     *  参赛作品详情列表
     *
     *  @return return value description
     */
    

    
}

#pragma mark -overrider action fetchData
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        
    }else{
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:activityDetailUrl]) {
                _actDetailLoaded = YES;
                NSActivityDetailModel *activityModel = (NSActivityDetailModel *)parserObject;
                self.actDataModel = activityModel.activityDataModel;
            }else if ([operation.urlTag isEqualToString:joinedUserListUrl]){
                _joinerListLoaded = YES;
                NSActivityJoinerListModel *joinerListModel = (NSActivityJoinerListModel *)parserObject;

                if (self.joinerList.count) {
                    [self.joinerList removeAllObjects];
                }
                
                [self.joinerList addObjectsFromArray:joinerListModel.joinerList];
                
                for (NSActivityJoinerDetailModel *joinerDetailModel in joinerListModel.joinerList) {
                    /**
                     *  判断是否参加过活动
                     */
                    if (joinerDetailModel.joinerId == [JUserID intValue]) {
                        _isPublished = YES;
                    }
                }
                
            }

            [self reloadUI];

        }
    }

    
}

- (void)reloadUI{
    if (_actDetailLoaded == YES &&
        _joinerListLoaded == YES) {
        [self updateUIFrames];
        [self.mainTableView reloadData];
        [self.mainTableView.pullToRefreshView stopAnimating];
    }
    
}

- (void)setupUI{

    
    [self setupNavBar];
    self.title = @"专题活动";
    
    self.mainTableView.tableHeaderView = self.topView ;

   
    WS(weakSelf);
    self.topView.headerClickBlock = ^(NSInteger index, id obj){
        switch (index) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            {
                NSActivityJoinerDetailModel *joinerDetailModel = (NSActivityJoinerDetailModel *)obj;
                NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",joinerDetailModel.joinerId]];
                if (joinerDetailModel.joinerId != [JUserID integerValue]) {
                    pageVC.who = Other;
                    [weakSelf.navigationController pushViewController:pageVC animated:YES];
                }
                
                
            }
                break;
            case 7:
            {
                NSActivityJoinerListController *joinerListController = [[NSActivityJoinerListController alloc] init];
                [weakSelf.navigationController pushViewController:joinerListController animated:YES];
            }
                break;
                
                
            default:
                break;
        }
    };
    
    [self.view addSubview: self.mainTableView];
    
    [self.view addSubview:self.wantJoinInButton];
    [self.view bringSubviewToFront:self.wantJoinInButton];
    [self.wantJoinInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(130);
    }];
    [self moreChoice];


    WS(wSelf);

    [_mainTableView addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchActivityDetailData];
        }
    }];
    /**
     *  第一次手动请求数据
     */
    [self fetchActivityDetailData];
    [_mainTableView.pullToRefreshView startAnimating];
//    _refreshOriginY = weakSelf.mainTableView.pullToRefreshView.y;
//    self.mainTableView.pullToRefreshView.y = _refreshOriginY - _topViewHeight;
    //    self.mainTableView.pullToRefreshView.alpha = 0;;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
}

- (void)setupNavBar{
    _playStatus  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 21)];
    _playStatus.animationDuration = 0.8;
    _playStatus.animationImages = @[[UIImage imageNamed:@"2.0_play_status_1"],
                                   [UIImage imageNamed:@"2.0_play_status_2"],
                                   [UIImage imageNamed:@"2.0_play_status_3"],
                                   [UIImage imageNamed:@"2.0_play_status_4"],
                                   [UIImage imageNamed:@"2.0_play_status_5"],
                                   [UIImage imageNamed:@"2.0_play_status_6"],
                                   [UIImage imageNamed:@"2.0_play_status_7"],
                                   [UIImage imageNamed:@"2.0_play_status_8"],
                                   [UIImage imageNamed:@"2.0_play_status_9"],
                                   [UIImage imageNamed:@"2.0_play_status_10"],
                                   [UIImage imageNamed:@"2.0_play_status_11"],
                                   [UIImage imageNamed:@"2.0_play_status_12"],
                                   [UIImage imageNamed:@"2.0_play_status_13"],
                                   [UIImage imageNamed:@"2.0_play_status_14"],
                                   [UIImage imageNamed:@"2.0_play_status_15"],
                                   [UIImage imageNamed:@"2.0_play_status_16"]];
    
    [_playStatus stopAnimating];
    _playStatus.userInteractionEnabled = YES;
    _playStatus.image = [UIImage imageNamed:@"2.0_play_status_1"];
    UIButton * btn = [[UIButton alloc] initWithFrame:_playStatus.frame ];
    [_playStatus addSubview:btn];
    [btn addTarget:self action:@selector(musicPaly:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:_playStatus];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)musicPaly:(UIBarButtonItem *)palyItem {
    
    if (self.playSongsVC.player == nil) {
        [[NSToastManager manager] showtoast:@"您还没有听过什么歌曲哟"];
    } else {
        
        [self.navigationController pushViewController:self.playSongsVC animated:YES];
    }
    
}

-(void)acceptMsg : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

/**
 *  视图尺寸变化
 */
- (void)updateUIFrames{

    /**
     *  重新加载数据
     */
    [_topView setupDataWithData:self.actDataModel joinerArray:self.joinerList descriptionIsFoldOn:_topView.isFoldOn];

    CGFloat height = [NSTool getHeightWithContent:_topView.descriptionLabel.text width:_topView.width font:[UIFont systemFontOfSize:12.0f]lineOffset:3.0f];
    
    _topViewHeight = height + 270 - 32 ;
    
    [_topView updateTopViewWithHeight:(150 - 32 + height)];
//    _topView.topView.height = 150 - 32 + height;
    _topView.height = _topViewHeight;
    
    self.mainTableView.tableHeaderView = _topView;

//    
//    _mainTableView.contentInset = UIEdgeInsetsMake(_topViewHeight,0, 0, 0);
//    
//    /**
//     第一步 强制偏移，是 inset生效 
//     第二部 偏离正确距离 使界面正常布局
//*/
//    _mainTableView.contentOffset = CGPointMake(0, -ScreenHeight);
//    _mainTableView.contentOffset = CGPointMake(0, -_topViewHeight);

    
//    _myrefreshView.y = -_topViewHeight - 60;


}


-(UIView *)setPageViewControllers
{
    if (!_RCSegView) {
        
       self.leftController=[[NSThemeCommentController alloc]init];
        self.rightController =[[NSThemeCommentController alloc]init];

        self.leftController.aid = self.aid;
        self.leftController.type = [NSString stringWithFormat:@"%d",[self.type intValue] + 1];
        self.leftController.sort = 0 ;
        self.rightController.aid = self.aid;
        self.rightController.type = [NSString stringWithFormat:@"%d",[self.type intValue] + 1];
        self.rightController.sort = 1 ;
        
        NSArray *controllers=@[self.leftController,self.rightController];
        
        NSArray *titleArray =@[@"最新",@"最热"];
        
        MYSegmentView * rcs=[[MYSegmentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) controllers:controllers titleArray:titleArray ParentController:self lineWidth:ScreenWidth/2 lineHeight:3.];
        
        _RCSegView = rcs;
    }else{
        [self.leftController fetchData];
        [self.rightController fetchData];
    }
    return _RCSegView;
}

- (void)moreChoice {
    
    _maskView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _maskView.backgroundColor = [UIColor lightGrayColor];
    
    _maskView.alpha = 0.5;
    
    [self.navigationController.view addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    _maskView.hidden = YES;
    
    [_maskView addGestureRecognizer:tap];
    
    _moreChoiceView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 135)];
    
    _moreChoiceView.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.view addSubview:_moreChoiceView];
    
    

    
    NSArray *titles = @[@"去创作",@"去投稿",@"取消"];
    for (NSInteger i = 0; i < 3; i++) {
        
        UIButton *indexButton  =[UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(0, 45 * i, ScreenWidth, 45);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.tag = kButtonTag + i;
            if (i < 2) {
                UIView *line = [[UIView alloc] init];
                
                line.backgroundColor = [UIColor lightGrayColor];
                
                line.frame = CGRectMake(0, 44, ScreenWidth, 0.5);
                [btn addSubview:line];
            }
        } action:^(UIButton *btn) {
            
            [self manyChoiceClick:btn];
            
        }];
        [_moreChoiceView addSubview:indexButton];
    }
}

- (void)manyChoiceClick:(UIButton *)clickUIButton{
    
    NSInteger clickIindex = clickUIButton.tag - kButtonTag;
    
    switch (clickIindex) {
        case 0:
        {

            _maskView.hidden = YES;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                _moreChoiceView.y = ScreenHeight;
            }];
            if (JUserID) {
                
                
                [self judgeJoininActitityOperation];
                
            } else {
                
                NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
                
                [self presentViewController:loginVC animated:YES completion:nil];
            }

        }
            break;
        case 1:
        {
            _maskView.hidden = YES;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                _moreChoiceView.y = ScreenHeight;
            }];
            if (JUserID) {
                
                NSUserWorkListController *workListController = [[NSUserWorkListController alloc] init];
                workListController.workType = self.type;
                workListController.activityId = self.aid;
                [self.navigationController pushViewController:workListController animated:YES];
                
                workListController.submitBlock = ^(void){
                    self.needRefresh = YES;
                };

            }
            else {
                
                NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
                
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }
            break;
        case 2:
        {
            [self tapClick:nil];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)judgeJoininActitityOperation{
    /**
     *  0 是歌曲
     */
    if ([self.type isEqualToString:@"0"]) {
        NSAccompanyListViewController *accompanyList = [[NSAccompanyListViewController alloc] init];
        accompanyList.aid = self.aid;
        [self.navigationController pushViewController:accompanyList animated:YES];
    }else{
        NSWriteLyricViewController * writeLyricVC = [[NSWriteLyricViewController alloc] init];
        writeLyricVC.aid = self.aid;
        [self.navigationController pushViewController:writeLyricVC animated:YES];
    }
}

- (void)tapClick:(UIGestureRecognizer *)tap {
    
    _maskView.hidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _moreChoiceView.y = ScreenHeight;
    }];
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
    }else{
        _maskView.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _moreChoiceView.y = ScreenHeight - _moreChoiceView.height;
            
        }];
    }
}

#pragma mark UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /**
     * 处理联动
     */

    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    CGFloat tabOffsetY = [_mainTableView rectForSection:0].origin.y;
    //    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (yOffset>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            CHLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            CHLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
    
    
    /**
     * 处理头部视图
     */
    if(yOffset < -_topViewHeight) {
        
        CGRect f = self.topView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        f.origin.y= yOffset;
        
        //改变头部视图的fram
        self.topView.frame= f;

    }
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenHeight-64;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加pageView
    [cell.contentView addSubview:self.setPageViewControllers];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {

    /**
     *  头部
     */
    if (label.tag == kTopViewLabelTag) {
        
        [_topView setupDataWithData:self.actDataModel joinerArray:nil descriptionIsFoldOn:!_topView.isFoldOn];
        [self updateUIFrames];
    }
    
    
}
#pragma mark lazy init

- (MainTouchTableTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[MainTouchTableTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
//        _mainTableView.contentInset = UIEdgeInsetsMake(270,0, 0, 0);
        _topViewHeight = 270;
//        _mainTableView.backgroundColor = [UIColor clearColor];
    }
    
    return _mainTableView;
}

- (NSThemeTopicTopView *)topView{
    if (!_topView) {
//        _topView = [[NSThemeTopicTopView alloc] initWithFrame:CGRectMake(0, - 270, ScreenWidth, 270)];
        _topView = [[NSThemeTopicTopView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth, 270)];

        _topView.descriptionLabel.delegate = self;
        [_topView setupDataWithData:nil joinerArray:self.joinerList descriptionIsFoldOn:NO];
    }
    return _topView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)wantJoinInButton{
    if (!_wantJoinInButton) {
        _wantJoinInButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.backgroundColor = [UIColor hexColorFloat:@"ffd507"];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"ic_woyaocanjia"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            btn.clipsToBounds= YES;
            btn.layer.cornerRadius = 20.0f;
//            [btn setImage:[UIImage imageNamed:] forState:<#(UIControlState)#>]
        } action:^(UIButton *btn) {
            
            if (_isPublished) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"操作" message:@"您已经参加过本次活动，再次提交会覆盖原来的作品，请确认是否继续操作？" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续", nil];
                [alertView show];
                return;
            }
            else{
                
                _maskView.hidden = NO;
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    _moreChoiceView.y = ScreenHeight - _moreChoiceView.height;
                    
                }];
            }
        }];
    }
    
    return _wantJoinInButton;
}

- (NSMutableArray *)joinerList{
    if (!_joinerList) {
        _joinerList = [NSMutableArray array];
        
    }
    return _joinerList;
}
- (NSPlayMusicViewController *)playSongsVC {
    
    if (!_playSongsVC) {
        
        _playSongsVC = [NSPlayMusicViewController sharedPlayMusic];
    }
    
    return _playSongsVC;
}
/**
- (UIView *)myrefreshView{
    if (!_myrefreshView) {

        _myrefreshView = [[UIView alloc] initWithFrame:CGRectMake(0, -330, ScreenWidth, 60)];
        
        _myrefreshView.backgroundColor = [UIColor whiteColor];
        YDAnimatingView *infiniteImageView = [[YDAnimatingView alloc] init];
        infiniteImageView.stringTag = @"infiniteImageView";
        [_myrefreshView addSubview:infiniteImageView];
        
        // constrains
        [infiniteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(_myrefreshView);
        }];
        [infiniteImageView startAnimating];
    }
    return _myrefreshView;
}
*/


@end
