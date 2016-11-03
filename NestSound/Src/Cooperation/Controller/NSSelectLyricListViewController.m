//
//  NSSelectLyricListViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSelectLyricListViewController.h"
#import "NSLyricDetailViewController.h"
#import "NSCooperationLyricListModel.h"
@interface NSSelectLyricListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *selectLyricListTab;
    int currentPage;
}
@property (nonatomic, strong) NSMutableArray *lyricListArr;
@end

@implementation NSSelectLyricListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSelectLyricListView];
    [self fetchCooperationLyricsWithIsLoadingMore:NO];
}
#pragma mark - Network Requests and Data Handling
- (void)fetchCooperationLyricsWithIsLoadingMore:(BOOL)isLoadingMore {
    if (!isLoadingMore) {
        self.requestType = NO;
        currentPage = 1;
        self.requestParams = @{@"page":@(currentPage),@"uid":JUserID,kIsLoadingMore:@(NO),@"token":LoginToken};
    }else{
        ++currentPage;
        self.requestParams = @{@"page":@(currentPage),@"uid":JUserID,kIsLoadingMore:@(YES),@"token":LoginToken};
    }
    
    self.requestURL = demandLyricListUrl;
    
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:demandLyricListUrl]) {
            NSCooperationLyricListModel *model = (NSCooperationLyricListModel *)parserObject;
            if (!operation.isLoadingMore) {
                [selectLyricListTab.pullToRefreshView stopAnimating];
                
                self.lyricListArr = [NSMutableArray arrayWithArray:model.cooperationLyricList];
                
            }else{
                [selectLyricListTab.infiniteScrollingView stopAnimating];
                [self.lyricListArr addObjectsFromArray:model.cooperationLyricList];
            }
            [selectLyricListTab reloadData];
        }
    }
}
#pragma mark - SetupUI
- (void)setupSelectLyricListView {
    
    self.title = @"选择歌词";
    
    selectLyricListTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    selectLyricListTab.dataSource = self;
    
    selectLyricListTab.delegate = self;
    
    [self.view addSubview:selectLyricListTab];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyricListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * lyricCellIdenfity = @"lyricCell";
    UITableViewCell * lyricCell = [tableView dequeueReusableCellWithIdentifier:lyricCellIdenfity];
    if (!lyricCell) {
        lyricCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lyricCellIdenfity];
        lyricCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CooperationLyricModel *model = self.lyricListArr[indexPath.row];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = model.title;
    [lyricCell addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lyricCell.contentView.mas_left).offset(10);
        
        make.top.bottom.equalTo(lyricCell.contentView);
    }];
    UIImageView *secretImg = [[UIImageView alloc] init];
    secretImg.image = [UIImage imageNamed:@"2.0_password_icon"];
    [lyricCell addSubview:secretImg];
    
    [secretImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(titleLabel.mas_right).offset(10);
        
        make.centerY.equalTo(lyricCell.mas_centerY);
        
        make.size.mas_offset(CGSizeMake(12, 14));
    }];
    if (model.isOpened) {
        secretImg.hidden = YES;
    } else {
        secretImg.hidden = NO;
    }
    lyricCell.detailTextLabel.text = [date datetoLongLongStringWithDate:model.createTime];
    lyricCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    return lyricCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CooperationLyricModel *model = self.lyricListArr[indexPath.row];
    NSLyricDetailViewController *lyricDetailVC = [[NSLyricDetailViewController alloc] init];
    lyricDetailVC.lyricModel = model;

    WS(wSelf);
    lyricDetailVC.lyricBlock = ^(NSString *lyricTitle,long lyricId) {
        
        wSelf.lyricBlock(lyricTitle,lyricId);
    };
    [self.navigationController pushViewController:lyricDetailVC animated:YES];
}
- (NSMutableArray *)lyricListArr {
    if (!_lyricListArr) {
        self.lyricListArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _lyricListArr;
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
