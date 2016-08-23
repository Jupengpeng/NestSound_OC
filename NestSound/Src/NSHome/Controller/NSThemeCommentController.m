//
//  NSThemeCommentController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//


static NSString * const NSThemeTopicCommentCellID = @"NSThemeTopicCommentCell";

#import "NSThemeCommentController.h"
#import "NSThemeTopicCommentCell.h"
#import "NSCommentViewController.h"
#import "NSJoinedWorkListModel.h"
#import "NSPlayMusicTool.h"
#import "NSUserPageViewController.h"
#import "NSPlayMusicViewController.h"
#import "NSLyricViewController.h"
@interface NSThemeCommentController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIButton *_clickedButton;

}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *itemIdArr;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic,strong) NSJoinedWorkListModel *workListModel;


@end

@implementation NSThemeCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goTop" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    
    [self.view addSubview:self.tableView];

    [self fetchData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayer)
                                                 name:@"pausePlayer"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePlayItem:)
                                                 name:ChangePlayItemNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayItem:)
                                                 name:PauseCurrentItemNotification
                                               object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pausePlayer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangePlayItemNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PauseCurrentItemNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    
}

- (void)fetchData{
    self.requestType = NO;
    self.page = 1;
    self.requestParams = @{@"aid":(self.aid.length ? self.aid: @"5"),
                           @"type":(self.type.length ? self.type:@"1"),
                           @"sort":[NSString stringWithFormat:@"%d",self.sort],
                           @"page":[NSString stringWithFormat:@"%d",self.page]};
    self.requestURL = joinedWorksDetailUrl;
}

- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        
    }
    else{
        if ([operation.urlTag isEqualToString:joinedWorksDetailUrl]) {
            NSJoinedWorkListModel *workListModel = (NSJoinedWorkListModel *)parserObject;
            self.workListModel = workListModel;
            if (self.dataArray.count) {
                [self.dataArray removeAllObjects];
            }
            

            if (self.itemIdArr.count) {
                [self.itemIdArr removeAllObjects];
            }
            if (workListModel.joinWorkList.count) {

                /**
                 *  歌曲的全部id放进歌单
                 */
                for (NSJoinedWorkDetailModel *detailModel in workListModel.joinWorkList) {
                    [self.itemIdArr addObject:@(detailModel.itemid)];
                    
                    if ([NSPlayMusicViewController sharedPlayMusic].itemUid) {
                        if (detailModel.itemid == [NSPlayMusicViewController sharedPlayMusic].itemUid) {
                            detailModel.isPlay = YES;
                        }
                    }
                }
            }
            [self.dataArray addObjectsFromArray:workListModel.joinWorkList];
        }
        
        [self.tableView reloadData];
    }
}

- (void)changePlayItem:(NSNotification *)notification{
    
    NSInteger playedId = [notification.object integerValue];
    /**
     *  歌曲的全部id放进歌单
     */
    for (NSInteger i = 0 ; i<self.workListModel.joinWorkList.count;i++ )
    {
        NSJoinedWorkDetailModel *detailModel = self.workListModel.joinWorkList[i];
        if ([NSPlayMusicViewController sharedPlayMusic].itemUid) {
            if (detailModel.itemid == playedId)
//                [NSPlayMusicViewController sharedPlayMusic].itemUid)
            {
                
                NSThemeTopicCommentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
                _clickedButton = cell.songCoverButton;
                detailModel.isPlay = YES;
                
                
                
            }else{
                detailModel.isPlay = NO;
            }
        }
        [self.tableView reloadData];
    }
    
}

- (void)pausePlayItem:(NSNotification *)notification{
    
    NSInteger playedId = [notification.object integerValue];
    /**
     *  歌曲的全部id放进歌单
     */
    for (NSInteger i = 0 ; i<self.workListModel.joinWorkList.count;i++ )
    {
        NSJoinedWorkDetailModel *detailModel = self.workListModel.joinWorkList[i];
        if ([NSPlayMusicViewController sharedPlayMusic].itemUid) {
            if (detailModel.itemid == playedId)
//                [NSPlayMusicViewController sharedPlayMusic].itemUid)
            {
                detailModel.isPlay = NO;
            }
        }
        [self.tableView reloadData];
    }
    
}

- (void)pausePlayer {
    [NSPlayMusicTool pauseMusicWithName:nil];
    _clickedButton.selected = NO;
}

-(void)acceptMsg : (NSNotification *)notification{
    
    NSString *notificationName = notification.name;
    
    if ([notificationName isEqualToString:@"goTop"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:@"leaveTop"]){
        self.scrollView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
}





-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}



#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.canScroll) {
        
        [scrollView setContentOffset:CGPointZero];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY<0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"canScroll":@"1"}];
    }
    
    _scrollView = scrollView;
    
}


#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSJoinedWorkDetailModel *workListModel = self.dataArray[indexPath.section];

    if (workListModel.commentnum > 3) {
        return 280;
    }else{
        return (190 + workListModel.commentnum * 20.0f);
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }else{
        return 10.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc] init];
    }
    else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSThemeTopicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSThemeTopicCommentCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    
    NSJoinedWorkDetailModel *workListModel = self.dataArray[indexPath.section];
    workListModel.isMusic = !([self.type integerValue] - 1);
    cell.workDetailModel = workListModel;

    WS(wSelf);
    /**
     *  发表评论
     */
    cell.launchCommentClick = ^(NSInteger clickIndex,id dog){
        
        NSCommentViewController *commentVC = [[NSCommentViewController alloc] initWithItemId: workListModel.itemid andType:[self.type intValue]];
        
        commentVC.musicName = workListModel.title;
        
        [wSelf.navigationController pushViewController:commentVC animated:YES];

    };
    /**
     *  更多评论
     */
    cell.moreCommentClick = ^(NSInteger clickIndex,id dog){
        NSCommentViewController *commentVC = [[NSCommentViewController alloc] initWithItemId: workListModel.itemid andType:[self.type intValue]];
        //        NSCommentViewController *commentVC = [[NSCommentViewController alloc] initWithItemId: wSelf.lyricDetail.itemId andType:2];
        
        commentVC.musicName = workListModel.title;
        
        [self.navigationController pushViewController:commentVC animated:YES];
        
    };
    
    
    cell.headerClickBlock = ^(NSJoinedWorkDetailModel *workDetailModel){
        NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",workDetailModel.userid]];
        if (workDetailModel.userid != [JUserID integerValue]) {
            pageVC.who = Other;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
    };
    
    
    cell.workCoverBlock = ^(NSJoinedWorkDetailModel *workDetailModel,UIButton *clickButton){
        /**
         *  取消上一个点击状态
         */
        if (_clickedButton == clickButton) {

        }else{
            _clickedButton.selected = NO;
            _clickedButton = clickButton;
            _clickedButton.selected = YES;
        }
        
        if (clickButton.selected) {
            [NSPlayMusicViewController sharedPlayMusic].itemUid = workListModel.itemid;
            if (!self.player) {
                [NSPlayMusicTool pauseMusicWithName:nil];
                self.player = [NSPlayMusicTool playMusicWithUrl:workDetailModel.mp3 block:^(AVPlayerItem *item) {}];
            } else {
                self.player = [NSPlayMusicTool playMusicWithUrl:workDetailModel.mp3 block:^(AVPlayerItem *item) {}];
            }
        } else {
            [NSPlayMusicTool pauseMusicWithName:nil];
            [NSPlayMusicViewController sharedPlayMusic].itemUid = 0;
            //        self.player = [NSPlayMusicTool playMusicWithUrl:cell.accompanyModel.mp3URL block:^(AVPlayerItem *item) {}];
        }
        
    };
    
    
    cell.commetorClickBlock = ^(NSInteger userId){
        NSUserPageViewController *userPageController = [[NSUserPageViewController alloc]initWithUserID:[NSString stringWithFormat:@"%ld",userId]];
        userPageController.who = His;
        [self.navigationController pushViewController:userPageController animated:YES];
    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSJoinedWorkDetailModel *workListModel = self.dataArray[indexPath.section];

    
    if ([self.type isEqualToString:@"1"]) {
        NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
        
        playVC.itemUid = workListModel.itemid;
//        playVC.from = @"tuijian";
        
        playVC.songID = indexPath.section;
        playVC.songAry = self.itemIdArr;
        
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
    if ([self.type isEqualToString:@"2"]) {
        NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:workListModel.itemid];
        [self.navigationController pushViewController:lyricVC animated:YES];
        
    }
    
}



#pragma mark - lazy init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 41)];
        [self.tableView registerClass:[NSThemeTopicCommentCell class] forCellReuseIdentifier:NSThemeTopicCommentCellID];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor hexColorFloat:@"f6f6f6"];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        footerView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)itemIdArr{
    if (!_itemIdArr) {
        _itemIdArr = [NSMutableArray array];
    }
    return _itemIdArr;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
