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
@interface NSPreserveListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end
static NSString * const preserveCellIdentifier = @"preserveCellIdentifier";
@implementation NSPreserveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurePreserveListView];
}
- (void)configurePreserveListView {
    
    self.title = @"保全列表";
    
    UITableView *preserveTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    preserveTab.dataSource = self;
    
    preserveTab.delegate = self;
    
    [self.view addSubview:preserveTab];
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
    return 0.1;
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
