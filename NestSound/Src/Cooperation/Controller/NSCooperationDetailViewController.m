//
//  NSCooperationDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationDetailViewController.h"
#import "NSCooperateDetailMainCell.h"
#import "NSCommentListModel.h"
#import "NSUserPageViewController.h"
#import "NSCommentViewController.h"
#import "NSCommentTableViewCell.h"
#import "NSCooperateDetailWorkCell.h"
#import "NSInvitationListViewController.h"
@interface NSCooperationDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NSCommentTableViewCellDelegate,TTTAttributedLabelDelegate>
{
    BOOL _showMoreComment;
    
    CGFloat _lyricViewHeight;
}

@property (nonatomic,strong) UITableView *tableView;

//留言数组
@property (nonatomic,strong) NSMutableArray *msgArray;

//合作作品数组
@property (nonatomic,strong) NSMutableArray *coWorksArray;


@property (nonatomic,strong) UIButton *inviteButton;

@property (nonatomic,strong) UIButton *collectButton;

@property (nonatomic,strong) UIButton *cooperateButton;

@end

@implementation NSCooperationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupUI];
    [self createData];

    [self processDataLogic];
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
    
    self.title = self.detailTitle;
    
    [self.view addSubview:self.tableView];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.isMyCoWork = YES;
    if (self.isMyCoWork) {
        self.inviteButton.width = ScreenWidth;
        
        [self.view addSubview:self.inviteButton];
        
    }else{
        self.inviteButton.width = ScreenWidth/3.0f;

        [self.view addSubview:self.inviteButton];
        [self.view addSubview:self.collectButton];
        [self.view addSubview:self.cooperateButton];
        
        for (NSInteger i=0; i < 2; i ++) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*(i+1)/3.0f,CGRectGetMinY(self.inviteButton.frame)+ 6, 0.4, 34)];
            line.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
            [self.view addSubview:line];
        }
        
    }
    
}



- (void)processDataLogic{
    
    if (self.msgArray.count > 3) {
        _showMoreComment = YES;
    }else{
        _showMoreComment = NO;
    }
    
}

#pragma mark - Http metheod

- (void)postAcceptToWorkWithId:(NSString *)workId{
    CHLog(@"已采纳该作品");
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
            return 3;
//            self.coWorksArray.count;
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
                [btn setTitle: [NSString stringWithFormat:@"全部%lu条留言>>",(unsigned long)self.msgArray.count] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor hexColorFloat:@"999999"] forState:UIControlStateNormal];
            } action:^(UIButton *btn) {
                
                CHLog(@"跳转到评论");
                
                NSCommentViewController *commentController = [[NSCommentViewController alloc] initWithItemId:0 andType:1];
                [self.navigationController pushViewController:commentController animated:YES];
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
            return 98 + 10;
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
            return _showMoreComment ? 40 + 10 : 0.01;
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
        
        [cell showDataWithModel:nil completion:^(CGFloat height) {
            CHLog(@"height  %f" ,height);
            
            if (_lyricViewHeight == height) {
                return ;
            }else{
                _lyricViewHeight = height;
                [self.tableView reloadData];
            }
        }];
        
        cell.userClickBlock = ^(NSString *userId){
          
            NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:userId];
            
            pageVC.who = Other;
            
            [self.navigationController pushViewController:pageVC animated:YES];
            
        };
        
        
        return cell;
    }else if (indexPath.section == 1){
        NSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCommentTableViewCellId"];
        
        if (cell == nil) {
            
            cell = [[NSCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSCommentTableViewCellId"];
            
            cell.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commentModel = self.msgArray[indexPath.row];
        cell.commentLabel.delegate = self;
        
        return cell;
    }else{
        NSCooperateDetailWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCooperateDetailWorkCellId"];
        if (!cell) {
            cell = [[NSCooperateDetailWorkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSCooperateDetailWorkCellId"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        cell.acceptBlock = ^(NSString *workId){
          
            
            [self postAcceptToWorkWithId:workId];
        };
        

        [cell setupData];
        
        return cell;
    }

}

#pragma  mark - NSCommentTableViewCellDelegate

- (void)commentTableViewCell:(NSCommentTableViewCell *)cell {
    
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.userID]];
    
    pageVC.who = Other;
    
    [self.navigationController pushViewController:pageVC animated:YES];
    
    
}
#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSCommentTableViewCell * cell = (NSCommentTableViewCell *)label.superview.superview;
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.targetUserID]];
    pageVC.who = Other;
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
            [btn setTitleColor:[UIColor hexColorFloat:@"666666"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hexColorFloat:@"ffd705"] forState:UIControlStateHighlighted];
            [btn setImage:[UIImage imageNamed:@"ic_hezuo"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"ic_shoucangdianji.png"] forState:UIControlStateHighlighted];

            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
            UILabel *linelabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            linelabel.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
            [btn addSubview:linelabel];
        } action:^(UIButton *btn) {
            CHLog(@"合作");
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
            [self.navigationController pushViewController:inviteController animated:YES];
        }];
    }
    return _inviteButton;
}

- (UIButton *)collectButton{
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(ScreenWidth/3.0f, ScreenHeight - 45 - 64, ScreenWidth/3.0f, 45);
            
            [btn setTitle:@"收藏该作品" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [btn setTitleColor:[UIColor hexColorFloat:@"666666"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hexColorFloat:@"ffd705"] forState:UIControlStateHighlighted];
            [btn setImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
            UILabel *linelabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            linelabel.backgroundColor = [UIColor hexColorFloat:@"d9d9d9"];
            [btn addSubview:linelabel];
        } action:^(UIButton *btn) {

            btn.selected = !btn.selected;
            
            [[NSToastManager manager] showtoast:@"收藏成功"];
        }];
    }
    return _collectButton;
}
@end
