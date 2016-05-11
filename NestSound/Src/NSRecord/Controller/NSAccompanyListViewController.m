//
//  NSAccompanyListViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccompanyListViewController.h"
#import "NSAccompanyListHeaderView.h"
#import "NSAccompanyTableCell.h"
@interface NSAccompanyListViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    UITableView * accompanyListTabelView;
    NSAccompanyListHeaderView * headerView;
    NSMutableArray * hotAccompanyAry;
    NSMutableArray * newAccompanyAry;
    NSMutableArray * dataAry;
}
@end

static NSString * const accompanyCellIditify = @"NSAccompanyTableCell";

@implementation NSAccompanyListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
}


-(void)configureUIAppearance
{
    //accompanyListTableView
    accompanyListTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    accompanyListTabelView.dataSource = self;
    accompanyListTabelView.delegate = self;
    headerView = [[NSAccompanyListHeaderView alloc] init];
    //set tableView headerView
    accompanyListTabelView.tableHeaderView = headerView;
    [accompanyListTabelView registerClass:[NSAccompanyTableCell class] forCellReuseIdentifier:accompanyCellIditify];
    
    [self.view addSubview:accompanyListTabelView];
    //constraints
    [accompanyListTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.top.bottom.equalTo(self.view);
    }];
}

#pragma mark -TableDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAccompanyTableCell * accompanyCell = [tableView dequeueReusableCellWithIdentifier:accompanyCellIditify];
    
    return accompanyCell;
    
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
