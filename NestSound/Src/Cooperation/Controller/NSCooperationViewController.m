//
//  NSCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationViewController.h"
#import "NSCooperationDetailViewController.h"
#import "NSInvitationListTableViewCell.h"
#import "NSCooperationListTableViewCell.h"
#import "NSCooperationCommentCell.h"
#import "NSLabelTableViewCell.h"
@interface NSCooperationViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,NSInvitationListTableViewCellDelegate>
{
    UIImageView *emptyImgView;
    UITableView *cooperationTab;
    
}


@end

@implementation NSCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCooperationViewController];
}
- (void)setupCooperationViewController {
    
    //合作
    cooperationTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    cooperationTab.delegate = self;
    
    cooperationTab.dataSource = self;
    
//    cooperationTab.rowHeight = 80;
    
    cooperationTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cooperationTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //    [musicTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:musicCellIdentify];
    self.view = cooperationTab;
    
    WS(Wself);
    //refresh
    [cooperationTab addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            //            [Wself fetchDataWithType:1 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [cooperationTab addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        //        [Wself fetchDataWithType:1 andIsLoadingMore:YES];
    }];
    emptyImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyImgView.hidden = YES;
    
    emptyImgView.centerX = ScreenWidth/2;
    
    emptyImgView.y = 100;
    
    [cooperationTab addSubview:emptyImgView];
    
    
   
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString *ID = @"TopCell";
        
        NSInvitationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[NSInvitationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"midCell";
        
        NSCooperationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[NSCooperationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.row == 5) {
        static NSString * commentCellIdenfity = @"commentCell";
        NSCooperationCommentCell * commentCell = [tableView dequeueReusableCellWithIdentifier:commentCellIdenfity];
        if (!commentCell) {
            commentCell = [[NSCooperationCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdenfity];
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return commentCell;
    } else {
        
        static NSString * publicCellIdenfity = @"bottomCell";
        NSLabelTableViewCell * bottomCell = [tableView dequeueReusableCellWithIdentifier:publicCellIdenfity];
        if (!bottomCell) {
            bottomCell = [[NSLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:publicCellIdenfity];
            bottomCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        return bottomCell;
    }
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSCooperationDetailViewController *cooperationDetailVC = [[NSCooperationDetailViewController alloc] init];
    
    [self.navigationController pushViewController:cooperationDetailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 60;
    } else if (indexPath.row == 1) {
        return 170;
    } else {
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.5;
}
#pragma mark - NSInvitationListTableViewCellDelegate
- (void)invitationBtnClickWith:(NSInvitationListTableViewCell *)cell {
    self.requestType = NO;
    self.requestParams = @{@"did":@"",@"uid":JUserID,@"itemid":@""};
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
