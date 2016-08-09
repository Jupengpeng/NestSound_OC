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
@interface NSHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, NSIndexCollectionReusableViewDelegate> {
    
    UICollectionView *_collection;
    NSMutableArray * bannerAry;
    NSMutableArray * recommendAry;
    NSMutableArray * recommendSongAry;
    NSMutableArray * newListAry;
    NSMutableArray * musicSayAry;
    NSString * getTokenUrl;
    NSString * index;
    UIImageView * playStatus;
    int i;
    NSMutableArray * songAry;
    
}

@property (nonatomic, strong) NSMutableArray *itemIDArray;
@property (nonatomic, strong) NSMutableArray *itemIDArr;
@property (nonatomic,assign) long  itemId;

@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;

@end

static NSString * const RecommendCell = @"RecommendCell";
static NSString * const MusicSayCell = @"MusicSayCell";
static NSString * const SongMenuCell = @"SongMenuCell";
static NSString * const headerView = @"HeaderView";
static NSString * const NewWorkCell = @"NewWorkCell";

@implementation NSHomeViewController


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
- (NSPlayMusicViewController *)playSongsVC {
    
    if (!_playSongsVC) {
        
        _playSongsVC = [NSPlayMusicViewController sharedPlayMusic];
    }
    
    return _playSongsVC;
}

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
    playStatus.animationImages = @[[UIImage imageNamed:@"2.0_play_status_1"],
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
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
    self.navigationController.navigationBar.hidden = NO;
    
    if (self.playSongsVC.player == nil) {
       
    } else {
        
        if (self.playSongsVC.player.rate != 0.0) {
            [playStatus startAnimating];
        }else{
            [playStatus stopAnimating];
        }
    }
    
}

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
    
    [_collection registerClass:[NSIndexCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView];
    
    [self.view addSubview:_collection];
    
    WS(wSelf);
    //reloading
    [_collection addDDPullToRefreshWithActionHandler:^{
        [wSelf fetchIndexData];
    }];
}

- (void)viewDidLayoutSubviews {
    
    _collection.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    
    [super viewDidLayoutSubviews];
}

#pragma  mark -fetchIndexData
-(void)fetchIndexData
{
    [_collection.pullToRefreshView startAnimating];
    self.requestType = YES;
    NSDictionary * dic = @{@"1":@"2"};
    NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:1];
    NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
    self.requestURL = [indexURL stringByAppendingString:str];
    index = self.requestURL;
    
}

#pragma mak -override FetchData;
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        NSLog(@"首页请求失败");
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:index]) {
                NSIndexModel * indexModel = (NSIndexModel *)parserObject;
                [bannerAry removeAllObjects];
                bannerAry = [NSMutableArray arrayWithArray:indexModel.BannerList.bannerList];
                recommendAry = [NSMutableArray arrayWithArray:indexModel.RecommendList.recommendList];
                for (NSRecommend *model in recommendAry) {
                    [self.itemIDArray addObject:@(model.itemId)];
                }
                recommendSongAry = [NSMutableArray arrayWithArray:indexModel.RecommendSongList.recommendSongList];
                newListAry = [NSMutableArray arrayWithArray:indexModel.NewList.songList];
                for (NSNew *model in newListAry) {
                    [self.itemIDArr addObject:@(model.itemId)];
                }
                musicSayAry = [NSMutableArray arrayWithArray:indexModel.MusicSayList.musicSayList];
                 [self configureUIAppearance];
//                [_collection reloadData];
                [_collection.pullToRefreshView stopAnimating];
            }else if([operation.urlTag isEqualToString:getToken]){
                NSUserModel * userModels = (NSUserModel *)parserObject;
                if (userModels) {
                    userModel * user = userModels.userDetail;
                    if (user) {
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
            }
        }
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return recommendAry.count;
        
    } else if (section == 1) {
        
        return recommendSongAry.count;
        
    } else if (section == 2){
        
        return newListAry.count;
        
    } else {
        
        return musicSayAry.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NSRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RecommendCell forIndexPath:indexPath];
        
        NSRecommend * recommendModel =  (NSRecommend *)[recommendAry objectAtIndex:indexPath.row];
        cell.recommend = recommendModel;
        cell.contentView.layer.borderColor = [UIColor hexColorFloat:@"e5e5e5"].CGColor;
        cell.contentView.layer.borderWidth = 1;

        return cell;
        
        
    } else if (indexPath.section == 1) {
        
        NSSongMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SongMenuCell forIndexPath:indexPath];
        
        NSRecommendSong * recommendSongModel = (NSRecommendSong *)[recommendSongAry objectAtIndex:indexPath.row];
        cell.recommendSong = recommendSongModel;
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
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
        
    } else if (indexPath.section == 1) {
        
        CGFloat W = (ScreenWidth - 40) * 0.5;
        return CGSizeMake(W, 135);
        
    } else if (indexPath.section == 2) {
        
        CGFloat W = (ScreenWidth - 50) / 3;
        return CGSizeMake(W, W + W * 0.38);
        
    } else {
        
        CGFloat W = (ScreenWidth - 30);
        return CGSizeMake(W, 200);
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        NSRecommend * recomm = (NSRecommend *)recommendAry[row];
        
        //type == 1 is music  type ==2 is lyric
        if (recomm.type == 1) {

            NSPlayMusicViewController * playVC =[NSPlayMusicViewController sharedPlayMusic];

            playVC.itemUid = recomm.itemId;
            playVC.from = @"tuijian";
            playVC.geDanID = 0;

            playVC.songID = indexPath.item;
            playVC.songAry = self.itemIDArray;

            [self.navigationController pushViewController:playVC animated:YES];
        }else{
            NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:recomm.itemId];
            
            [self.navigationController pushViewController:lyricVC animated:YES];
        }
        
    }else if (section == 1){
        
        NSRecommendSong * recommendSongModel = (NSRecommendSong *)[recommendSongAry objectAtIndex:indexPath.row];
        NSSongViewController * songVC = [[NSSongViewController alloc] initWithSongListId:recommendSongModel.itemID];
        [self.navigationController pushViewController:songVC animated:YES];
    }else if (section == 2){
        NSNew * newModel = (NSNew *)newListAry[row];
        //newModel type == 1 is music type == 2 is lyric
        if (newModel.type == 1) {
            NSPlayMusicViewController * playVC =[NSPlayMusicViewController sharedPlayMusic];
            playVC.itemUid = newModel.itemId;
            playVC.from = @"news";
            playVC.geDanID = 0;
            playVC.songID = indexPath.item;
            playVC.songAry = self.itemIDArr;

            [self.navigationController pushViewController:playVC animated:YES];
            
        }else{
            
            NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:newModel.itemId];
            [self.navigationController pushViewController:lyricVC animated:YES];
        }
        
    }else if (section == 3){
        NSMusicSay * musicSay = (NSMusicSay *)musicSayAry[row];
        //type == 1 is music ,type == 2 is web
        if (musicSay.type == 1) {
            NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
            playVC.itemUid = musicSay.itemID;
            playVC.from = @"yueshuo";
            playVC.geDanID = 0;
            
            [self.navigationController pushViewController:playVC animated:YES];
            
        }else{
            NSH5ViewController * h5VC = [[NSH5ViewController alloc] init];
            h5VC.h5Url = musicSay.playUrl;
            [self.navigationController pushViewController:h5VC animated:YES];
        }
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
    
    if (section == 0) {
        
        return CGSizeMake(ScreenWidth, 190);
    }
    return CGSizeMake(ScreenWidth, 35);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexCollectionReusableView *reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView forIndexPath:indexPath];
    
    reusable.delegate = self;
    
    if (indexPath.section == 0) {
        
        reusable.bannerAry = bannerAry;
        
        reusable.titleLable.text = @"推荐作品";
//        NSLocalizedString(@"promot_recommendWorks", @"");
//        LocalizedStr(@"promot_recoindexCollectionReusableViewmmendWorks");
        
    } else if (indexPath.section == 1) {
        
        [[reusable viewWithTag:100] removeFromSuperview];
        
        [[reusable viewWithTag:200] removeFromSuperview];
        
        UIButton *songMenuBtn = [reusable loadMore];
        
        [songMenuBtn addTarget:self action:@selector(songMenuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        reusable.titleLable.text = @"推荐歌单";
//        LocalizedStr(@"promot_recommendSongList");

    } else if (indexPath.section == 2) {
        [[reusable viewWithTag:100] removeFromSuperview];
        
        [[reusable viewWithTag:200] removeFromSuperview];
        
        reusable.titleLable.text = @"最新作品";
//        LocalizedStr(@"promot_newWorks");
        
    } else {
        
        UIButton *songSayBtn = [reusable loadMore];
        
        [songSayBtn addTarget:self action:@selector(songSayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [[reusable viewWithTag:100] removeFromSuperview];
        
        [[reusable viewWithTag:200] removeFromSuperview];

        reusable.titleLable.text = @"乐说";
//        LocalizedStr(@"promot_musicSay");

    }
    
    return reusable;
    
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
- (void)indexCollectionReusableView:(NSIndexCollectionReusableView *)reusableView withImageBtn:(UIButton *)imageBtn {
    
    NSBanner * banner = (NSBanner *)bannerAry[imageBtn.tag];
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





@end
