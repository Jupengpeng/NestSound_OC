//
//  NSNewMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSNewMusicViewController.h"
#import "NSNewMusicTableViewCell.h"
#import "NSDiscoverMoreLyricModel.h"
#import "NSPlayMusicViewController.h"
#import "NSLyricViewController.h"
@interface NSNewMusicViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
    NSMutableArray * DataAry;
    BOOL isLyric;
    BOOL isSecret;
    int currentPage;
    NSString * url;
    int type;
    UIImageView * playStatus;
    NSString * MusicType;
    UIImageView *emptyImage;
}
@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;
@property (nonatomic, strong) NSMutableArray *itemIdList;
@end

@implementation NSNewMusicViewController
- (NSPlayMusicViewController *)playSongsVC {
    
    if (!_playSongsVC) {
        
        _playSongsVC = [NSPlayMusicViewController sharedPlayMusic];
        
    }
    
    return _playSongsVC;
}
- (NSMutableArray *)itemIdList {
    if (!_itemIdList) {
        self.itemIdList = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemIdList;
}
-(instancetype)initWithType:(NSString *)Musictype andIsLyric:(BOOL)isLyric_ andIsSecret:(BOOL)isSecret_
{
    self = [super init];
    if (self) {
        MusicType = Musictype;
        isLyric = isLyric_;
        isSecret = isSecret_;
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
    if (isLyric) {
        if ([MusicType isEqualToString:@"hot"]) {
            self.title = @"热门歌词";
        }  else if ([MusicType isEqualToString:@"lyric"]) {
            self.title = @"我的歌词";
        } else{
            self.title = @"最新歌词";
        }
    }else{
        if ([MusicType isEqualToString:@"hot"]) {
            self.title = @"热门歌曲";
            //          LocalizedStr(@"promot_hotMusic");
        }else if ([MusicType isEqualToString:@"music"]) {
            self.title = @"我的歌曲";
        }
        else{
            self.title = @"最新歌曲";
            //        LocalizedStr(@"promot_newMusic");
        }
    }
    
    _tableView = [[UITableView alloc] init];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 90;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view = _tableView;
    
    WS(wSelf);
    //refresh
    [_tableView addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
        
            [wSelf fetchDataWithIsLoadingMore:NO];
        }
    }];
    
    //loadingMore
    [_tableView addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchDataWithIsLoadingMore:YES];
        }
    }];
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.2_noDataImg"]];
    
    emptyImage.hidden = YES;
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [self.view addSubview:emptyImage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (DataAry.count == 0) {
        [self fetchDataWithIsLoadingMore:NO];
    }
    
    if (self.playSongsVC.player == nil) {
        
    } else {
        
        if (self.playSongsVC.player.rate != 0.0) {
            [playStatus startAnimating];
        }else{
            [playStatus stopAnimating];
        }
    }
    
}



#pragma mark -fetchData
-(void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    self.requestType = YES;
    NSDictionary * dic;
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{kIsLoadingMore :@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    if ([MusicType isEqualToString:@"hot"]) {
        dic = @{@"page":[NSNumber numberWithInt:currentPage],@"orderType":[NSNumber numberWithInt:2]};
    }else if ([MusicType isEqualToString:@"music"]){
        dic = @{@"uid":JUserID,@"token":LoginToken,@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:1]};
    } else if ([MusicType isEqualToString:@"lyric"]) {
        dic = @{@"uid":JUserID,@"token":LoginToken,@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:2]};
    } else {
        dic = @{@"page":[NSNumber numberWithInt:currentPage],@"orderType":[NSNumber numberWithInt:1]};
    }
    
    NSString * str = [NSTool encrytWithDic:dic];
    if (isLyric) {
        if ([MusicType isEqualToString:@"lyric"]) {
            url = [userMLICListUrl stringByAppendingString:str];
        } else {
            url = [discoverLyricMoreURL stringByAppendingString:str];
        }
    }else{
        if ([MusicType isEqualToString:@"music"]) {
            url = [userMLICListUrl stringByAppendingString:str];
        } else {
            url = [discoverMusicMoreURL stringByAppendingString:str];
        }
    }
    self.requestURL = url;

}



#pragma mark -override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if ( requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                NSDiscoverMoreLyricModel * discoverMore = (NSDiscoverMoreLyricModel *)parserObject;
                if (!operation.isLoadingMore) {
                    [_tableView.pullToRefreshView stopAnimating];
                    DataAry = [NSMutableArray arrayWithArray:discoverMore.moreLyricList];
                    
                    for (NSMyMusicModel *model in DataAry) {
                        [self.itemIdList addObject:@(model.itemId)];
                    }
                }else{
                    [_tableView.infiniteScrollingView stopAnimating];
                    [DataAry addObjectsFromArray:discoverMore.moreLyricList];
                    for (NSMyMusicModel *model in DataAry) {
                        [self.itemIdList addObject:@(model.itemId)];
                    }
                }
                [_tableView reloadData];
                if (!DataAry.count) {
                    emptyImage.hidden = NO;
                } else {
                    emptyImage.hidden = YES;
                }
            } else if ([operation.urlTag isEqualToString:deleteWorkURL]||[operation.urlTag isEqualToString:changeMusicStatus] || [operation.urlTag isEqualToString:changeLyricStatus]) {
                [self fetchDataWithIsLoadingMore:NO];
            }
        }
    }

}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return DataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"newMusicCell";
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    //    [cell addDateLabel];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cell.mas_left);
    }];
    
    cell.numLabel.hidden = YES;
    cell.myMusicModel = DataAry[indexPath.row];
    if (isSecret == YES) {
        
        cell.secretImgView.hidden = YES;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMyMusicModel * myModel = DataAry[indexPath.row];
    long itemID = myModel.itemId;
    if (isLyric) {
        NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:itemID];
        [self.navigationController pushViewController:lyricVC animated:YES];
    }else{
        NSPlayMusicViewController * playVC =[[NSPlayMusicViewController alloc] init];
        
        if ([MusicType isEqualToString:@"hot"]) {
           playVC.from = @"red";
        }else{
           playVC.from = @"news";
        }
        playVC.itemUid = itemID;
        playVC.geDanID = 0;
        playVC.songID = indexPath.row;
        playVC.songAry = self.itemIdList;
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
}
#pragma mark edit
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isSecret == NO) {
        
        return YES;
    } else {
        
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        self.requestType = NO;
        NSMyMusicModel * myMode = DataAry[indexPath.row];
        if ([MusicType isEqualToString:@"lyric"]) {
            type = 2;
        } else if ([MusicType isEqualToString:@"music"]) {
            type = 1;
        }
        self.requestParams = @{@"id": @(myMode.itemId), @"type": @(type),@"token":LoginToken};
        
        self.requestURL = deleteWorkURL;
//        
        [DataAry removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *status;
    int isShow;
    NSMyMusicModel *model = DataAry[indexPath.row];
    if (!model.isShow) {
        status = @"设为公开";
        isShow = 1;
    } else {
        status = @"设为私密";
        isShow = 0;
    }
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:status handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //在block中实现相对应的事件
        
        if ([MusicType isEqualToString:@"music"]) {
            self.requestType = NO;
            self.requestParams = @{@"id":[NSNumber numberWithLong:model.itemId],@"is_issue":[NSNumber numberWithInt:isShow],@"token":LoginToken};
            self.requestURL = changeMusicStatus;
            
        } else if ([MusicType isEqualToString:@"lyric"]) {
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
        NSMyMusicModel * myMode = DataAry[indexPath.row];
        if (type == 3) {
            self.requestParams = @{@"work_id":@(myMode.itemId),@"target_uid":@(myMode.userID),@"user_id":JUserID,@"token":LoginToken,@"wtype":@(myMode.type),};
            self.requestURL = collectURL;
        }else{
            int productType;
            if ([MusicType isEqualToString:@"lyric"]) {
                productType = 2;
            } else if ([MusicType isEqualToString:@"music"]) {
                productType = 1;
            }
            self.requestParams = @{@"id": @(myMode.itemId), @"type": @(productType),@"token":LoginToken};
            
            self.requestURL = deleteWorkURL;
        }
        
        [DataAry removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    //此处UITableViewRowAction对象放入的顺序决定了对应按钮在cell中的顺序
    if (isSecret == NO) {
        return @[delete,action];
    } else {
        return nil;
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







