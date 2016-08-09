//
//  NSUserPageViewController.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserPageViewController.h"
#import "NSTableHeaderView.h"
#import "UINavigationItem+NSAdditions.h"
#import "NSToolbarButton.h"
#import "NSNewMusicTableViewCell.h"
#import "NSDraftBoxViewController.h"
#import "NSUserViewController.h"
#import "NSInspirationRecordTableViewCell.h"
#import "NSFansViewController.h"
#import "NSLoginViewController.h"
#import "NSUserDataModel.h"
#import "NSPlayMusicViewController.h"
#import "NSLyricViewController.h"
#import "NSInspirationRecordViewController.h"
#import "NSMyMusicModel.h"
#import "NSTopLBottomLView.h"
#define kHeadImageHeight 200
@interface NSUserPageViewController ()
<
UITableViewDelegate,
UIScrollViewDelegate,
UITableViewDataSource>
{
    
    UITableView *_tableView;
    NSString * userId;
    NSMutableArray * inspirationAry;
    NSMutableArray * myMusicAry;
    NSMutableArray * myLyricAry;
    NSMutableArray * myCollectionAry;
    NSMutableArray * dataAry;
    NSArray *toolBarArr;
    NSLoginViewController *login;
    NSString * myUrl;
    NSString * otherUrl;
    NSString * url;
    int type;
    NSTableHeaderView *headerView ;
    int page;
    UIImageView * emptyImage;
    int currentPage;
    UIImageView *headImgView;
    UIView *topView;
    UIView *backgoundView;
    CGFloat alpha;
    UIImageView *headView;
    UILabel *userNameLable;
    UILabel *signatureLabel;
    UIBarButtonItem *followItem;
    NSTopLBottomLView *focusLLView;
    NSTopLBottomLView *fansLLView;
}

@property (nonatomic, assign) NSInteger btnTag;
@property (nonatomic, strong) NSMutableArray *itemIdArr;
@end

@implementation NSUserPageViewController
- (NSMutableArray *)itemIdArr {
    if (!_itemIdArr) {
        self.itemIdArr  = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemIdArr;
}

-(instancetype)initWithUserID:(NSString *)userID_
{
    if (self = [super init]) {
        userId = userID_;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self setupUI];
    [self setupNewUI];
    type = 1;
    page = 0;
    //register  notification of refresh userpage
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserPage) name:@"refreshUserPageNotific" object:nil];
    [self fetchUserDataWithIsSelf:self.who andIsLoadingMore:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    ++page;
    if (JUserID == nil&&page ==1) {
        login = [[NSLoginViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        nav.navigationBar.hidden = YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
    UIImage *image1 = [self imageByApplyingAlpha:alpha image:[UIImage imageNamed:@"2.0_backgroundImage"]];
    [self.navigationController.navigationBar setBackgroundImage:image1 forBarMetrics:UIBarMetricsDefault];

    //    self.navigationController.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
    //    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!JUserID) {
        [self.tabBarController setSelectedIndex:0];
        page = 0;
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!JUserID) {
        [self.tabBarController setSelectedIndex:0];
        page = 0;
    }else{
        
    }
}
//receive notification to refresh userpage
- (void)refreshUserPage {
    [self fetchUserDataWithIsSelf:self.who andIsLoadingMore:NO];
}
#pragma mark -fetchMemberData
-(void)fetchUserDataWithIsSelf:(Who)who andIsLoadingMore:(BOOL)isLoadingMore
{
    //    [_tableView.infiniteScrollingView startAnimating];
    self.requestType = YES;
    
    NSMutableDictionary * userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if (!isLoadingMore) {
        self.requestParams = @{kIsLoadingMore:@(NO)};
        currentPage = 1;
    }else{
        self.requestParams = @{kIsLoadingMore:@(YES)};
        ++currentPage;
    }
    
    if (userDic) {
        
        if (who == Myself) {
            NSDictionary * dic = @{@"uid":JUserID,@"token":LoginToken,@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:type]};
            NSString * str = [NSTool encrytWithDic:dic];
            url = [userCenterURL stringByAppendingString:str];
            
        }else{
            
            NSDictionary * dic = @{@"otherid":userId,@"uid":JUserID,@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:type]};
            NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:YES];
            NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
            url = [otherCenterURL stringByAppendingString:str];
            
        }
        self.requestURL = url;
    }
    
}




#pragma mark -overrider action fetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                NSUserDataModel * userData = (NSUserDataModel *)parserObject;
                
                if (!operation.isLoadingMore) {
                    [_tableView.pullToRefreshView stopAnimating];
                    myMusicAry = [NSMutableArray arrayWithArray:userData.myMusicList.musicList];
                    for (NSMyMusicModel *model in myMusicAry) {
                        [self.itemIdArr addObject:@(model.itemId)];
                    }
                    if (self.who == Myself) {
                        headerView.userModel = userData.userDataModel.userModel;
                        headerView.otherModel = userData.userOtherModel;
                    } else {
                        headerView.userModel = userData.userDataModel.userModel;
                        headerView.otherModel = userData.userOtherModel;
                    [headView setDDImageWithURLString:userData.userDataModel.userModel.headerUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
                    userNameLable.text = userData.userDataModel.userModel.nickName;
                    signatureLabel.text = userData.userDataModel.userModel.signature;
                    focusLLView.topLabel.text = [NSString stringWithFormat:@"%zd",userData.userOtherModel.focusNum];
                    fansLLView.topLabel.text = [NSString stringWithFormat:@"%zd",userData.userOtherModel.fansNum];
                    for (int i = 0; i < toolBarArr.count; i++) {
                        UILabel *aLabel = [backgoundView viewWithTag:159 + i];
                        switch (i) {
                            case 0:
                                aLabel.text = [NSString stringWithFormat:@"%zd",userData.userOtherModel.workNum];
                                break;
                            case 1:
                                aLabel.text = [NSString stringWithFormat:@"%zd",userData.userOtherModel.lyricsNum];
                                break;
                            case 2:
                                aLabel.text = [NSString stringWithFormat:@"%zd",userData.userOtherModel.collectionNum];
                                break;
                            case 3:
                                aLabel.text = [NSString stringWithFormat:@"%zd",userData.userOtherModel.inspireNum];
                                break;
                            default:
                                break;
                        }
                    }
                    
                    if (self.who == Other) {
                        switch (userData.userOtherModel.isFocus) {
                            case 0:
                                followItem.image = [UIImage imageNamed:@"2.0_addFocus_icon"];
                                break;
                            case 1:
                                followItem.image = [UIImage imageNamed:@"2.0_focused_icon"];
                                break;
                            case 2:
                                followItem.image = [UIImage imageNamed:@"2.0_focusEach_icon"];
                                break;
                            default:
                                break;
                        }
                    }
                }else{
                    [_tableView.infiniteScrollingView stopAnimating];
                    [myMusicAry addObjectsFromArray:userData.myMusicList.musicList];
                    
                }
                
                dataAry = myMusicAry;
                if (dataAry.count == 0) {
                    emptyImage.hidden = NO;
                } else {
                    emptyImage.hidden = YES;
                }
                [_tableView reloadData];
            }else if ([operation.urlTag isEqualToString:focusUserURL]){
                [[NSToastManager manager] showtoast:parserObject.data];
                if ([parserObject.data isEqualToString:@"{mp3URL = 取消关注成功}"]) {
                    followItem.image = [UIImage imageNamed:@"2.0_addFocus_icon"];
                } else if ([parserObject.data isEqualToString:@"{mp3URL = 关注成功}"]){
                    followItem.image = [UIImage imageNamed:@"2.0_focused_icon"];
                } else {
                    followItem.image = [UIImage imageNamed:@"2.0_focusEach_icon"];
                }
            } else if ([operation.urlTag isEqualToString:deleteWorkURL]) {
                [_tableView reloadData];
            }
            if (!operation.isLoadingMore) {
                [_tableView.pullToRefreshView stopAnimating];
            }else{
                [_tableView.infiniteScrollingView stopAnimating];
            }
        }
    }
}

#pragma mark -setupUI
- (void)setupNewUI {
    
    //给导航条设置空的背景图
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    //头像
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    headView = [UIImageView new];
    
    headView.frame = CGRectMake(5, 7, 30, 30);
    
    headView.layer.cornerRadius = 15.0;
    
    headView.layer.masksToBounds = YES;
    
    [navigationView addSubview:headView];
    
    //昵称
    userNameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame) + 6, 7, ScreenWidth/2, 30)];
    
    userNameLable.font = [UIFont systemFontOfSize:15];
    
    userNameLable.textColor = [UIColor whiteColor];
    
    [navigationView addSubview:userNameLable];
    
    
    if (self.who == Myself) {
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
         [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
        
        [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [settingBtn addTarget:self action:@selector(settingOrFocusClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [navigationView addSubview:settingBtn];
        
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(navigationView).with.offset(-5);
            
            make.centerY.equalTo(navigationView.mas_centerY);
            
        }];
        
    } else {
        
        followItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_addFocus_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(followClick:)];
        
        self.navigationItem.rightBarButtonItem = followItem;
        
    }
    
    self.navigationItem.titleView = navigationView;
    
    //添加TableView
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-self.tabBarController.tabBar.size.height) style:UITableViewStylePlain];
    
    _tableView = tableView;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _tableView.showsVerticalScrollIndicator = YES;
    
    WS(wSelf);
    [self.view addSubview:_tableView];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchUserDataWithIsSelf:wSelf.who andIsLoadingMore:YES];
        }
    }];
    //loadingMore
    //    [_tableView addDDInfiniteScrollingWithActionHandler:^{
    //        if (!wSelf) {
    //            return ;
    //        }else{
    //            [wSelf fetchUserDataWithIsSelf:wSelf.who andIsLoadingMore:YES];
    //        }
    //    }];
    
    _tableView.showsInfiniteScrolling = YES;
    
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [_tableView addSubview:emptyImage];
    
    [self.view addSubview:_tableView];
    
    //添加表头视图
    
    headImgView = [[UIImageView alloc]init];
    
    headImgView.userInteractionEnabled = YES;
    
    //设置图片的模式
    headImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    //解决设置UIViewContentModeScaleAspectFill图片超出边框的问题
    headImgView.clipsToBounds = YES;
    
    headImgView.frame = CGRectMake(0, -kHeadImageHeight-60, ScreenWidth, kHeadImageHeight);
    
    //    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, headImgView.frame.size.width,headImgView.frame.size.height)];
    //
    //    toolbar.barStyle = UIBarStyleBlackTranslucent;
    //
    //    [headImgView addSubview:toolbar];
    
    headImgView.image = [UIImage imageNamed:@"2.0_backgroundImage"];
    
    signatureLabel = [[UILabel alloc] init];
    
    signatureLabel.font = [UIFont systemFontOfSize:13];
    
    signatureLabel.numberOfLines = 0;
    
    signatureLabel.textColor = [UIColor whiteColor];
    
    [headImgView addSubview:signatureLabel];
    
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headImgView.mas_left).with.offset(10);
        
        make.right.equalTo(headImgView.mas_right).with.offset(-ScreenWidth/2);
        
        make.bottom.equalTo(headImgView.mas_bottom).with.offset(-10);
    }];
    
    //关注
    
    focusLLView = [[NSTopLBottomLView alloc] init];
    
    focusLLView.bottomLabel.text = @"关注";
    
    [headImgView addSubview:focusLLView];
    
    [focusLLView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(headImgView.mas_bottom).with.offset(-5);
        
        make.right.equalTo(headImgView).with.offset(-10);
        
        make.height.mas_equalTo(32);
        
    }];
    
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followBtnClick:)];
    
    [focusLLView addGestureRecognizer:focusTap];
    
    UIView *midLineView = [[UIView alloc] init];
    
    midLineView.backgroundColor = [UIColor whiteColor];
    
    [headImgView addSubview: midLineView];
    
    [midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(headImgView.mas_bottom).with.offset(-5);
        
        make.right.equalTo(focusLLView.mas_left).with.offset(-4.7);
        
        make.width.mas_equalTo(0.6);
        
        make.height.mas_equalTo(30);
        
    }];
    
    //粉丝
    
    fansLLView = [[NSTopLBottomLView alloc] init];
    
    fansLLView.bottomLabel.text = @"粉丝";
    
    [headImgView addSubview:fansLLView];
    
    [fansLLView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(headImgView.mas_bottom).with.offset(-5);
        
        make.right.equalTo(focusLLView.mas_left).with.offset(-10);
        
        make.height.mas_equalTo(32);
        
    }];
    
    UITapGestureRecognizer *fansTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansBtnClick:)];
    
    [fansLLView addGestureRecognizer:fansTap];
    
    [_tableView addSubview:headImgView];
    
    
    if (self.who == Myself) {
        toolBarArr = @[@"歌曲",@"歌词",@"收藏",@"灵感记录"];
    }else{
        toolBarArr = @[@"歌曲",@"歌词",@"收藏"];
    }
    
    backgoundView = [[UIView alloc] initWithFrame:CGRectMake(0, -60, ScreenWidth, 60)];
    
    backgoundView.backgroundColor = [UIColor whiteColor];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    line1.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
    
    [backgoundView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 1)];
    
    line2.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
    
    [backgoundView addSubview:line2];
    
    CGFloat W = ScreenWidth / toolBarArr.count;
    
    for (int i = 0; i < toolBarArr.count; i++) {
        
        if (i != 0) {
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(W * i, 0, 1, 60)];
            
            line.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
            
            [backgoundView addSubview:line];
        }
        UILabel  *toolbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(W*i, 10, W, 20)];
        
        toolbarLabel.textColor = [UIColor hexColorFloat:@"666666"];
        
        toolbarLabel.textAlignment = NSTextAlignmentCenter;
        
        toolbarLabel.font = [UIFont systemFontOfSize:12];
        
        toolbarLabel.tag = 159 + i;
        
        [backgoundView addSubview:toolbarLabel];
        
        NSToolbarButton *toolbarBtn = [[NSToolbarButton alloc] initWithFrame:CGRectMake(W * i, 0, W, 60)];
        
        toolbarBtn.backgroundColor = [UIColor clearColor];
        
//        [toolbarBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"2.0_toolbarBtn%02d",i]] forState:UIControlStateNormal];
//        
        [toolbarBtn setTitle:toolBarArr[i] forState:UIControlStateNormal];
        
        toolbarBtn.tag = i;
        
        [toolbarBtn addTarget:self action:@selector(toolbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backgoundView addSubview:toolbarBtn];
        
    }
    [_tableView addSubview:backgoundView];
    
    _tableView.contentInset = UIEdgeInsetsMake(kHeadImageHeight + 60, 0, 0, 0);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"tableView.contentOffset.y %f",_tableView.contentOffset.y);
    
    CGFloat offSet_Y = _tableView.contentOffset.y;
    
    if (offSet_Y<-kHeadImageHeight-60) {
        //获取imageView的原始frame
        CGRect frame = headImgView.frame;
        //        NSLog(@"旧的frame%f",frame.size.height);
        //修改y
        frame.origin.y = offSet_Y;
        //        NSLog(@"offset.y %f",offSet_Y);
        //修改height
        frame.size.height = -offSet_Y - 60;
        //重新赋值
        headImgView.frame = frame;
        
        //        NSLog(@"新的frame%f",frame.size.height);
        
    }
    //tableView相对于图片的偏移量
    CGFloat reoffSet = offSet_Y + kHeadImageHeight + 60;
    
    //    NSLog(@"%f",reoffSet);
    //kHeadImageHeight-64是为了向上拉倒导航栏底部时alpha = 1
    alpha = reoffSet/(kHeadImageHeight -64);
    
//    NSLog(@"%f",alpha);
    
    if (alpha>=1) {
        alpha = 0.99;
        CGRect frame = backgoundView.frame;
        
        frame.origin.y = 64;
        
        backgoundView.frame = frame;
        
        [self.view addSubview:backgoundView];
    } else {
        CGRect frame = backgoundView.frame;
        
        frame.origin.y = -60;
        
        backgoundView.frame = frame;
        
        [_tableView addSubview:backgoundView];
    }
    
    UIImage *image1 = [self imageByApplyingAlpha:alpha image:[UIImage imageNamed:@"2.0_backgroundImage"]];
    if (alpha <= 0) {
        [self.navigationController.navigationBar setBackgroundImage:image1 forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[image1 applyLightEffect] forBarMetrics:UIBarMetricsDefault];
    }
    
}
//改变图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alp  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0,  image.size.height-64, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alp);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)setupUI {
    
    headerView = [[NSTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 290)];
    
    if (self.who == Myself) {
        
        //        NSMutableArray *array = [NSMutableArray array];
        
        UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settingClick:)];
        
        //        [array addObject:setting];
        
        self.navigationItem.rightBarButtonItem = setting;
        
    }
    
    if (self.who == Other) {
        
        UIBarButtonItem *follow = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_follow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(followClick:)];
        
        self.navigationItem.rightBarButtonItem = follow;
        
    }
    
    
    //    [headerView.followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [headerView.fansBtn addTarget:self action:@selector(fansBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    //    _tableView.tableHeaderView = headerView;
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _tableView.showsVerticalScrollIndicator = YES;
    WS(wSelf);
    [self.view addSubview:_tableView];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchUserDataWithIsSelf:wSelf.who andIsLoadingMore:YES];
        }
    }];
    //loadingMore
    //    [_tableView addDDInfiniteScrollingWithActionHandler:^{
    //        if (!wSelf) {
    //            return ;
    //        }else{
    //            [wSelf fetchUserDataWithIsSelf:wSelf.who andIsLoadingMore:YES];
    //        }
    //    }];
    
    _tableView.showsInfiniteScrolling = YES;
    
    
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    emptyImage.centerX = ScreenWidth/2;
    emptyImage.y = 380;
    [_tableView addSubview:emptyImage];
    
}

- (void)followBtnClick:(UIGestureRecognizer *)tap {
    if (self.who == Myself) {
        NSFansViewController * myFocusVC = [[NSFansViewController alloc] initWithUserID:JUserID _isFans:NO isWho:Myself];
        [self.navigationController pushViewController:myFocusVC animated:YES];
    }
    
    if (self.who == Other) {
        
        NSFansViewController * otherFocusVC = [[NSFansViewController alloc] initWithUserID:userId _isFans:NO isWho:Other];
        [self.navigationController pushViewController:otherFocusVC animated:YES];
    }
    
}

- (void)fansBtnClick:(UIGestureRecognizer *)tap {
    if (self.who == Myself) {
        NSFansViewController * myFansVC = [[NSFansViewController alloc] initWithUserID:JUserID _isFans:YES isWho:Myself];
        [self.navigationController pushViewController:myFansVC animated:YES];
    }
    
    if (self.who == Other) {
        NSFansViewController * otherFansVC = [[NSFansViewController alloc] initWithUserID:userId _isFans:YES isWho:Other];
        [self.navigationController pushViewController:otherFansVC animated:YES];
    }
    
}



- (void)settingOrFocusClick:(UIButton *)sender {
    
        NSUserViewController * userSettingVC = [[NSUserViewController alloc] init];
        [self.navigationController pushViewController:userSettingVC animated:YES];
        
}


- (void)draftBoxClick:(UIBarButtonItem *)record {
    
    NSDraftBoxViewController *draftBox = [[NSDraftBoxViewController alloc] init];
    
    [self.navigationController pushViewController:draftBox animated:YES];
    
}

- (void)followClick:(UIBarButtonItem *)follow {
    
    [self focusUserWithUserId:userId];
    
}


-(void)focusUserWithUserId:(NSString *)userId_
{
    self.requestType = NO;
    self.requestParams =@{@"userid":userId_,@"fansid":JUserID,@"token":LoginToken};
    self.requestURL = focusUserURL;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.btnTag == 0) {
        
        static NSString *ID = @"cell0";
        
        NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
        
        cell.numLabel.hidden = YES;
        cell.myMusicModel = dataAry[indexPath.row];
        return cell;
        
        
    } else if (self.btnTag == 1) {
        
        static NSString *ID = @"cell1";
        
        NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
        cell.myMusicModel = dataAry[indexPath.row];
        cell.numLabel.hidden = YES;
        
        return cell;
        
        
    } else if (self.btnTag == 2) {
        
        static NSString * ID = @"cell0";
        
        NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
        cell.myMusicModel = dataAry[indexPath.row];
        cell.numLabel.hidden = YES;
        
        return cell;
        
    } else {
        
        static NSString *ID= @"cell3";
        
        NSInspirationRecordTableViewCell *cell =(NSInspirationRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[NSInspirationRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
        }
        cell.myInspirationModel = dataAry[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.btnTag == 0 || self.btnTag == 1 || self.btnTag == 2) {
        
        return 80;
    } else {
        
        return 140;
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 60;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    NSArray *array;
//
//    if (self.who == Myself) {
//       array = @[@"歌曲",@"歌词",@"收藏",@"灵感记录"];
//    }else{
//        array = @[@"歌曲",@"歌词",@"收藏"];
//    }
//
//    UIView *backgoundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
//
//    backgoundView.backgroundColor = [UIColor whiteColor];
//
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
//
//    line1.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
//
//    [backgoundView addSubview:line1];
//
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 1)];
//
//    line2.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
//
//    [backgoundView addSubview:line2];
//
//    CGFloat W = ScreenWidth / array.count;
//
//    for (int i = 0; i < array.count; i++) {
//
//        if (i != 0) {
//
//            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(W * i, 0, 1, 60)];
//
//            line.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
//
//            [backgoundView addSubview:line];
//        }
//
//        NSToolbarButton *toolbarBtn = [[NSToolbarButton alloc] initWithFrame:CGRectMake(W * i, 0, W, 60)];
//
//        [toolbarBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"2.0_toolbarBtn%02d",i]] forState:UIControlStateNormal];
//
//        [toolbarBtn setTitle:array[i] forState:UIControlStateNormal];
//
//        toolbarBtn.tag = i;
//
//        [toolbarBtn addTarget:self action:@selector(toolbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//        [backgoundView addSubview:toolbarBtn];
//
//    }
//
//    return backgoundView;
//}

#pragma mark -tableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMyMusicModel * myMusic = dataAry[indexPath.row];
    
    if (type == 1) {
        NSPlayMusicViewController * playVC = [[NSPlayMusicViewController alloc] init];
        playVC.itemUid = myMusic.itemId;
        playVC.from = @"homepage";
        playVC.geDanID = 0;
        playVC.songID = indexPath.row;
        playVC.songAry = self.itemIdArr;
        BOOL isH = false;
        for (id vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[NSPlayMusicViewController class]]) {
                isH = YES;
            }
        }
        if (isH) {
            [self.navigationController popToViewController:playVC animated:YES];
        }else{
            [self.navigationController pushViewController:playVC animated:YES];
        }
    }else if (type == 2){
        NSLyricViewController * lyricVC =[[NSLyricViewController alloc] initWithItemId:myMusic.itemId];
        if (self.who == Myself ) {
            lyricVC.who = My;
        }else{
            lyricVC.who = His;
        }
        
        [self.navigationController pushViewController:lyricVC animated:YES];
    }else if (type == 3){
        
        if (myMusic.type == 1) {
            NSPlayMusicViewController * playVC = [[NSPlayMusicViewController alloc] init];
            playVC.itemUid = myMusic.itemId;
            playVC.from = @"myfov";
            playVC.geDanID = 0;
            BOOL isH = false;
            for (id vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[NSPlayMusicViewController class]]) {
                    isH = YES;
                }
            }
            if (isH) {
                [self.navigationController popToViewController:playVC animated:YES];
            }else{
                [self.navigationController pushViewController:playVC animated:YES];
            }
            
            
        }else{
            NSLyricViewController * lyricVC =[[NSLyricViewController alloc] initWithItemId:myMusic.itemId];
            [self.navigationController pushViewController:lyricVC animated:YES];
            
        }
        
    }else if (type == 4){
        
        NSInspirationRecordViewController * inspirationVC = [[NSInspirationRecordViewController alloc] initWithItemId:myMusic.itemId andType:NO];
        [self.navigationController pushViewController:inspirationVC animated:YES];
    }
    
}

- (void)toolbarBtnClick:(UIButton *)toolbarBtn {
    
    switch (toolbarBtn.tag) {
            
        case 0: {
            
            self.btnTag = toolbarBtn.tag;
            type = 1 ;
            [self fetchUserDataWithIsSelf:self.who andIsLoadingMore:NO];
            //            [_tableView reloadData];
            if (dataAry.count != 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
            
            
            break;
        }
        case 1: {
            
            self.btnTag = toolbarBtn.tag;
            
            type = 2;
            [self fetchUserDataWithIsSelf:self.who andIsLoadingMore:NO];
            //            [_tableView reloadData];
            
            if (dataAry.count != 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
            
            
            break;
        }
        case 2: {
            
            self.btnTag = toolbarBtn.tag;
            type = 3;
            [self fetchUserDataWithIsSelf:self.who andIsLoadingMore:NO];
            //            [_tableView reloadData];
            
            if (dataAry.count != 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
            
            break;
        }
        case 3: {
            
            self.btnTag = toolbarBtn.tag;
            type = 4;
            [self fetchUserDataWithIsSelf:self.who andIsLoadingMore:NO];
            
            //            [_tableView reloadData];
            
            if (dataAry.count != 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                
            }
            
            break;
        }
        default:
            
            
            break;
    }
}

#pragma mark edit
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.who == Myself) {
        
        return YES;
    } else {
        
        return NO;
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        self.requestType = NO;
        NSMyMusicModel * myMode = dataAry[indexPath.row];
        if (type == 3) {
            self.requestParams = @{@"work_id":@(myMode.itemId),@"target_uid":@(myMode.userID),@"user_id":JUserID,@"token":LoginToken,@"wtype":@(myMode.type),};
            self.requestURL = collectURL;
        }else{
            
            if (type == 4) {
                type = 3;
            }
            self.requestParams = @{@"id": @(myMode.itemId), @"type": @(type),@"token":LoginToken};
            
            self.requestURL = deleteWorkURL;
        }
        
        [dataAry removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView reloadData];
        
    }
}


#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    scrollView.contentInset = UIEdgeInsetsMake((scrollView.contentOffset.y >= 210? 64 :0), 0, 0, 0);
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor colorWithRed:255 / 255.0 green:211 / 255.0 blue:0 alpha:scrollView.contentOffset.y / 64] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
//
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:211 / 255.0 blue:0 alpha:scrollView.contentOffset.y / 64];
//
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//
////    _tableView.contentInset = UIEdgeInsetsMake((_tableView.contentOffset.y >= 210? 64 :0), 0, 0, 0);
//
//    [super viewWillAppear:animated];
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor colorWithRed:255 / 255.0 green:211 / 255.0 blue:0 alpha:_tableView.contentOffset.y / 64] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:211 / 255.0 blue:0 alpha:_tableView.contentOffset.y / 64];
//    
//    
//}

-(void)setWho:(Who)who
{
    _who = who;
    //    [self setupUI];
}

@end







