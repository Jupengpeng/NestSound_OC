//
//  NSCooperationDetailViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationDetailViewController.h"

@interface NSCooperationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NSCooperationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupUI];
}

- (void)setupUI{
    
    self.title = self.detailTitle;
    
    [self.view addSubview:self.tableView];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
}

#pragma mark - <UITableViewDelegate,UITableDatasourse>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            
        }
            break;
        case 1:{
            
        }
            break;
        default:{
            
        }
            break;
    }
    return 3;
    
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45) style:UITableViewStyleGrouped];
        
    }
    return _tableView;
}




@end
