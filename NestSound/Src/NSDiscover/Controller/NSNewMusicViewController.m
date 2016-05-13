//
//  NSNewMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSNewMusicViewController.h"
#import "NSNewMusicTableViewCell.h"

@interface NSNewMusicViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}

@end

@implementation NSNewMusicViewController

-(instancetype)initWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        self.MusicType = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.MusicType isEqualToString:@"hot"]) {
        self.title = LocalizedStr(@"promot_hotMusic");
    }else{
        self.title = LocalizedStr(@"promot_newMusic");
    }
    
    
    _tableView = [[UITableView alloc] init];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
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
    
    static NSString *ID = @"newMusicCell";
    
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







