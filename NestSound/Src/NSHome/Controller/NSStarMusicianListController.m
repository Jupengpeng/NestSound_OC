//
//  NSJoinerListController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSStarMusicianListController.h"
#import "NSStarMusicianListCell.h"
#import "NSStarMusicianDetailController.h"
@interface NSStarMusicianListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NSStarMusicianListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
}

- (void)setupUI{
    
    
    self.title = @"明星音乐人";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSStarMusicianListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSStarMusicianListCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [cell updateUIWithData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSStarMusicianDetailController *detailController= [[NSStarMusicianDetailController alloc]init];
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        
        [_tableView registerClass:[NSStarMusicianListCell class] forCellReuseIdentifier:@"NSStarMusicianListCellId"];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

@end
