//
//  NSCooperationDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#define kAcceptDescription @"采纳后，您的合作需求将会结束并提示为“成功”，不再接受其他人的合作"
#define kCooperateDescription @"您的合作作品在该合作需求期间，您将无法进行删除"

#import "NSCooperationDetailViewController.h"
#import "NSCooperateDetailMainCell.h"
#import "NSCommentListModel.h"
#import "NSUserPageViewController.h"
#import "NSCooperationMessageViewController.h"
#import "NSCommentTableViewCell.h"
#import "NSCooperateDetailWorkCell.h"
#import "NSInvitationListViewController.h"
#import "NSCooperationDetailModel.h"
#import "NSAccompanyListViewController.h"
#import "NSPlayMusicViewController.h"
@interface NSCooperationDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NSCommentTableViewCellDelegate,TTTAttributedLabelDelegate,NSTipViewDelegate>
{
    BOOL _showMoreComment;
    
    CGFloat _lyricViewHeight;
    
    
    BOOL _isAccepted;
    
    NSString *_acceptedWorkId;
    
    BOOL _needRefresh;
}

@property (nonatomic,strong) UITableView *tableView;

//留言数组
@property (nonatomic,strong) NSMutableArray *msgArray;

//合作作品数组
@property (nonatomic,strong) NSMutableArray *coWorksArray;


@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) UIButton *inviteButton;

@property (nonatomic,strong) UIButton *collectButton;

@property (nonatomic,strong) UIButton *cooperateButton;

@property (nonatomic,strong) NSCooperationDetailModel *cooperateModel;

@property (nonatomic,strong) UIImageView *noCooperationView;

@property ( nonatomic,strong) NSTipView *tipView;

@property (nonatomic,strong)  UIView *maskView;


@end

@implementation NSCooperationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
//    [self createData];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_needRefresh == YES) {
        [self postCooperateDetailIsLoadingMore:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _needRefresh = NO;

}

- (void)createData{
    
    for (NSInteger i= 0; i < 4; i ++) {
        NSCommentModel *commentModel = [[NSCommentModel alloc] init];
        commentModel.commentType = 1;
        commentModel.type = 3;
        commentModel.itemID = 14;
        commentModel.userID = [JUserID longLongValue];
        commentModel.targetUserID = 0;
        commentModel.createDate = 1477478721000;
        commentModel.comment = @"Hello world";
        commentModel.headerURL = @"http://pic.yinchao.cn/1476068702.jpg";
        commentModel.nickName = @"JuJuJu";
        commentModel.nowTargetName = @"JuJuJu";
        
        [self.msgArray addObject:commentModel];
    }
    
    
    
}

- (void)setupUI{
    
    self.title = [NSString stringWithFormat:@"%@的合作",self.detailTitle];
    
    [self.view addSubview:self.tableView];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    WS(weakSelf);
    [self.tableView addDDPullToRefreshWithActionHandler:^{
        
        [weakSelf postCooperateDetailIsLoadingMore:NO];
        
    }];
    
    [self.tableView addDDInfiniteScrollingWithActionHandler:^{
        [weakSelf postCooperateDetailIsLoadingMore:YES];
    }];
    
    
    [self.tableView triggerPullToRefresh];
}




#pragma mark - Http metheod

//合作详情页
- (void)postCooperateDetailIsLoadingMore:(BOOL)isLoadingMore{
    
    self.requestType = NO;
    
    if (!isLoadingMore) {
        self.pageIndex = 1;
        
    }else{
        self.pageIndex ++;
        
        
    }
    if (LoginToken) {
        self.requestParams = @{@"did":@(self.cooperationId),
                               @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                               kIsLoadingMore:[NSString stringWithFormat:@"%d",isLoadingMore],
                               @"uid":JUserID,
                               @"token":LoginToken};
    }
    
    self.requestURL = coDetailUrl;
    
}

//合作按钮
- (void)postCooperateAction{
    
    self.requestType = NO;
    
    self.requestParams = @{@"did":@(self.cooperationId),
                           @"uid":JUserID,@"token":LoginToken};
    
        self.requestURL = coCooperateActionUrl;

}
//收藏按钮
- (void)postCollectActionIsSelected:(BOOL)isSelected{
    
    self.requestType = NO;
    
    self.requestParams = @{@"did":@(self.cooperationId),
                           @"uid":JUserID,
                           @"type":[NSString stringWithFormat:@"%d",isSelected],@"token":LoginToken};
        self.requestURL = coCollectActionUrl;

}

//我的采纳
- (void)postAcceptToWorkWithId:(NSString *)workId{

    self.requestType = NO;
    
    self.requestParams = @{@"did":@(self.cooperationId),
                           @"itemid":workId,@"token":LoginToken};
    
    
    self.requestURL = coAcceptActionUrl;

}


#pragma mark - Override get data method
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        
    }else{
        

        if ([operation.urlTag isEqualToString:coDetailUrl]) {
            
            NSCooperationDetailModel *detailModel = (NSCooperationDetailModel *)parserObject;
 
            
            if (!operation.isLoadingMore) {
                
                [self.coWorksArray removeAllObjects];
                
            }
            
            if (detailModel.completeList.count) {
                //重置采纳状态
                _isAccepted = NO;
                [self.coWorksArray addObjectsFromArray:detailModel.completeList];
            }
            
            //判断是否已经被采纳
            for (CoWorkModel *coWorkModel in self.coWorksArray ) {
                if ([coWorkModel.access boolValue]) {
                    _isAccepted = YES;
                    break;
                }
            }

            if (!operation.isLoadingMore) {
                self.cooperateModel = detailModel;

                self.msgArray = [NSMutableArray arrayWithArray:detailModel.commentArray];
                if (self.msgArray.count > 3) {
                    _showMoreComment = YES;
                }else{
                    _showMoreComment = NO;
                }
                [self processUIWithModel:detailModel accepted:_isAccepted];
                
            }
            
            

        }else if ([operation.urlTag isEqualToString:coCooperateActionUrl]){
            CoWorkModel *workModel = (CoWorkModel *)parserObject;
            NSAccompanyListViewController *accompanyController = [[NSAccompanyListViewController alloc] init];
            workModel.did = [NSString stringWithFormat:@"%d",self.cooperationId];
            accompanyController.coWorkModel = workModel;
            [self.navigationController pushViewController:accompanyController animated:YES];
            
            
            
            
            
        }else if ([operation.urlTag isEqualToString:coCollectActionUrl]){
            if (parserObject.code == 200) {
                self.collectButton.selected = !self.collectButton.selected;
                if (self.collectButton.selected) {
                    [[NSToastManager manager] showtoast:@"收藏成功"];
                }else{
                    [[NSToastManager manager] showtoast:@"已取消收藏"];
                }
            }

        }else if ([operation.urlTag isEqualToString:coAcceptActionUrl]){
            if (parserObject.code == 200) {

                [[NSToastManager manager] showtoast:@"采纳成功"];
                [self postCooperateDetailIsLoadingMore:NO];
            }else{

            }
        }
        if (!operation.isLoadingMore) {
            [self.tableView.pullToRefreshView stopAnimating];
            
        }else{
            [self.tableView.infiniteScrollingView stopAnimating];
            
        }

        [self.tableView reloadData];
    }
    
}

- (void)processUIWithModel:(NSCooperationDetailModel *)detailModel accepted:(BOOL)isAccepted{
    if (!self.isMyCoWork) {
        //别人的需求
        switch ([detailModel.demandInfo.status intValue]) {
            case 1:
            {
                self.inviteButton.width = ScreenWidth/3.0f;
                
                [self.view addSubview:self.inviteButton];
                [self.view addSubview:self.collectButton];
                [self.view addSubview:self.cooperateButton];
                
                self.collectButton.selected = detailModel.demandInfo.iscollect;

                
                
                for (NSInteger i=0; i < 2; i ++) {
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*(i+1)/3.0f,CGRectGetMinY(self.inviteButton.frame)+ 6, 0.4, 34)];
                    line.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
                    [self.view addSubview:line];
                }
                
            }
                break;
            case 3:
            case 4:
            case 8:
            {
                self.tableView.height = ScreenHeight - 64;
            }
                break;
                
            default:
                break;
        }
        
        
    }else{
        //我的需求
        
        
        
        //根据是否采纳调整界面
        if (isAccepted) {
            self.tableView.height = ScreenHeight - 64;

        }else{
            self.inviteButton.width = ScreenWidth;
            [self.view addSubview:self.inviteButton];
        }
    }
}



#pragma mark - <UITableViewDelegate,UITableDatasourse>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return _showMoreComment ? 3 :self.msgArray.count ;
        }
            break;
        default:{
            return self.coWorksArray.count ? self.coWorksArray.count : 1;
        }
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] init];
    switch (section) {
        case 0:{
            
        }
            break;
        case 1:{
            headerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
            titleLabel.backgroundColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            titleLabel.text = @"留言";
            titleLabel.textColor = [UIColor hexColorFloat:@"181818"];
            
            [headerView addSubview:titleLabel];
            
            if (!self.msgArray.count) {
                UILabel *linelabel= [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.height - 0.5, ScreenWidth, 0.5)];
                linelabel.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
                [headerView addSubview:linelabel];
            }
           
        }
            break;
        default:{
            headerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
            titleLabel.backgroundColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            titleLabel.text = @"合作完成";
            titleLabel.textColor = [UIColor hexColorFloat:@"181818"];
            
            [headerView addSubview:titleLabel];
            
            
            UILabel *linelabel= [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.height - 0.5, ScreenWidth, 0.5)];
            linelabel.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
            [headerView addSubview:linelabel];
           
            
        }
            break;
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    switch (section) {
        case 0:{
            
        }
            break;
        case 1:{
            footerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
            
            UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
                btn.frame = CGRectMake(0, 0, ScreenWidth, 40);
                [btn setBackgroundColor:[UIColor whiteColor]];
                btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];;
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                
                [btn setTitle: [NSString stringWithFormat:@"全部%lu条留言>>",(unsigned long)self.cooperateModel.demandInfo.commentnum] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor hexColorFloat:@"999999"] forState:UIControlStateNormal];
                
            } action:^(UIButton *btn) {
                
                CHLog(@"跳转到评论");
                
                NSCooperationMessageViewController *cooperationMessageVC = [[NSCooperationMessageViewController alloc] init];
                cooperationMessageVC.msgActBlock = ^(){

                    _needRefresh = YES;
                    
                };
                cooperationMessageVC.isMyCoWork = self.isMyCoWork;
                cooperationMessageVC.cooperationId = self.cooperationId;
                [self.navigationController pushViewController:cooperationMessageVC animated:YES];
            }];

            
            [footerView addSubview:bottomBtn];
        }
            break;
        default:{

        }
            break;
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return _lyricViewHeight;
        }
            break;
        case 1:{
            return 90 ;
        }
            break;
        default:{
            return self.coWorksArray.count ? 98 + 10 : (ScreenWidth * 228/375.0f);
        }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 0.01;
        }
            break;
        case 1:{
            return 40;
        }
            break;
        default:{
            return 40;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return 10;
        }
            break;
        case 1:{
            return 50;
        }
            break;
        default:{
            return 0.01;
        }
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        NSCooperateDetailMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCooperateDetailMainCellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.cooperateModel) {
            [cell showDataWithModel:self.cooperateModel completion:^(CGFloat height) {
                
                if (_lyricViewHeight == height) {
                    return ;
                }else{
                    _lyricViewHeight = height;
                    [self.tableView reloadData];
                }
            }];
        }
        
        
        
        cell.userClickBlock = ^(NSString *userId){
          
            NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:userId];
            
            pageVC.who = !self.isMyCoWork;
            
            [self.navigationController pushViewController:pageVC animated:YES];
            
        };
        
        
        return cell;
    }else if (indexPath.section == 1){
        NSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCommentTableViewCellId"];
        
        if (cell == nil) {
            
            cell = [[NSCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSCommentTableViewCellId"];
            
        }
        cell.delegate = self;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commentModel = self.msgArray[indexPath.row];
        cell.commentLabel.delegate = self;
        
        return cell;
    }else{
        
        if (self.coWorksArray.count) {
            
            
            NSCooperateDetailWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCooperateDetailWorkCellId"];
            if (!cell) {
                cell = [[NSCooperateDetailWorkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSCooperateDetailWorkCellId"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.acceptBlock = ^(NSString *workId){
                
                _acceptedWorkId = workId;
                
                [self.navigationController.view addSubview:self.maskView
                 ];
                
                
                self.tipView.imgName = @"2.3_tipImg_accept";
                
                _tipView.tipText = [NSString stringWithFormat:kAcceptDescription];
                [self.navigationController.view addSubview:_tipView];
                
                
                CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                keyFrame.values = @[@(0.2), @(0.4), @(0.6), @(0.8), @(1.0), @(1.2), @(1.0)];
                keyFrame.duration = 0.3;
                keyFrame.removedOnCompletion = NO;
                [_tipView.layer addAnimation:keyFrame forKey:nil];
                
            };
            
            CoWorkModel *workModel = self.coWorksArray[indexPath.row];
            
            cell.isAccepted = _isAccepted;
            
            [cell setupDataWithCoWorkModel:workModel IsMine:self.isMyCoWork];
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            [cell addSubview:self.noCooperationView];
            self.noCooperationView.center = CGPointMake(ScreenWidth/2.0f, (ScreenWidth * 228/375.0f)/2.0f);
            
            return cell;
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else if(indexPath.section == 1){
        
    }else{
        
        if (self.coWorksArray.count) {
            
            NSMutableArray *itemArray = [NSMutableArray array];
            
            for (CoWorkModel *coWorkModel in self.coWorksArray) {
                [itemArray addObject:@(coWorkModel.itemid.longLongValue)];
            }
            NSPlayMusicViewController *playVC = [NSPlayMusicViewController sharedPlayMusic];
            
            CoWorkModel *workModel = self.coWorksArray[indexPath.row];
            playVC.itemUid = [workModel.itemid longLongValue];
            playVC.songID = indexPath.row;
            //        playVC.songAry = itemArray;
            playVC.isCoWork = YES;
            
            [self.navigationController pushViewController:playVC animated:YES];
        }
    }
        
    
}

#pragma  mark - NSCommentTableViewCellDelegate

- (void)commentTableViewCell:(NSCommentTableViewCell *)cell {
    
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.userID]];

    pageVC.who = (cell.commentModel.userID == [JUserID longLongValue]) ? Myself : Other ;
    
    [self.navigationController pushViewController:pageVC animated:YES];
    
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
        
        if ([_tipView.tipText isEqualToString:kCooperateDescription]) {
            [self postCooperateAction];

        }
        
        if ([_tipView.tipText isEqualToString:kAcceptDescription]) {
            
            [self postAcceptToWorkWithId:_acceptedWorkId];

            
        }

    }];
}
#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSCommentTableViewCell * cell = (NSCommentTableViewCell *)label.superview.superview;
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.targetUserID]];
    pageVC.who = !self.isMyCoWork;
    [self.navigationController pushViewController:pageVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 45 - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor hexColorFloat:@"f4f4f4"];
        [_tableView registerClass:[NSCooperateDetailMainCell class] forCellReuseIdentifier:@"NSCooperateDetailMainCellId"];
        [_tableView registerClass:[NSCommentTableViewCell class] forCellReuseIdentifier:@"NSCommentTableViewCellId"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}


- (NSMutableArray *)msgArray{
    if (!_msgArray) {
        _msgArray = [NSMutableArray array];
    }
    return _msgArray;
}

- (NSMutableArray *)coWorksArray{
    if (!_coWorksArray) {
        _coWorksArray = [NSMutableArray array];
    }
    return _coWorksArray;
}

- (UIButton *)cooperateButton{
    if (!_cooperateButton) {
        _cooperateButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(ScreenWidth*2/3.0f, ScreenHeight - 45 - 64, ScreenWidth/3.0f, 45);
            
            [btn setTitle:@"合作" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [btn setTitleColor:[UIColor hexColorFloat:@"ffd705"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"ic_hezuo"] forState:UIControlStateNormal];

            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
            UILabel *linelabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            linelabel.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
            [btn addSubview:linelabel];
        } action:^(UIButton *btn) {

            [self.navigationController.view addSubview:self.maskView
             ];
            
            
            self.tipView.imgName = @"2.3_tipImg_cooperate";
            
            _tipView.tipText = [NSString stringWithFormat:kCooperateDescription];
            [self.navigationController.view addSubview:_tipView];
            

            CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            keyFrame.values = @[@(0.2), @(0.4), @(0.6), @(0.8), @(1.0), @(1.2), @(1.0)];
            keyFrame.duration = 0.3;
            keyFrame.removedOnCompletion = NO;
            [_tipView.layer addAnimation:keyFrame forKey:nil];
            
            
        }];
    }
    return _cooperateButton;
}

- (UIButton *)inviteButton{
    if (!_inviteButton) {
        _inviteButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(0, ScreenHeight - 45 - 64, ScreenWidth, 45);
            
            [btn setTitle:@"邀请他人" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [btn setTitleColor:[UIColor hexColorFloat:@"666666"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hexColorFloat:@"ffd705"] forState:UIControlStateHighlighted];
            [btn setImage:[UIImage imageNamed:@"ic_yaoqingtaren"] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
            UILabel *linelabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            linelabel.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
            [btn addSubview:linelabel];
        } action:^(UIButton *btn) {
            NSInvitationListViewController *inviteController = [[NSInvitationListViewController alloc] init];
            inviteController.cooperationId = self.cooperationId;
            [self.navigationController pushViewController:inviteController animated:YES];
        }];
    }
    return _inviteButton;
}

- (UIImageView *)noCooperationView{
    if (!_noCooperationView) {
        
        _noCooperationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth *135/375.0, (ScreenWidth *135/375.0)*124/135 )];
        _noCooperationView.image = [UIImage imageNamed:@"no_coWork"];
    }
    
    return _noCooperationView;
}

- (UIButton *)collectButton{
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(ScreenWidth/3.0f, ScreenHeight - 45 - 64, ScreenWidth/3.0f, 45);
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];

            
            [btn setTitle:@"收藏该合作" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hexColorFloat:@"666666"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];

            [btn setTitle:@"取消该收藏" forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor hexColorFloat:@"ffd705"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"ic_shoucangdianji"] forState:UIControlStateSelected];

            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
            UILabel *linelabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            linelabel.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
            [btn addSubview:linelabel];
        } action:^(UIButton *btn) {


            [self postCollectActionIsSelected:!btn.selected];
            
        }];
    }
    return _collectButton;
}

- (NSTipView *)tipView{
    CGFloat padding = ScreenWidth *60/375.0;
    CGFloat width = (ScreenWidth - padding * 2);
    CGFloat height = width * 338/256.0f;
    
    
    _tipView = [[NSTipView alloc] initWithFrame:CGRectMake(padding, (ScreenHeight - height)/2.0f, width, height)];
    
    _tipView.delegate = self;

    return _tipView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        _maskView.backgroundColor = [UIColor lightGrayColor];
        
        _maskView.alpha = 0.5;
    }
    return _maskView;
}


@end
