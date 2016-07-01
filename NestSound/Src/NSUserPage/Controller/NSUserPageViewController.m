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
    NSLoginViewController *login;
    NSString * myUrl;
    NSString * otherUrl;
    NSString * url;
    int type;
    NSTableHeaderView *headerView ;
    int page;
}

@property (nonatomic, assign) NSInteger btnTag;

@end

@implementation NSUserPageViewController


-(instancetype)initWithUserID:(NSString *)userID_
{
    if (self = [super init]) {
        userId = userID_;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    type = 1;
    page = 0;
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
    self.navigationController.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!JUserID) {
        [self.tabBarController setSelectedIndex:0];
        page = 0;
    }else{
        if (dataAry.count == 0) {
            [self fetchUserDataWithIsSelf:self.who andIsLoadingMore:NO];
        }
        
    }
}

#pragma mark -fetchMemberData
-(void)fetchUserDataWithIsSelf:(Who)who andIsLoadingMore:(BOOL)isLoadingMore
{
    self.requestType = YES;
    int currentPage = 0;
    NSMutableDictionary * userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSLog(@"userDic%@",userDic);
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
    if (!parserObject.success) {
        if ([operation.urlTag isEqualToString:url]) {
            
            NSUserDataModel * userData = (NSUserDataModel *)parserObject;
            headerView.userModel = userData.userDataModel.userModel;
            headerView.otherModel = userData.userOtherModel;
            if (!operation.isLoadingMore) {
            
                myMusicAry = [NSMutableArray arrayWithArray:userData.myMusicList.musicList];
                
            }else{
                [myMusicAry addObjectsFromArray:userData.myMusicList.musicList];
            
            }
            if (!operation.isLoadingMore) {
                [_tableView.pullToRefreshView stopAnimating];
            }else{
                [_tableView.infiniteScrollingView stopAnimating];
            }

            dataAry = myMusicAry;
            [_tableView reloadData];
        }else if ([operation.urlTag isEqualToString:focusUserURL]){
            [[NSToastManager manager] showtoast:@"关注成功"];
        }
            }else{
        [[NSToastManager manager] showtoast:@"亲，您网路飞外国去啦"];
    }
    
    
}

#pragma mark -setupUI
- (void)setupUI {
    
        headerView = [[NSTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 290)];
    
    if (self.who == Myself) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settingClick:)];
        
        [array addObject:setting];
        
//        UIBarButtonItem *draftBox = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_draftBox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(draftBoxClick:)];
//        
//        [array addObject:draftBox];
        
        self.navigationItem.rightBarButtonItems = array;

    }
    
    if (self.who == Other) {
        
        UIBarButtonItem *follow = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_follow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(followClick:)];
        
        self.navigationItem.rightBarButtonItem = follow;
        
    }
    
    
    [headerView.followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView.fansBtn addTarget:self action:@selector(fansBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableHeaderView = headerView;
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    WS(wSelf);
    _tableView.showsVerticalScrollIndicator = NO;
    //loadingMore
     [_tableView addDDInfiniteScrollingWithActionHandler:^{
         if (!wSelf) {
             return ;
         }else{
             [wSelf fetchUserDataWithIsSelf:wSelf.who andIsLoadingMore:YES];
         }
         
     }];
    
    
    _tableView.showsInfiniteScrolling = NO;
    
    [self.view addSubview:_tableView];
    
}

- (void)followBtnClick:(UIButton *)follow {
    if (self.who == Myself) {
        NSFansViewController * myFocusVC = [[NSFansViewController alloc] initWithUserID:JUserID _isFans:NO isWho:Myself];
        [self.navigationController pushViewController:myFocusVC animated:YES];
    }
    
    if (self.who == Other) {
        
        NSFansViewController * otherFocusVC = [[NSFansViewController alloc] initWithUserID:userId _isFans:NO isWho:Other];
        [self.navigationController pushViewController:otherFocusVC animated:YES];
    }
    
}

- (void)fansBtnClick:(UIButton *)fansBtn {
    if (self.who == Myself) {
        NSFansViewController * myFansVC = [[NSFansViewController alloc] initWithUserID:JUserID _isFans:YES isWho:Myself];
        [self.navigationController pushViewController:myFansVC animated:YES];
    }
    
    if (self.who == Other) {
        NSFansViewController * otherFansVC = [[NSFansViewController alloc] initWithUserID:userId _isFans:YES isWho:Other];
        [self.navigationController pushViewController:otherFansVC animated:YES];
        NSLog(@"点击了他人的粉丝");
    }
    
}



- (void)settingClick:(UIBarButtonItem *)editing {
    
    NSLog(@"点击了设置");
    NSUserViewController * userSettingVC = [[NSUserViewController alloc] init];
    [self.navigationController pushViewController:userSettingVC animated:YES];
}


- (void)draftBoxClick:(UIBarButtonItem *)record {
    
    NSDraftBoxViewController *draftBox = [[NSDraftBoxViewController alloc] init];
    
    [self.navigationController pushViewController:draftBox animated:YES];
    
    NSLog(@"点击了草稿");
}

- (void)followClick:(UIBarButtonItem *)follow {
    
    [self focusUserWithUserId:userId];
    NSLog(@"%@",userId);
    NSLog(@"点击了Nav的关注");
}


-(void)focusUserWithUserId:(NSString *)userId_
{
    NSLog(@"%@",userId_);
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
        
        static NSString *ID = @"cell0";
        
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
        
        static NSString *ID = @"cell3";
        
        NSInspirationRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *array;
    
    if (self.who == Myself) {
       array = @[@"歌曲",@"歌词",@"收藏",@"灵感记录"];
    }else{
        array = @[@"歌曲",@"歌词",@"收藏"];
    }
    
    
    UIView *backgoundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    
    backgoundView.backgroundColor = [UIColor whiteColor];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    line1.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
    
    [backgoundView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 1)];
    
    line2.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
    
    [backgoundView addSubview:line2];
    
    CGFloat W = ScreenWidth / array.count;
    
    for (int i = 0; i < array.count; i++) {
        
        if (i != 0) {
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(W * i, 0, 1, 60)];
            
            line.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
            
            [backgoundView addSubview:line];
        }
        
        NSToolbarButton *toolbarBtn = [[NSToolbarButton alloc] initWithFrame:CGRectMake(W * i, 0, W, 60)];
        
        [toolbarBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"2.0_toolbarBtn%02d",i]] forState:UIControlStateNormal];
        
        [toolbarBtn setTitle:array[i] forState:UIControlStateNormal];
        
        toolbarBtn.tag = i;
        
        [toolbarBtn addTarget:self action:@selector(toolbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backgoundView addSubview:toolbarBtn];
        
    }
    
    return backgoundView;
}

#pragma mark -tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMyMusicModel * myMusic = dataAry[indexPath.row];
    
    if (type == 1) {
        NSPlayMusicViewController * playVC = [[NSPlayMusicViewController alloc] init];
        playVC.itemUid = myMusic.itemId;
        playVC.from = @"homepage";
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
    }else if (type == 2){
        NSLyricViewController * lyricVC =[[NSLyricViewController alloc] initWithItemId:myMusic.itemId];
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
            
            
            NSLog(@"点击了歌曲");
            
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
            
            NSLog(@"点击了歌词");
            
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
            
            NSLog(@"点击了收藏");
            
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
            
            NSLog(@"点击了灵感记录");
            
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
        
        NSLog(@"点击了删除");

       
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
    [self setupUI];
}

@end







