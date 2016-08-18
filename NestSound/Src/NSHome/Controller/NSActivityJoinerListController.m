//
//  NSActivityJoinerListController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSActivityJoinerListController.h"
#import "NSActivityJoinerListCell.h"
@interface NSActivityJoinerListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NSActivityJoinerListController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initUI];
}

- (void)initUI{
    self.view.backgroundColor = KBackgroundColor;
    self.title = @"参加人";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSActivityJoinerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSActivityJoinerListCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupData];
    
    return cell;
}


#pragma mark - lazy init


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight - 65)];
        [self.tableView registerClass:[NSActivityJoinerListCell class] forCellReuseIdentifier:@"NSActivityJoinerListCellID"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
