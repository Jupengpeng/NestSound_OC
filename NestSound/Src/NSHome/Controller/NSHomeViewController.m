//
//  NSHomeViewController.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSHomeViewController.h"
#import "NSSongMenuCollectionViewCell.h"
#import "NSIndexCollectionReusableView.h"
#import "NSMusicSayCollectionViewCell.h"
#import "NSRecommendCell.h"
#import "NSIndexModel.h"
#import "NSH5ViewController.h"
#import "NSSongViewController.h"
#import "NSPlayMusicViewController.h"
#import "NSLyricViewController.h"
#import "NSSongListViewController.h"
#import "NSMusicSayViewController.h"
#import "NSUserModel.h"
#import "NSTopicCarryOnCell.h"
#import "NSMessageListModel.h"
#import "NSMainCooperationViewController.h"
#import "NSMusicianListViewController.h"
#import "NSUserPageViewController.h"
/**
 *  专题活动
 */
#import "NSThemeActivityController.h"
#import "NSCustomMusicController.h"
#import "NSAccommpanyListModel.h"
#import "UIImageView+WebCache.h"
#import "NSMusicSayDetailController.h"
#import "NSCooperationDetailViewController.h"
@interface NSHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource,SDCycleScrollViewDelegate> {
    
    UICollectionView *_collection;
    NSMutableArray * bannerAry;
    NSMutableArray * recommendAry;
    NSMutableArray * recommendSongAry;
    NSMutableArray * newListAry;
    NSMutableArray * musicSayAry;
    NSString * getTokenUrl;
    NSString * indexUrl;
    NSString * messageUrl;
    UIImageView * playStatus;
    NSMutableArray * songAry;
    YYCache *cache;
    /**
     *  作曲部分预加载链接
     */
    NSString *_preLoadImagesUrl;
}

@property (nonatomic, strong) NSMutableArray *itemIDArray;
@property (nonatomic, strong) NSMutableArray *itemIDArr;
@property (nonatomic, strong) NSMutableArray *musicianArr;
@property (nonatomic,assign) long  itemId;
@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;

@end

static NSString * const RecommendCell = @"RecommendCell";
static NSString * const MusicSayCell = @"MusicSayCell";
static NSString * const SongMenuCell = @"SongMenuCell";
static NSString * const headerView = @"HeaderView";
static NSString * const NewWorkCell = @"NewWorkCell";
/**
 *  话题进行时
 */
static NSString * const TopCarringCell = @"TopCarringCell";
//数据缓存
static NSString * const homeCacheData = @"homeCacheData";
static NSString * const bannerData = @"bannerData";
static NSString * const recommendData = @"recommendData";
static NSString * const recommendSongData = @"recommendSongData";
static NSString * const newListData =  @"newListData";
static NSString * const musicSayData = @"musicSayData";
static NSString * const musicianData = @"musicianData";
@implementation NSHomeViewController

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    playStatus  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 21)];
    playStatus.animationDuration = 0.8;
    playStatus.animationImages = animationImgsArr;
    
    [playStatus stopAnimating];
    playStatus.userInteractionEnabled = YES;
    playStatus.image = [UIImage imageNamed:@"2.0_play_status_1"];
    UIButton * btn = [[UIButton alloc] initWithFrame:playStatus.frame ];
    [playStatus addSubview:btn];
    [btn addTarget:self action:@selector(musicPaly:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:playStatus];
    self.navigationItem.rightBarButtonItem = item;
    
    [self fetchIndexData];
    
    [self getAuthorToken];
    //    [self preLoadImages];
//    cache = [YYCache cacheWithName:homeCacheData];
//    bannerAry = [NSMutableArray arrayWithArray:(NSArray *)[cache objectForKey:bannerData]];
//    recommendAry = [NSMutableArray arrayWithArray:(NSArray *)[cache objectForKey:recommendData]];
//    self.musicianArr = [NSMutableArray arrayWithArray:(NSArray *)[cache objectForKey:musicianData]];
//    recommendSongAry = [NSMutableArray arrayWithArray:(NSArray *)[cache objectForKey:recommendSongData]];
//    newListAry   =  [NSMutableArray arrayWithArray:(NSArray *)[cache objectForKey:newListData]];
//    musicSayAry  = [NSMutableArray arrayWithArray:(NSArray *)[cache objectForKey:musicSayData]];
    [self configureUIAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
    self.navigationController.navigationBar.hidden = NO;
    [self fetchMessageData];
    if (self.playSongsVC.player == nil) {
        
    } else {
        
        if (self.playSongsVC.postion != 0.0) {
            [playStatus startAnimating];
        }else{
            [playStatus stopAnimating];
        }
    }
}

#pragma mark - 预加载作曲图片

//-(void)preLoadImages{
//
//    self.requestType = YES;
//    NSDictionary * dic = @{@"page":[NSString stringWithFormat:@"%d",1]};
//    NSString * str = [NSTool encrytWithDic:dic];
//    _preLoadImagesUrl = [accompanyListURL stringByAppendingString:str];
//    self.requestURL = _preLoadImagesUrl;
//
//}

#pragma mark -authorToken
-(void)getAuthorToken
{
    if (JUserID != nil) {
        self.requestType = NO;
        self.requestParams = @{@"token":LoginToken};
        self.requestURL = getToken;
        
    }
    
}

#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    self.navigationItem.title = @"音巢音乐";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    _collection.delegate = self;
    
    _collection.dataSource = self;
    
    _collection.showsVerticalScrollIndicator = NO;
    _collection.alwaysBounceVertical = YES;
    _collection.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [_collection registerClass:[NSRecommendCell class] forCellWithReuseIdentifier:RecommendCell];
    
    [_collection registerClass:[NSSongMenuCollectionViewCell class] forCellWithReuseIdentifier:SongMenuCell];
    
    [_collection registerClass:[NSRecommendCell class] forCellWithReuseIdentifier:NewWorkCell];
    
    [_collection registerClass:[NSMusicSayCollectionViewCell class] forCellWithReuseIdentifier:MusicSayCell];
    [_collection registerClass:[NSTopicCarryOnCell class] forCellWithReuseIdentifier:TopCarringCell];
    
    [_collection registerClass:[NSIndexCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView];
    
    [self.view addSubview:_collection];
    
    WS(wSelf);
    //reloading
    [_collection addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchMessageData];
            [wSelf fetchIndexData];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    _collection.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    
}

#pragma  mark -fetchIndexData
-(void)fetchIndexData
{
    [_collection.pullToRefreshView startAnimating];
    self.requestType = YES;
    NSDictionary * dic = @{@"1":@"2"};
    NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:1];
    
    //需要缓存
    self.cacheFileName = homeCacheData;
    self.requestParams = dic;
    
    NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
    indexUrl = [indexURL stringByAppendingString:str];
    self.requestURL = indexUrl;
    
}
-(void)fetchMessageData
{
    
    self.requestType = YES;
    
    NSMutableDictionary * userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    if (userDic) {
        NSDictionary * dic =@{@"uid":JUserID,@"token":LoginToken,@"timeStamp": [NSNumber  numberWithDouble:[date getTimeStamp]]};
        NSString * str = [NSTool encrytWithDic:dic];
        messageUrl = [messageURL stringByAppendingString:str];
        self.requestURL = messageUrl;
    }
    
}
#pragma mak -override FetchData;
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        CHLog(@"首页请求失败");
        [_collection.pullToRefreshView stopAnimating];
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:indexUrl]) {
                [bannerAry removeAllObjects];
                [_collection.pullToRefreshView stopAnimating];
                NSIndexModel * indexModel = (NSIndexModel *)parserObject;
                //banner数据
                bannerAry = [NSMutableArray arrayWithArray:indexModel.BannerList.bannerList];
                //推荐作品数据
                recommendAry = [NSMutableArray arrayWithArray:indexModel.RecommendList.recommendList];
                for (NSRecommend *model in recommendAry) {
                    [self.itemIDArray addObject:@(model.itemId)];
                }
                //音乐人数据
                self.musicianArr = [NSMutableArray arrayWithArray:indexModel.musicianList.musicianList];
                //推荐歌单数据
                recommendSongAry = [NSMutableArray arrayWithArray:indexModel.RecommendSongList.recommendSongList];
                //最新作品数据
                newListAry = [NSMutableArray arrayWithArray:indexModel.NewList.songList];
                for (NSNew *model in newListAry) {
                    [self.itemIDArr addObject:@(model.itemId)];
                }
                //乐说数据
                musicSayAry = [NSMutableArray arrayWithArray:indexModel.MusicSayList.musicSayList];
                [_collection reloadData];
                
            }else if([operation.urlTag isEqualToString:getToken]){
                NSUserModel * userModels = (NSUserModel *)parserObject;
                if (userModels) {
                    userModel * user = userModels.userDetail;
                    if (user) {
                        [JPUSHService setAlias:[NSString stringWithFormat:@"%ld",user.userID] callbackSelector:nil object:nil];
                        NSUserDefaults * userData = [NSUserDefaults standardUserDefaults];
                        NSMutableDictionary * dic =  [[NSMutableDictionary alloc] initWithDictionary:[userData objectForKey:@"user"]];
                        [dic setObject:user.userName forKey:@"userName"];
                        [dic setObject:[NSString stringWithFormat:@"%ld",user.userID] forKey:@"userID"];
                        [dic setObject:user.loginToken forKey:@"userLoginToken"];
                        [userData removeObjectForKey:@"user"];
                        [userData setObject:dic forKey:@"user"];
                        [userData synchronize];
                    }
                }
            } else if ([operation.urlTag isEqualToString:messageUrl]) {
                NSMessageListModel * messageList = (NSMessageListModel *)parserObject;
                
                messageCountModel * mess = messageList.messageCount;
                //                NSMutableArray *bageAry = [NSMutableArray array];
                if (mess.commentCount || mess.upvoteCount || mess.collecCount || mess.systemCount || mess.cooperationCount || mess.preserveCount) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kHiddenTabBarTipViewNotification object:@(0)];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kHiddenTabBarTipViewNotification object:@(1)];
                }
                
            }
            //            else if ([operation.urlTag isEqualToString:_preLoadImagesUrl]){
            //                /**
            //                 *  预加载作曲类目图片
            //                 */
            //                NSAccommpanyListModel* listModel = (NSAccommpanyListModel *)parserObject;
            //
            //                for (int myIndex = 0; myIndex < listModel.simpleCategoryList.simpleCategory.count; myIndex++)
            //                {
            //                    NSSimpleCategoryModel *categoryModel = listModel.simpleCategoryList.simpleCategory[myIndex];
            //                    NSURL *imageUrl = [NSURL URLWithString:categoryModel.categoryPic];
            //
            //                    [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
            //                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            ////                        NSLog(@"第%d张图片下载好了 /n",myIndex);
            //                    }];
            //                }
            //            }
        }
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 6;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return recommendAry.count;
        
    } else if (section == 1){
        
        return 1;
    } else if (section == 3) {
        
        return recommendSongAry.count;
        
    }
    /**
     *  话题进行时
     
     */
    else if (section == 2){
        
        return 1;
        
    }
    else if (section == 4){
        
        return newListAry.count;
    } else {
        
        return musicSayAry.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NSRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RecommendCell forIndexPath:indexPath];
        
        NSRecommend * recommendModel =  [recommendAry objectAtIndex:indexPath.row];
        cell.recommend = (NSMusicModel *)recommendModel;
        cell.contentView.layer.borderColor = [UIColor hexColorFloat:@"e5e5e5"].CGColor;
        cell.contentView.layer.borderWidth = 1;
        
        return cell;
        
    } else if (indexPath.section == 1){
        
        NSMusicSayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MusicSayCell forIndexPath:indexPath];
        if (recommendAry.count) {
            cell.picUrlStr = @"2.3_CooperationCover";
        }
        
        return cell;
        
    } else if (indexPath.section == 3) {
        
        NSSongMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SongMenuCell forIndexPath:indexPath];
        
        NSRecommendSong * recommendSongModel = (NSRecommendSong *)[recommendSongAry objectAtIndex:indexPath.row];
        cell.recommendSong = recommendSongModel;
        
        return cell;
        
    }
    else if (indexPath.section == 2){
        
        NSTopicCarryOnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopCarringCell forIndexPath:indexPath];
        
//        for (int i = 0; i < self.musicianArr.count; i++) {
//            UILabel *nameLabel = [cell viewWithTag:200 + i];
//            [nameLabel removeFromSuperview];
//        }
        
        [cell setupDataWithTopicArray:self.musicianArr];

        
        cell.topicClickBlock = ^(NSInteger clickIndex){
            NSMusician *model = self.musicianArr[clickIndex];
            NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",model.uid]];
            if (model.uid != [JUserID integerValue]) {
                pageVC.who = Other;
                
            } else {
                pageVC.who = Myself;
            }
            [self.navigationController pushViewController:pageVC animated:YES];
        };
        
        return cell;
        
    }
    else if (indexPath.section == 4) {
        
        NSRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewWorkCell forIndexPath:indexPath];
        NSNew * newModel = (NSNew *)[newListAry objectAtIndex:indexPath.row];
        cell.songNew = newModel;
        
        cell.contentView.layer.borderColor = [UIColor hexColorFloat:@"e5e5e5"].CGColor;
        cell.contentView.layer.borderWidth = 1;
        
        return cell;
        
    } else {
        
        NSMusicSayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MusicSayCell forIndexPath:indexPath];
        NSMusicSay * musicSayModel = (NSMusicSay *)[musicSayAry objectAtIndex:indexPath.row];
        cell.musicSay = musicSayModel;
        return cell;
    }
    
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CGFloat W = (ScreenWidth - 50) / 3;
        return CGSizeMake(W, W + W * 0.38);
        
    } else if (indexPath.section == 1){
        CGFloat W = ScreenWidth - 30;
        CGFloat picRatio = 90 / 345.0f;
        return CGSizeMake(W, W * picRatio + 10);
    } else if (indexPath.section == 3) {
        
        CGFloat W = (ScreenWidth - 40) * 0.5;
        return CGSizeMake(W, 140);
        
    }
    else if (indexPath.section == 2){
        
        CGFloat W = (ScreenWidth);
        
        return CGSizeMake(W, 80.0f);
        
    }
    else if (indexPath.section == 4) {
        
        CGFloat W = (ScreenWidth - 50) / 3;
        return CGSizeMake(W, W + W * 0.38);
        
    } else {
        
        CGFloat W = (ScreenWidth - 30);
        //        CGFloat picRatio = 250 / 345.0 ;
        return CGSizeMake(W,ScreenHeight/4+20);
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSLog(@"分区数%ld",(long)section);
    if (section == 0) {
        NSRecommend * recomm = recommendAry[row];
        
        //type == 1 is music  type ==2 is lyric
        if (recomm.type == 2) {
            NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:recomm.itemId];
            
            [self.navigationController pushViewController:lyricVC animated:YES];
            
        }else{
            NSPlayMusicViewController * playVC =[NSPlayMusicViewController sharedPlayMusic];
            
            playVC.itemUid = recomm.itemId;
            playVC.from = @"tuijian";
            playVC.geDanID = 0;
            
            playVC.songID = indexPath.item;
            playVC.songAry = self.itemIDArray;
            if (recomm.type == 3) {
                playVC.isCoWork = YES;
            } else {
                playVC.isCoWork = NO;
            }
            [self.navigationController pushViewController:playVC animated:YES];
        }
        
    } else if (section == 1){
        NSMainCooperationViewController *mainCooperationVC = [[NSMainCooperationViewController alloc] init];
        [self.navigationController pushViewController:mainCooperationVC animated:YES];
        //        NSCustomMusicController *customMusicController = [[NSCustomMusicController alloc] init];
        //        [self.navigationController pushViewController:customMusicController animated:YES];
    } else if (section == 3){
        
        NSRecommendSong * recommendSongModel = (NSRecommendSong *)[recommendSongAry objectAtIndex:indexPath.row];
        NSSongViewController * songVC = [[NSSongViewController alloc] initWithSongListId:recommendSongModel.itemID];
        [self.navigationController pushViewController:songVC animated:YES];
    }
    else if (section == 2){
        /**
         *  音乐人
         */
        
    }
    else if (section == 4){
        NSNew * newModel = (NSNew *)newListAry[row];
        //newModel type == 1 is music type == 2 is lyric
        if (newModel.type == 2) {
            
            NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:newModel.itemId];
            [self.navigationController pushViewController:lyricVC animated:YES];
        }else{
            NSPlayMusicViewController * playVC =[NSPlayMusicViewController sharedPlayMusic];
            playVC.itemUid = newModel.itemId;
            playVC.from = @"news";
            playVC.geDanID = 0;
            playVC.songID = indexPath.item;
            playVC.songAry = self.itemIDArr;
            if (newModel.type == 3) {
                playVC.isCoWork = YES;
            } else {
                playVC.isCoWork = NO;
            }
            [self.navigationController pushViewController:playVC animated:YES];
            
        }
        
    }else {
        NSMusicSay * musicSay = (NSMusicSay *)musicSayAry[row];
        //type == 1 is music ,type == 2 is lyric
        NSMusicSayDetailController *musicSayController = [[NSMusicSayDetailController alloc] init];
        musicSayController.itemId = [NSString stringWithFormat:@"%d",musicSay.itemID];
        musicSayController.detailStr = musicSay.detail;
        musicSayController.name = musicSay.workName;
        musicSayController.picUrl = musicSay.titleImageUrl;
        musicSayController.type = [NSString stringWithFormat:@"%d",musicSay.type];
        musicSayController.contentUrl = musicSay.playUrl;
        
        [self.navigationController pushViewController:musicSayController animated:YES];
        
        //        if (musicSay.type == 1) {
        //            NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
        //            playVC.itemUid = musicSay.itemID;
        //            playVC.from = @"yueshuo";
        //            playVC.geDanID = 0;
        //
        //            [self.navigationController pushViewController:playVC animated:YES];
        //
        //        }else{
        //            NSH5ViewController * h5VC = [[NSH5ViewController alloc] init];
        //            h5VC.h5Url = musicSay.playUrl;
        //            [self.navigationController pushViewController:h5VC animated:YES];
        //        }
    }
    
}



#pragma mark -collectionView LayOut
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (recommendAry.count) {
        if (section == 0) {
            
            return CGSizeMake(ScreenWidth, ScreenHeight/5 + 40);
        } else if(section == 1){
            return CGSizeMake(ScreenWidth, 0);
        }
        return CGSizeMake(ScreenWidth, 40);
    }
    //    return CGSizeMake(ScreenWidth, 0);
    else if(section == 2){
        /**
         *  活动进行时
         */
        return CGSizeMake(0,0);
        //        return CGSizeMake(ScreenWidth, 10);
        
    }
    
    return CGSizeMake(ScreenWidth, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexCollectionReusableView *reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView forIndexPath:indexPath];
    
    //    reusable.delegate = self;
    reusable.clipsToBounds = YES;
    if (recommendAry.count) {
        if (indexPath.section == 0) {
            NSMutableArray *bannerImgs = [NSMutableArray arrayWithCapacity:1];
            for (NSBanner *model in bannerAry) {
                [bannerImgs addObject:model.titleImageUrl];
            }
            reusable.SDCycleScrollView.imageURLStringsGroup = bannerImgs;
            reusable.SDCycleScrollView.delegate = self;
            //        reusable.bannerAry = bannerAry;
            reusable.SDCycleScrollView.hidden = NO;
            reusable.titleLable.text = @"推荐作品";
            [reusable loadMore:NO];
            
            //        NSLocalizedString(@"promot_recommendWorks", @"");
            //        LocalizedStr(@"promot_recoindexCollectionReusableViewmmendWorks");
            return reusable;
            
        }  else if (indexPath.section == 1){
            
            //        reusable.bannerAry = nil;
            reusable.SDCycleScrollView.hidden = YES;
            [reusable loadMore:NO];
            
            return reusable;
            
        } else if (indexPath.section == 3) {
            
            reusable.SDCycleScrollView.hidden = YES;
            
            UIButton *songMenuBtn = [reusable loadMore:YES];
            
            [songMenuBtn addTarget:self action:@selector(songMenuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            reusable.titleLable.text = @"推荐歌单";
            
            //        LocalizedStr(@"promot_recommendSongList");
            return reusable;
            
        } else if (indexPath.section == 2) {
            
            reusable.SDCycleScrollView.hidden = YES;
            
            reusable.titleLable.text = @"音乐人";
            
            UIButton *muscianBtn = [reusable loadMore:YES];
            
            [muscianBtn addTarget:self action:@selector(musicianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            return reusable;
        } else if (indexPath.section == 4) {
            
            reusable.SDCycleScrollView.hidden = YES;
            
            reusable.titleLable.text = @"最新作品";
            
            [reusable loadMore:NO];
            //        LocalizedStr(@"promot_newWorks");
            return reusable;
            
        } else if (indexPath.section == 5){
            
            reusable.SDCycleScrollView.hidden = YES;
            
            UIButton *songSayBtn = [reusable loadMore:YES];
            
            [songSayBtn addTarget:self action:@selector(songSayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            reusable.titleLable.text = @"乐说";
            
            return reusable;
            //        LocalizedStr(@"promot_musicSay");
            
        }
        
        //        return reusable;
    }
    return reusable;
    
}
- (void)musicianBtnClick:(UIButton *)btn {
    
    NSMusicianListViewController *musicianVC = [[NSMusicianListViewController alloc] init];
    
    [self.navigationController pushViewController:musicianVC animated:YES];
}
- (void)songMenuBtnClick:(UIButton *)btn {
    
    NSSongListViewController *songListVC = [[NSSongListViewController alloc] init];
    
    [self.navigationController pushViewController:songListVC animated:YES];
    
}

- (void)songSayBtnClick:(UIButton *)btn {
    
    NSMusicSayViewController *musicSayVC = [[NSMusicSayViewController alloc] init];
    
    [self.navigationController pushViewController:musicSayVC animated:YES];
}

//轮播器点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //- (void)indexCollectionReusableView:(NSIndexCollectionReusableView *)reusableView withImageBtn:(UIButton *)imageBtn {
    
    NSBanner * banner = (NSBanner *)bannerAry[index];
    long item = banner.itemID;
    if (banner.state == 1) {
        NSH5ViewController * event = [[NSH5ViewController alloc] init];
        event.h5Url = banner.activityURL;
        [self.navigationController pushViewController:event animated:YES];
    }else{
        
        
        if (!songAry) {
            songAry = [NSMutableArray array];
        }else{
            [songAry removeAllObjects];
        }
        for (NSBanner * banner in bannerAry) {
            if (banner.state == 0) {
                [songAry  addObject:@(banner.itemID)];
            }
            
        }
        
        NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
        int g;
        for (g =0; g<songAry.count; g++) {
            if (item == [songAry[g] longValue]) {
                playVC.songID = g;
                break;
            }
        }
        playVC.songAry = songAry;
        playVC.itemUid = item;
        playVC.from = @"tuijian";
        playVC.geDanID = 0;
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
}


- (void)musicPaly:(UIBarButtonItem *)palyItem {
    
    if (self.playSongsVC.player == nil) {
        [[NSToastManager manager] showtoast:@"您还没有听过什么歌曲哟"];
    } else {
        [self.navigationController pushViewController:self.playSongsVC animated:YES];
    }
    
}
#pragma mark - lazy loading
- (NSMutableArray *)itemIDArray {
    
    if (!_itemIDArray) {
        
        _itemIDArray = [NSMutableArray array];
    }
    
    return _itemIDArray;
}
- (NSMutableArray *)itemIDArr {
    if (!_itemIDArr) {
        self.itemIDArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemIDArr;
}
- (NSMutableArray *)musicianArr {
    if (!_musicianArr) {
        self.musicianArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _musicianArr;
}
- (NSPlayMusicViewController *)playSongsVC {
    
    if (!_playSongsVC) {
        _playSongsVC = [NSPlayMusicViewController sharedPlayMusic];
    }
    
    return _playSongsVC;
}



@end
