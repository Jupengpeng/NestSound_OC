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
    int i;
}

@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;

@end

static NSString * const RecommendCell = @"RecommendCell";
static NSString * const MusicSayCell = @"MusicSayCell";
static NSString * const SongMenuCell = @"SongMenuCell";
static NSString * const headerView = @"HeaderView";
static NSString * const NewWorkCell = @"NewWorkCell";

@implementation NSHomeViewController

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
    
//    i == 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_musicNote"] style:UIBarButtonItemStylePlain target:self action:@selector(musicPaly:)];
    
    
    [self fetchIndexData];
    [self getAuthorToken];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)getAuthorToken
{
    if (JUserID != nil) {
        self.requestType = NO;
        NSLog(@"token%@",LoginToken);
        self.requestParams = @{@"token":LoginToken};
        self.requestURL = getToken;
        
    }

}


-(void)configureUIAppearance
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    _collection.delegate = self;
    
    _collection.dataSource = self;
    
    _collection.showsVerticalScrollIndicator = NO;
    
    _collection.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [_collection registerClass:[NSRecommendCell class] forCellWithReuseIdentifier:RecommendCell];
    
    [_collection registerClass:[NSSongMenuCollectionViewCell class] forCellWithReuseIdentifier:SongMenuCell];
    
    [_collection registerClass:[NSRecommendCell class] forCellWithReuseIdentifier:NewWorkCell];
    
    [_collection registerClass:[NSMusicSayCollectionViewCell class] forCellWithReuseIdentifier:MusicSayCell];
    
    [_collection registerClass:[NSIndexCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView];
    
    [self.view addSubview:_collection];
}

- (void)viewDidLayoutSubviews {
    
    _collection.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    
    [super viewDidLayoutSubviews];
}

#pragma  mark -fetchIndexData
-(void)fetchIndexData
{
//    self.requestParams = @{@"type":@(YES)};
    self.requestType = YES;
    NSDictionary * dic = @{@"1":@"2"};
    
    NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:1];
    NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
    self.requestURL = [indexURL stringByAppendingString:str];
    index = self.requestURL;
    
}

#pragma mark -override FetchData;
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{

    if (!parserObject.success) {

        if ([operation.urlTag isEqualToString:index]) {
        
        NSLog(@"this is%@",parserObject.description);
        
            NSIndexModel * indexModel = (NSIndexModel *)parserObject;
            bannerAry = [NSMutableArray arrayWithArray:indexModel.BannerList.bannerList];
            recommendAry = [NSMutableArray arrayWithArray:indexModel.RecommendList.recommendList];
            recommendSongAry = [NSMutableArray arrayWithArray:indexModel.RecommendSongList.recommendSongList];
            newListAry = [NSMutableArray arrayWithArray:indexModel.NewList.songList];
        musicSayAry = [NSMutableArray arrayWithArray:indexModel.MusicSayList.musicSayList];
        [self configureUIAppearance];
        }else if([operation.urlTag isEqualToString:getToken]){
            NSUserModel * userModels = (NSUserModel *)parserObject;
            if (userModels) {
                userModel * user = userModels.userDetail;
                if (user) {
                    NSUserDefaults * userData = [NSUserDefaults standardUserDefaults];
                    NSMutableDictionary * dic =  [[NSMutableDictionary alloc] initWithDictionary:[userData objectForKey:@"user"]];
                    [dic setObject:user.userName forKey:@"userName"];
                    [dic setObject:[NSString stringWithFormat:@"%ld",user.userID] forKey:@"userID"];
                    [dic setObject:user.headerURL forKey:@"userIcon"];
                    [dic setObject:user.loginToken forKey:@"userLoginToken"];
                    [userData removeObjectForKey:@"user"];
                    [userData setObject:dic forKey:@"user"];
                    [userData synchronize];
                }
                
            }
        }
    }else{
        [[NSToastManager manager] showtoast:@"网络异常"];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 6;
        
    } else if (section == 1) {
        
        return 4;
        
    } else if (section == 2){
        
        return 6;
        
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
        return CGSizeMake(W, W*0.64);
        
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
            playVC.itemId = recomm.itemId;
            [self.navigationController pushViewController:playVC animated:YES];
        }else{
            NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:recomm.itemId];
            
            [self.navigationController pushViewController:lyricVC animated:YES];
        }
        
    }else if (section == 1){
        
        NSRecommendSong * recommendSongModel = (NSRecommendSong *)[recommendSongAry objectAtIndex:indexPath.row];
        NSLog(@"lalalla %ld",recommendSongModel.itemID);
        NSSongViewController * songVC = [[NSSongViewController alloc] initWithSongListId:recommendSongModel.itemID];
        [self.navigationController pushViewController:songVC animated:YES];
    }else if (section == 2){
        NSNew * newModel = (NSNew *)newListAry[row];
        
        //newModel type == 1 is music type == 2 is lyric
        long item = newModel.itemId;
        if (newModel.type == 1) {
            NSPlayMusicViewController * playVC =[NSPlayMusicViewController sharedPlayMusic];
            playVC.itemId = item;
            [self.navigationController pushViewController:playVC animated:YES];
            
        }else{
            
            NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:item];
            [self.navigationController pushViewController:lyricVC animated:YES];
        }
        
    }else if (section == 3){
        NSMusicSay * musicSay = (NSMusicSay *)musicSayAry[row];
        //type == 1 is music ,type == 2 is web
        if (musicSay.type == 1) {
            NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
            playVC.itemId = musicSay.itemID;
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
        
        return CGSizeMake(ScreenWidth, 230);
    }
    return CGSizeMake(ScreenWidth, 30);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexCollectionReusableView *reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView forIndexPath:indexPath];
    
    reusable.delegate = self;
    
    
    if (indexPath.section == 0) {
        
        reusable.bannerAry = bannerAry;
        
        reusable.titleLable.text = @"推荐作品";
//        NSLocalizedString(@"promot_recommendWorks", @"");
//        LocalizedStr(@"promot_recommendWorks");
        
    } else if (indexPath.section == 1) {
        
        UIButton *songMenuBtn = [reusable loadMore];
        
        [songMenuBtn addTarget:self action:@selector(songMenuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [[reusable viewWithTag:100] removeFromSuperview];
        
        [[reusable viewWithTag:200] removeFromSuperview];
        
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
    
    NSLog(@"点击了歌单更多");
}

- (void)songSayBtnClick:(UIButton *)btn {
    
    NSMusicSayViewController *musicSayVC = [[NSMusicSayViewController alloc] init];
    
    [self.navigationController pushViewController:musicSayVC animated:YES];
    
    NSLog(@"点击了乐说更多");
}

//轮播器点击事件
- (void)indexCollectionReusableView:(NSIndexCollectionReusableView *)reusableView withImageBtn:(UIButton *)imageBtn {
    
    NSBanner * banner = (NSBanner *)bannerAry[imageBtn.tag];
    long item = banner.itemID;
    if (banner.state == 1) {
        NSH5ViewController * event = [[NSH5ViewController alloc] init];
        event.h5Url = banner.activityURL;
        [self.navigationController pushViewController:event animated:YES];
    }else if (banner.state == 2){
     
        NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:item];
        [self.navigationController pushViewController:lyricVC animated:YES];
    }else{
        NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
        playVC.itemId = item;
    }
    
    NSLog(@"点击了第%zd张图片",imageBtn.tag);
    
}


- (void)musicPaly:(UIBarButtonItem *)palyItem {

    if (self.playSongsVC.player == nil) {
        [[NSToastManager manager] showtoast:@"您还没有听过什么歌曲哟"];
    } else {
        
        [self.navigationController pushViewController:self.playSongsVC animated:YES];
    }
    
}

-(void)animation:(BOOL)animat
{
//    [self.navigationItem.rightBarButtonItem]
}


@end
