//
//  NSUserPageViewController.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

static NSInteger const kButtonTag = 200;
#define kDefaultImage [UIImage imageNamed:@"2.0_backgroundImage"]

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
#import "NSGetQiNiuModel.h"
#import "UIImageView+Webcache.h"
#import <Accelerate/Accelerate.h>
#import "GPUImage.h"
#import "NSImagePicker.h"
#import "NSHeadImageView.h"
#import "NSDiscoverMoreLyricModel.h"
#import "NSCooperationDetailModel.h"
#define kHeadImageHeight 264
@interface NSUserPageViewController ()
<
UITableViewDelegate,
UIScrollViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
UINavigationControllerDelegate,
NSImagePickerDelegate,
NSTipViewDelegate>
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
    NSString *_listUrl;
    NSString *_userDataUrl;
    NSString *headerUrl;
    NSString *_qiniuUrl;
    int type;
    NSTableHeaderView *headerView ;
    int page;
    UIImageView * emptyImage;
    int currentPage;
    NSHeadImageView *headImgView;
    UIView *topView;
    UIView *backgoundView;
    CGFloat alpha;
    UIImageView *headView;
    UILabel *userNameLable;
    UILabel *signatureLabel;
    UIBarButtonItem *followItem;
    NSTopLBottomLView *focusLLView;
    NSTopLBottomLView *fansLLView;
    UIView *_midLine;
    NSString *_sdCachePath;
    NSTipView *_tipView;
    UIView *_maskView;
    long cooperationProductId;
}

@property (nonatomic, assign) NSInteger btnTag;
@property (nonatomic, strong) NSMutableArray *itemIdArr;

@property (nonatomic,copy) NSString *imageTitleStr;
@property (nonatomic,strong) UIImage *bgImage;
@property (nonatomic,strong) UIAlertController *alertView;

@end
static NSString *ID0 = @"cell0";
static NSString *ID1 = @"cell1";
static NSString *ID3 = @"cell3";
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
    [self fetchListWithIsSelf:self.who andIsLoadingMore:NO];

    [self fetchUserData];
}



- (void)leftBackClick{
    [self.navigationController popViewControllerAnimated:YES];
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
//    UIImage *image1 = [self imageByApplyingAlpha:alpha image:kDefaultImage];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.hidden = NO;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!JUserID) {
        [self.tabBarController setSelectedIndex:0];
        page = 0;
    }
    /**
     *  是导航栏吧白色，解决前面透明的跳入显示不正确
     */



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
    headerUrl = @"";
    [self fetchUserData];
    [self fetchListWithIsSelf:self.who andIsLoadingMore:NO];
}
#pragma mark -fetchMemberData


-(void)fetchUserData
{
    self.requestType = YES;
    
    NSString *neededUserId = @"";
    NSString *neededUrl = @"";
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setValuesForKeysWithDictionary:@{@"uid":JUserID,@"token":LoginToken}];
  

    if (self.who == Myself) {

        neededUrl = myUserCenterDefaultUrl;
    }else{

        neededUrl = otherUserCenterDefaultUrl;
        [parameters setValue:userId forKey:@"otherid"];
    }
    NSString * str = [NSTool encrytWithDic:parameters];
    _userDataUrl = [neededUrl stringByAppendingString:str];
    self.requestURL = _userDataUrl;
    
}

-(void)fetchListWithIsSelf:(Who)who andIsLoadingMore:(BOOL)isLoadingMore
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
            _listUrl = [myUserCenterListUrl stringByAppendingString:str];
        }else{
            NSDictionary * dic = @{@"otherid":userId,@"uid":JUserID,@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:type]};
            NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:YES];
            NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
            _listUrl = [otherUserCenterListUrl stringByAppendingString:str];
        }
        self.requestURL = _listUrl;
    }
}

/**
 *  上传背景图片信息
 *
 *  @param imageUrl <#imageUrl description#>
 */
- (void)postBgImageWithImageUrl:(NSString *)imageUrl{
    

    self.requestType = NO;
    self.requestParams = @{@"uid":JUserID,
                           @"bgpic":imageUrl,
                           @"token":LoginToken};
    self.requestURL = uploadBgimageUrl;
    
}




#pragma mark -overrider action fetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:_userDataUrl]) {
                NSUserDataModel * userData = (NSUserDataModel *)parserObject;
                
                if (!operation.isLoadingMore) {
                    [_tableView.pullToRefreshView stopAnimating];

                    if (!headerUrl.length) {
                        [headView setDDImageWithURLString:userData.userDataModel.userModel.headerUrl placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
                        userNameLable.text = userData.userDataModel.userModel.nickName;
                        signatureLabel.text = userData.userDataModel.userModel.signature;
                        focusLLView.topLabel.text = [NSString stringWithFormat:@"%zd",userData.userOtherModel.focusNum];
                        fansLLView.topLabel.text = [NSString stringWithFormat:@"%zd",userData.userOtherModel.fansNum];
                    }
                    headerUrl = userData.userDataModel.userModel.headerUrl;
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
                                aLabel.text = [NSString stringWithFormat:@"%zd",userData.userOtherModel.cooperationNum];
                                break;
                            default:
                                break;
                        }
                    }
                    
                    NSString *backgrountImageUrl =userData.userDataModel.userModel.bgPic;
                    
                    /**
                     *  背景图
                     */
                    
                    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userData.userDataModel.userModel.bgPic];
                    NSLog(@"%@",originalImage);
                    if (originalImage) {
                        self.bgImage = originalImage;
                        headImgView.image = self.bgImage;
                        
                    }else{
                        [headImgView sd_setImageWithURL:[NSURL URLWithString:backgrountImageUrl] placeholderImage:kDefaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            
                            /**
                             *  缓存背景图片到本地
                             */
                            self.bgImage = image;
                            
                            headImgView.image = self.bgImage;
                        }];
                    }
                    if (self.who == Other) {
                        
                        [headImgView sd_setImageWithURL:[NSURL URLWithString:backgrountImageUrl] placeholderImage:kDefaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            
                            /**
                             *  缓存背景图片到本地
                             */
                            self.bgImage = image;
                            headImgView.image = self.bgImage;
                            
                        }];
                        
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
                
//                dataAry = myMusicAry;
//                if (dataAry.count == 0) {
//                    emptyImage.hidden = NO;
//                } else {
//                    emptyImage.hidden = YES;
//                }
//                [_tableView reloadData];
            }
            else if ([operation.urlTag isEqualToString:_listUrl]){
                
                NSDiscoverMoreLyricModel *listModel = (NSDiscoverMoreLyricModel *)parserObject;
                if (!operation.isLoadingMore) {
                    [_tableView.pullToRefreshView stopAnimating];
                    if (self.btnTag == 203) {
                        myMusicAry = [NSMutableArray arrayWithArray:listModel.cooperateProduct];
                    } else {
                        myMusicAry = [NSMutableArray arrayWithArray:listModel.moreLyricList];
                    }
                }else{
                    [_tableView.infiniteScrollingView stopAnimating];
                    if (self.btnTag == 203) {
                        [myMusicAry addObjectsFromArray:listModel.cooperateProduct];
                    } else {
                        
                        [myMusicAry addObjectsFromArray:listModel.moreLyricList];
                    }
                }
                if (self.btnTag == 203) {
                    for (NSCooperateProductModel *model in myMusicAry) {
                        [self.itemIdArr addObject:@(model.itemid)];
                    }
                } else {
                    for (NSMyMusicModel *model in myMusicAry) {
                        [self.itemIdArr addObject:@(model.itemId)];
                    }
                }
                dataAry = myMusicAry;
                if (dataAry.count == 0) {
                    emptyImage.hidden = NO;
                } else {
                    emptyImage.hidden = YES;
                }
                [_tableView reloadData];
            }
            else if ([operation.urlTag isEqualToString:focusUserURL]){
                
                [[NSToastManager manager] showtoast:parserObject.data[@"mp3URL"]];
                
                if ([parserObject.data[@"mp3URL"] isEqualToString:@"取消关注成功"]) {
                    
                    followItem.image = [UIImage imageNamed:@"2.0_addFocus_icon"];
                } else if ([parserObject.data[@"mp3URL"] isEqualToString:@"关注成功"]){
                    
                    followItem.image = [UIImage imageNamed:@"2.0_focused_icon"];
                } else {
                    
                    followItem.image = [UIImage imageNamed:@"2.0_focusEach_icon"];
                }

            } else if ([operation.urlTag isEqualToString:deleteWorkURL] || [operation.urlTag isEqualToString:deleteCooperationProductUrl]) {
                if (parserObject.code == 200) {
                    [self fetchListWithIsSelf:self.who andIsLoadingMore:NO];
                    [self fetchUserData];
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
                

            } else if ([operation.urlTag isEqualToString:_qiniuUrl]){
                NSGetQiNiuModel *qiNiuModel = (NSGetQiNiuModel *)parserObject;
//                [self postBgImageWithImageUrl:[NSString stringWithFormat:@"%@.png",qiNiuModel.qiNIuModel.fileName]];
                
                qiNiu * data = qiNiuModel.qiNIuModel;
                NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"backgroundImage.png"];
                [self uploadPhotoWith:fullPath type:YES token:data.token url:data.qiNIuDomain];
                
            } else if ([operation.urlTag isEqualToString:uploadBgimageUrl]){
                [self.alertView dismissViewControllerAnimated:YES completion:^{
                    
                    [[NSToastManager manager] showtoast:@"上传成功"];
                    headImgView.image = self.bgImage;
                }];
            } else if ([operation.urlTag isEqualToString:changeMusicStatus] || [operation.urlTag isEqualToString:changeLyricStatus]) {
                [self fetchListWithIsSelf:self.who andIsLoadingMore:NO];
                [self fetchUserData];

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
    
    
//    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_playSongs_pop"] style:UIBarButtonItemStylePlain target:self action:@selector(getBack)];
//        self.navigationItem.leftBarButtonItem = back;
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
    
    
//    if (self.who == Myself) {
//        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        
//         [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
//        
//        [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        [settingBtn addTarget:self action:@selector(settingOrFocusClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [navigationView addSubview:settingBtn];
//        
//        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.right.equalTo(navigationView).with.offset(-5);
//            
//            make.centerY.equalTo(navigationView.mas_centerY);
//            
//        }];
//        
//    } else
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2.0_playSongs_pop"]];
    leftImageView.userInteractionEnabled= YES;
    [leftImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBackClick)]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftImageView];
    if (self.who == Other){
        
        followItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_addFocus_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(followClick:)];
        self.navigationItem.rightBarButtonItem = followItem;
//        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2.0_addFocus_icon"]];
//        rightImageView.userInteractionEnabled= YES;
//        [rightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followClick:)]];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightImageView];
        
        
    }
    
    self.navigationItem.titleView = navigationView;
    UITableView *tableView;
    //添加TableView
    if (self.who == Other) {
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    }else{
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    }
    _tableView = tableView;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [_tableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:ID0];
    [_tableView registerClass:[NSInspirationRecordTableViewCell class] forCellReuseIdentifier:ID1];
    
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    
    WS(wSelf);
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchListWithIsSelf:wSelf.who andIsLoadingMore:YES];
        }
    }];
    
    _tableView.showsInfiniteScrolling = YES;
    
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [_tableView addSubview:emptyImage];
    
    [self.view addSubview:_tableView];
    
    //添加表头视图
    
    headImgView = [[NSHeadImageView alloc]initWithFrame:CGRectMake(0, -kHeadImageHeight-60, ScreenWidth, kHeadImageHeight)];
   
    //    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, headImgView.frame.size.width,headImgView.frame.size.height)];
    //
    //    toolbar.barStyle = UIBarStyleBlackTranslucent;
    //
    //    [headImgView addSubview:toolbar];
    

    if (self.who == Myself) {
        /**
         *  背景图片添加点击事件
         */
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];

        headImgView.userInteractionEnabled = YES;

        [headImgView addGestureRecognizer:tap];
        

    }
    /**
     签名
    */
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
    _midLine = midLineView;
    [midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(headImgView.mas_bottom).with.offset(-5);
        
//        make.right.equalTo(focusLLView.mas_left).with.offset(-4.7);
        make.right.equalTo(focusLLView.mas_left).with.offset(-10);

        make.width.mas_equalTo(0.6);
        
        make.height.mas_equalTo(30);
        
    }];
    
    //粉丝
    
    fansLLView = [[NSTopLBottomLView alloc] init];
    
    fansLLView.bottomLabel.text = @"粉丝";
    
    [headImgView addSubview:fansLLView];
    
    [fansLLView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(headImgView.mas_bottom).with.offset(-5);
        
        make.right.equalTo(midLineView.mas_left).with.offset(-10);

        make.height.mas_equalTo(32);
        
    }];
    
    UITapGestureRecognizer *fansTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansBtnClick:)];
    
    [fansLLView addGestureRecognizer:fansTap];
    
    [_tableView addSubview:headImgView];
    
    
    if (self.who == Myself) {
        toolBarArr = @[@"歌曲",@"歌词",@"收藏",@"合作作品"];
    }else{
        toolBarArr = @[@"歌曲",@"歌词",@"收藏",@"合作作品"];
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
        
        
        UILabel  *toolbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(W*i, 10, W, 20)];
        
        toolbarLabel.textColor = [UIColor hexColorFloat:@"666666"];
        
        toolbarLabel.textAlignment = NSTextAlignmentCenter;
        
        toolbarLabel.font = [UIFont systemFontOfSize:12];
        
        toolbarLabel.tag = 159 + i;
        
        
        NSToolbarButton *toolbarBtn = [[NSToolbarButton alloc] initWithFrame:CGRectMake(W * i, 0, W, 60)];
        
//        toolbarBtn.backgroundColor = [UIColor clearColor];
        
//        [toolbarBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"2.0_toolbarBtn%02d",i]] forState:UIControlStateNormal];
//        
        [toolbarBtn setTitle:toolBarArr[i] forState:UIControlStateNormal];
        
        [toolbarBtn setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"e3e3e3"] renderSize:toolbarBtn.size] forState:UIControlStateSelected];
        [toolbarBtn setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:toolbarBtn.size] forState:UIControlStateNormal];

        toolbarBtn.tag = i + kButtonTag;
        
        [toolbarBtn addTarget:self action:@selector(toolbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backgoundView addSubview:toolbarBtn];
        [backgoundView addSubview:toolbarLabel];
        if (i != 0) {
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(W * i, 0, 1, 60)];
            
            line.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
            
            [backgoundView addSubview:line];
        }
        if (i==0) {
            self.btnTag = toolbarBtn.tag;
            toolbarBtn.selected = YES;
        }
    }
    [_tableView addSubview:backgoundView];
    
    _tableView.contentInset = UIEdgeInsetsMake(kHeadImageHeight + 60, 0, 0, 0);
}

/**
 *  点击封面
 *
 *  @param tap 点击
 */
- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [photoActionSheet showInView:self.view];
}

#pragma mark -uploadPhoto
-(void)uploadPhotoWith:(NSString *)photoPath type:(BOOL)type_ token:(NSString *)token url:(NSString *)url
{
    WS(wSelf);

    self.alertView = [UIAlertController alertControllerWithTitle:nil message:@"背景正在上传，请稍后..." preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:self.alertView animated:YES completion:^{
        
        //    __block NSString * file = titleImageURL;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:photoPath]) {
            QNUploadManager * upManager = [[QNUploadManager alloc] init];
            
            NSData *imageData = [NSData dataWithContentsOfFile:photoPath];
            UIImage *image = [UIImage imageWithContentsOfFile:photoPath];
            
            //修改size
            UIImage *scaledImage = [UIImage image:image  byScalingToSize:CGSizeMake(ScreenWidth * 2, kHeadImageHeight * 2)];

            /**
             *  压缩上传
             *
             *  @param image 原图
             *  @param 0.3   压缩系数
             *
             *  @return 压缩二进制
             */
            NSData *data =  UIImageJPEGRepresentation(scaledImage, 1);
            UIImage *compressImage = scaledImage;
            
            for (NSInteger i = 0; i < 5; i ++) {
                if (data.length < 200000) {
                    break;
                }
                data = UIImageJPEGRepresentation(compressImage, 0.8);
                compressImage =[UIImage imageWithData:data];
//                NSLog(@"%lu,/n%@",(unsigned long)data.length,compressImage);
            }
            
            self.bgImage = compressImage;
            NSLog(@"imageData %ld data %ld",(unsigned long)imageData.length,(unsigned long)data.length);
            [upManager putData:data key:[NSString stringWithFormat:@"%.f.jpg",[date getTimeStamp]] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                wSelf.imageTitleStr = [NSString stringWithFormat:@"%@",[resp objectForKey:@"key"]];
                NSString *totalStr = [NSString stringWithFormat:@"http://pic.yinchao.cn/%@",wSelf.imageTitleStr];
                [[NSUserDefaults standardUserDefaults] setObject:totalStr forKey:@"bgPic"];
                
                [self postBgImageWithImageUrl:wSelf.imageTitleStr];
                
                
            } option:nil];
        }
        
    }];
   
    
//    return file;
}

//#pragma mark -UIImagePickerControllerDelegate
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    UIImage * backgroundImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    
//
//    [NSTool saveImage:backgroundImage withName:@"backgroundImage.png"];
//
//    
//    
//
//    [self dismissViewControllerAnimated:YES completion:^{
//        /**
//         *  获取七牛图片token
//         */
//        _qiniuUrl = [self getQiniuDetailWithType:1 andFixx:@"lyrcover"];
//
//    }];
//    
//}
#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex <= 1) {
        NSImagePicker *imagePicker = [NSImagePicker sharedInstance];
        imagePicker.delegate = self;
        [imagePicker showImagePickerWithType:buttonIndex InViewController:self Scale:kHeadImageHeight/ScreenWidth];
    }else{
        
    }


    
}

#pragma mark - NSImagePickerDelegate

- (void)imagePickerDidCancel:(NSImagePicker *)imagePicker{
    
}
- (void)imagePicker:(NSImagePicker *)imagePicker didFinished:(UIImage *)editedImage{
    UIImage * backgroundImage = editedImage;
    
    
    [NSTool saveImage:backgroundImage withName:@"backgroundImage.png"];
    
    
//    [self dismissViewControllerAnimated:YES completion:^{
        /**
         *  获取七牛图片token
         */
        _qiniuUrl = [self getQiniuDetailWithType:1 andFixx:@"lyrcover"];
        
//    }];
}

#pragma mark - scrolldelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

//    CHLog(@"tableView.contentOffset.y %f",_tableView.contentOffset.y);
    
    CGFloat offSet_Y = _tableView.contentOffset.y;
    
    if (offSet_Y<-kHeadImageHeight-60) {
        //获取imageView的原始frame
        CGRect frame = headImgView.frame;
//        CHLog(@"旧的frame%f",frame.size.height);
        //修改y
        frame.origin.y = offSet_Y;
//        CHLog(@"offset.y %f",offSet_Y);
        //修改height
        frame.size.height = -offSet_Y - 60;
        //重新赋值
        headImgView.frame = frame;
//        CHLog(@"新的frame%f",frame.size.height);
        
    }else if(offSet_Y >= -kHeadImageHeight - 64 && offSet_Y <= - (64 + 64 + 60)){
        signatureLabel.hidden = NO;
        focusLLView.hidden = NO;
        fansLLView.hidden = NO;
        _midLine.hidden = NO;
        
        
        if (backgoundView.superview != _tableView) {
            /**
             *  四个标签放回tableview跟随
             */
            CGRect frame = backgoundView.frame;
            frame.origin.y = -60;
            backgoundView.frame = frame;
            [_tableView addSubview:backgoundView];
        }
        
        CGRect bgImageFrame = headImgView.frame;
        bgImageFrame.origin.y = -60 - kHeadImageHeight;
        bgImageFrame.size.height = kHeadImageHeight;
        headImgView.frame = bgImageFrame;
        [_tableView addSubview:headImgView];
    }else if (offSet_Y >=- (64 + 64 + 60)&& offSet_Y < -(64 + 60)){
        /**
         *  该步开始 文本小时 headImg开始模糊
         */
        signatureLabel.hidden = YES;
        focusLLView.hidden = YES;
        fansLLView.hidden = YES;
        _midLine.hidden = YES;
        /**
         *  四个标签放回tableview跟随
         */
        CGRect frame = backgoundView.frame;
        frame.origin.y = -60;
        backgoundView.frame = frame;
        [_tableView addSubview:backgoundView];
        /**
         *  封面
         */
        CGRect bgImageFrame = headImgView.frame;
        bgImageFrame.origin.y = -60 - kHeadImageHeight;
        bgImageFrame.size.height = kHeadImageHeight;
        headImgView.frame = bgImageFrame;
        [_tableView addSubview:headImgView];
    }else if(offSet_Y >= -(64 + 60)){
        /**
         *  完全模糊
         */
        signatureLabel.hidden = YES;
        focusLLView.hidden = YES;
        fansLLView.hidden = YES;
        _midLine.hidden = YES;
        
        /**
         *  到顶端 保持上半部分悬浮
         */
        
        CGRect bgImageFrame = headImgView.frame;
        bgImageFrame.origin.y = 64 - kHeadImageHeight;
        headImgView.frame = bgImageFrame;
        [self.view addSubview:headImgView];

        CGRect frame = backgoundView.frame;
        frame.origin.y = 64;
        backgoundView.frame = frame;
        [self.view addSubview:backgoundView];
    }
    //tableView相对于图片的偏移量
    CGFloat reoffSet = offSet_Y + kHeadImageHeight + 60;
    //kHeadImageHeight-64是为了向上拉倒导航栏底部时alpha = 1
    alpha =1 - (kHeadImageHeight - 64 - reoffSet)/64;
    
    if (alpha>=1) {
        alpha = 1;
    }
    
    if (alpha <= 0) {
        headImgView.blurAlpha = 0;
    } else if(alpha <= 1 && alpha>0){
        headImgView.blurAlpha = alpha;
    } else{
        
    }
//    CHLog(@"reoffSet ------ %f /n alpha ----- %f",reoffSet,alpha);

    
    /**
     *  如果距离 还差 64 移除文本
     */
//    if ((kHeadImageHeight - 64 - reoffSet) <= 64) {
//        signatureLabel.hidden = YES;
//        focusLLView.hidden = YES;
//        fansLLView.hidden = YES;
//        _midLine.hidden = YES;
//    }else{
//        signatureLabel.hidden = NO;
//        focusLLView.hidden = NO;
//        fansLLView.hidden = NO;
//        _midLine.hidden = NO;
//        
//    }

//
//        CGRect bgImageFrame = headImgView.frame;
//        bgImageFrame.origin.y = 64 - kHeadImageHeight;
//        headImgView.frame = bgImageFrame;
//        
//        [self.view addSubview:headImgView];
//        /**
//         *  到顶端 保持上半部分悬浮
//         */
//        CGRect frame = backgoundView.frame;
//        
//        frame.origin.y = 64;
//        
//        backgoundView.frame = frame;
//        
//        [self.view addSubview:backgoundView];
//        
//    } else{
//        
//        
//        CGRect frame = backgoundView.frame;
//        
//        frame.origin.y = -60;
//        
//        backgoundView.frame = frame;
//        
//        [_tableView addSubview:backgoundView];
//        
//        
//        CGRect bgImageFrame = headImgView.frame;
//
//        /**
//         *  headerview 即将离开 self.view 跟随 tableview
//         */
//
//        if (bgImageFrame.origin.y > -60 - kHeadImageHeight) {
//            CHLog(@"bgImageFrame.origin.y  ------ %f ",bgImageFrame.origin.y);
//
//            bgImageFrame.origin.y = -60 - kHeadImageHeight;
//            headImgView.frame = bgImageFrame;
//            
//            [_tableView addSubview:headImgView];
//        }
//
//
//    }
    
}


//改变图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alp  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0f);
    
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
    
    if ([userId isEqualToString:JUserID]) {
        [[NSToastManager manager] showtoast:@"你时刻在关注你自己 ~"];
        return;
    }else{
        [self focusUserWithUserId:userId];

    }
    
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
    
    if (self.btnTag ==kButtonTag + 0) {
        
        NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
        
        cell.numLabel.hidden = YES;
        cell.myMusicModel = dataAry[indexPath.row];
        if (self.who == Other) {
            cell.secretImgView.hidden = YES;
        }
        return cell;
        
    } else if (self.btnTag == kButtonTag +1) {
        
        NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
        cell.myMusicModel = dataAry[indexPath.row];
        cell.numLabel.hidden = YES;
        if (self.who == Other) {
            cell.secretImgView.hidden = YES;
        }
        return cell;
        
    } else if (self.btnTag == kButtonTag +2) {
        
        NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
        cell.myMusicModel = dataAry[indexPath.row];
        cell.numLabel.hidden = YES;
        cell.secretImgView.hidden = YES;
        return cell;
        
    } else {
        
//        NSInspirationRecordTableViewCell *cell =(NSInspirationRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:ID1];
//        
//        cell.myInspirationModel = dataAry[indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.mas_left);
        }];
        
        cell.numLabel.hidden = YES;
        cell.coWorkModel = dataAry[indexPath.row];
            cell.secretImgView.hidden = YES;
        return cell;
        
    }
    
    
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *status;
    int isShow;
    NSMyMusicModel *model = dataAry[indexPath.row];
    if (self.btnTag != 203) {
        if (!model.isShow) {
            status = @"设为公开";
            isShow = 1;
        } else {
            status = @"设为私密";
            isShow = 0;
        }
    }
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:status handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //在block中实现相对应的事件
        
        if (self.btnTag ==kButtonTag + 0) {
            self.requestType = NO;
            self.requestParams = @{@"id":[NSNumber numberWithLong:model.itemId],@"is_issue":[NSNumber numberWithInt:isShow],@"token":LoginToken};
            self.requestURL = changeMusicStatus;
            
        } else if (self.btnTag ==kButtonTag + 1) {
            self.requestType = NO;
            self.requestParams = @{@"id":[NSNumber numberWithLong:model.itemId],@"status":[NSNumber numberWithInt:isShow],@"token":LoginToken};
            self.requestURL = changeLyricStatus;
        }
//      [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    
    //注意：1、当rowActionWithStyle的值为UITableViewRowActionStyleDestructive时，系统默认背景色为红色；当值为UITableViewRowActionStyleNormal时，背景色默认为淡灰色，可通过UITableViewRowAction的对象的.backgroundColor设置；
    //2、当左滑按钮执行的操作涉及数据源和页面的更新时，要先更新数据源，在更新视图，否则会出现无响应的情况
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.requestType = NO;
        
        NSMyMusicModel * myMode = dataAry[indexPath.row];
        if (type == 3) {
            self.requestParams = @{@"work_id":@(myMode.itemId),@"target_uid":@(myMode.userID),@"user_id":JUserID,@"token":LoginToken,@"wtype":@(myMode.type),};
            self.requestURL = collectURL;
        } else if (type == 5) {
            NSCooperateProductModel *model = dataAry[indexPath.row];
            self.requestType = NO;
            self.requestParams = @{@"uid":JUserID,@"itemid":@(model.itemid),@"token":LoginToken};
            self.requestURL = deleteCooperationProductUrl;
//            _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//            
//            _maskView.backgroundColor = [UIColor lightGrayColor];
//            
//            _maskView.alpha = 0.5;
//            
//            [self.navigationController.view addSubview:_maskView
//             ];
//            
//            CGFloat padding = ScreenWidth *60/375.0;
//            CGFloat width = (ScreenWidth - padding * 2);
//            CGFloat height = width * 338/256.0f;
//            
//            
//            _tipView = [[NSTipView alloc] initWithFrame:CGRectMake(padding, (ScreenHeight - height)/2.0f, width, height)];
//            
//            _tipView.delegate = self;
//            
//            _tipView.imgName = @"2.3_tipImg_deleteProduct";
//            
//            _tipView.tipText = [NSString stringWithFormat:@"如该合作作品已被对方采纳,单方面删除仅删除您个人列表的合作作品"];
//            [self.navigationController.view addSubview:_tipView];
//            
//            CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//            keyFrame.values = @[@(0.2), @(0.4), @(0.6), @(0.8), @(1.0), @(1.2), @(1.0)];
//            keyFrame.duration = 0.3;
//            keyFrame.removedOnCompletion = NO;
//            [_tipView.layer addAnimation:keyFrame forKey:nil];
//            
//            NSCooperateProductModel *model = dataAry[indexPath.row];
//            
//            cooperationProductId = model.itemid;
            
            
        }else{
            
            NSInteger deleteType = 4;
            if (type == 4) {
                deleteType = 3;
            }else{
                deleteType = type;
            }
            self.requestParams = @{@"id": @(myMode.itemId), @"type": @(deleteType),@"token":LoginToken};
            
            self.requestURL = deleteWorkURL;
        }
        
//        [dataAry removeObjectAtIndex:indexPath.row];
//        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    //此处UITableViewRowAction对象放入的顺序决定了对应按钮在cell中的顺序
    if (self.btnTag ==kButtonTag + 1 || self.btnTag ==kButtonTag + 0) {
        return @[delete,action];
    } else {
        return @[delete];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.btnTag ==kButtonTag + 0 || self.btnTag ==kButtonTag + 1 || self.btnTag ==kButtonTag + 2) {
        
        return 80;
    } else {
        
        return 100;
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
        playVC.isShow = myMusic.isShow;
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
        
    }else if (type == 5){
        NSCooperateProductModel *model = dataAry[indexPath.row];
        NSPlayMusicViewController * playVC = [[NSPlayMusicViewController alloc] init];
        playVC.itemUid = model.itemid;
        playVC.geDanID = 0;
        playVC.songAry = self.itemIdArr;
        playVC.isCoWork = YES;
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
//        NSInspirationRecordViewController * inspirationVC = [[NSInspirationRecordViewController alloc] initWithItemId:myMusic.itemId andType:NO];
//        [self.navigationController pushViewController:inspirationVC animated:YES];
    }
    
}
#pragma mark - NSTipViewDelegate

- (void)cancelBtnClick {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tipView.transform = CGAffineTransformScale(_tipView.transform, 0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [_maskView removeFromSuperview];
        
        [_tipView removeFromSuperview];
    }];
}
- (void)ensureBtnClick {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tipView.transform = CGAffineTransformScale(_tipView.transform, 0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [_maskView removeFromSuperview];
        
        [_tipView removeFromSuperview];
        
        self.requestType = NO;
        self.requestParams = @{@"uid":JUserID,@"itemid":@(cooperationProductId),@"token":LoginToken};
        self.requestURL = deleteCooperationProductUrl;
        
    }];
}
- (void)toolbarBtnClick:(UIButton *)toolbarBtn {
    UIButton *lastButton = [backgoundView viewWithTag:self.btnTag];
    lastButton.selected = NO;
    toolbarBtn.selected = YES;
    switch (toolbarBtn.tag - kButtonTag) {
            
        case 0: {
            
            self.btnTag = toolbarBtn.tag;
            type = 1 ;
            
            break;
        }
        case 1: {
            
            self.btnTag = toolbarBtn.tag;
            
            type = 2;
            
            break;
        }
        case 2: {
            
            self.btnTag = toolbarBtn.tag;
            type = 3;
            
            break;
        }
        case 3: {
            
            self.btnTag = toolbarBtn.tag;
            type = 5;
           
            break;
        }
        default:
            break;
            
    }
    [self fetchListWithIsSelf:self.who andIsLoadingMore:NO];
    //            [_tableView reloadData];
    if (dataAry.count != 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
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
        //删除收藏
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



//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)setBgImage:(UIImage *)bgImage{
    NSData *data = UIImageJPEGRepresentation(bgImage, 1);
    UIImage *inputImage = [UIImage imageWithData:data];
    NSLog(@"%ld",data.length);
    _bgImage = inputImage;
    
}

@end







