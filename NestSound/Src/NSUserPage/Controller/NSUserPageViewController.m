//
//  NSUserPageViewController.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserPageViewController.h"
#import "NSTableHeaderView.h"
#import "UINavigationItem+NSAdditions.h"

@interface NSUserPageViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}


@end

@implementation NSUserPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden = YES;
    
    
    NSMutableArray *array = [NSMutableArray array];
   
    UIBarButtonItem *editing = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_editing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(editingClick:)];
    
    [array addObject:editing];
    
    UIBarButtonItem *record = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_record"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(record:)];
    
    [array addObject:record];
    
    self.navigationItem.rightBarButtonItems = array;
    
    NSTableHeaderView *headerView = [[NSTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 290)];
    
    headerView.iconView.image = [UIImage imageNamed:@"img_03"];
    
    headerView.userName.text = @"子夜";
    
    headerView.introduction.text = @"我要这铁棒有何用,我有这变化又如何,还是不安,还是低愁,金箍当头,欲说还休.";
    
    NSString *follow = [NSString stringWithFormat:@"关注: %zd",8];
    
    [headerView.followBtn setTitle:follow forState:UIControlStateNormal];
    
    [headerView.followBtn addTarget:self action:@selector(followClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *fans = [NSString stringWithFormat:@"粉丝: %zd",16];
    
    [headerView.fansBtn setTitle:fans forState:UIControlStateNormal];
    
    [headerView.fansBtn addTarget:self action:@selector(fansClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableHeaderView = headerView;
    
    
    
    
    [self.view addSubview:_tableView];
    
    
}

- (void)followClick:(UIButton *)follow {
    
    NSLog(@"点击了关注");
}

- (void)fansClick:(UIButton *)fansBtn {
    
    NSLog(@"点击了粉丝");
}

- (void)editingClick:(UIBarButtonItem *)editing {
    
    NSLog(@"点击了编辑");
}


- (void)record:(UIBarButtonItem *)record {
    
    NSLog(@"点击了草稿");
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 16;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.textLabel.text = @"哈哈哈";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    
    view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:view];
    return view;
}



@end






