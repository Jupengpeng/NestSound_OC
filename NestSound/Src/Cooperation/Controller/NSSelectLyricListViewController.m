//
//  NSSelectLyricListViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSelectLyricListViewController.h"
#import "NSLyricDetailViewController.h"
@interface NSSelectLyricListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *selectLyricListTab;
    int currentPage;
}
@end

@implementation NSSelectLyricListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSelectLyricListView];
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
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * lyricCellIdenfity = @"lyricCell";
    UITableViewCell * lyricCell = [tableView dequeueReusableCellWithIdentifier:lyricCellIdenfity];
    if (!lyricCell) {
        lyricCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lyricCellIdenfity];
        lyricCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    lyricCell.textLabel.text = @"从你的全世界路过";
    lyricCell.textLabel.font = [UIFont systemFontOfSize:14];
    lyricCell.detailTextLabel.text = @"2016.10.25";
    lyricCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    return lyricCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLyricDetailViewController *lyricDetailVC = [[NSLyricDetailViewController alloc] init];
    WS(wSelf);
    lyricDetailVC.lyricBlock = ^(NSString *lyricTitle,long lyricId) {
        
        wSelf.lyricBlock(lyricTitle,lyricId);
    };
    [self.navigationController pushViewController:lyricDetailVC animated:YES];
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
