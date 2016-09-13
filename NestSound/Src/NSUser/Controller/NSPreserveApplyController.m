//
//  NSPreserveApplyController.m
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveApplyController.h"
#import "NSPreserveWorkInfoCell.h"
@interface NSPreserveApplyController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NSPreserveApplyController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupUI];
}

- (void)setupUI{
    self.title = @"保全申请";
    
    [self.view addSubview:self.tableView];
}

#pragma mark -  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
            
        default:
            return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSPreserveWorkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSPreserveWorkInfoCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupData];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - lazy init 

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight -1) style:UITableViewStylePlain];
        [_tableView registerClass:[NSPreserveWorkInfoCell class] forCellReuseIdentifier:@"NSPreserveWorkInfoCellId"];
        _tableView.backgroundColor= [UIColor hexColorFloat:@"f5f5f5"];
//        _tableView.separatorColor = [UIColor hexColorFloat:@"f5f5f5"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
