//
//  NSCleanCacheViewController.m
//  NestSound
//
//  Created by yintao on 2016/12/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCleanCacheViewController.h"

@interface NSCleanCacheViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NSCleanCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCleanCacheViewController];
}
- (void)setupCleanCacheViewController {
    self.title = @"清除缓存";
    
    UITableView *cleanCacheTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    cleanCacheTab.delegate = self;
    
    cleanCacheTab.dataSource = self;
    
    cleanCacheTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self.view addSubview:cleanCacheTab];
    
//    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
//    
//    [cleanCacheTab setTableFooterView:noLineView];
    
    [cleanCacheTab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.right.equalTo(self.view);
        
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cleanCacheCell";
    NSArray *textStrs = @[@"清除歌曲缓存",@"清除其他数据缓存"];
    NSArray *detailStrs = @[@"45M",@"138M"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = textStrs[indexPath.row];
    cell.detailTextLabel.text = detailStrs[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (!indexPath.row) {
//        [[NSToastManager manager] showtoast:@"清除歌曲缓存"];
//    } else {
//        [[NSToastManager manager] showtoast:@"清除其他数据缓存"];
//    }
    [[NSToastManager manager] showtoast:@"清除成功"];
    cell.detailTextLabel.text = @"0M";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
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