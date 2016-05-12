//
//  NSMusicListViewController.m
//  NestSound
//
//  Created by Apple on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicListViewController.h"
#import "NSNewMusicTableViewCell.h"

@interface NSMusicListViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}


@end

@implementation NSMusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 70;
    
    
    self.view = _tableView;

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 100;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"musicListCell";
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    cell.numLabel.text = [NSString stringWithFormat:@"%02zd",indexPath.section + 1];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击了第%zd个cell",indexPath.section);
}







@end
