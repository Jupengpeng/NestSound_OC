//
//  NSPreserveListViewController.m
//  NestSound
//
//  Created by yinchao on 16/9/12.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveListViewController.h"
#import "NSPreserveTableViewCell.h"
#import "NSPreserveDetailViewController.h"
#import "NSPreserveSelectViewController.h"
#import "NSPreserveListModel.h"
@interface NSPreserveListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *preserveTab;
}
@property (nonatomic,strong) NSMutableArray *preserveListArr;
@end
static NSString * const preserveCellIdentifier = @"preserveCellIdentifier";
@implementation NSPreserveListViewController
- (NSMutableArray *)preserveListArr {
    if (!_preserveListArr) {
        self.preserveListArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _preserveListArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurePreserveListView];
}
- (void)fetchPreserveListData {
    self.requestType = NO;
    self.requestParams = @{@"id":JUserID,@"token":LoginToken};
    self.requestURL = preserveListUrl;
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:preserveListUrl]) {
            NSPreserveListModel *preserveListModel = (NSPreserveListModel*)parserObject;
            self.preserveListArr = [NSMutableArray arrayWithArray:preserveListModel.preserveList];
        }
    }
}
- (void)configurePreserveListView {
    
    self.title = @"保全列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    preserveTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    preserveTab.dataSource = self;
    
    preserveTab.delegate = self;
    
    preserveTab.rowHeight = 50;
    
    preserveTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self.view addSubview:preserveTab];
}
- (void)rightClick {
    NSPreserveSelectViewController *preserveSelectVC = [[NSPreserveSelectViewController alloc] init];
    [self.navigationController pushViewController:preserveSelectVC animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSPreserveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:preserveCellIdentifier];
    if (!cell) {
        cell = [[NSPreserveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:preserveCellIdentifier];
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSPreserveDetailViewController *preserveDetailVC = [[NSPreserveDetailViewController alloc] init];
    [self.navigationController pushViewController:preserveDetailVC animated:YES];
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
