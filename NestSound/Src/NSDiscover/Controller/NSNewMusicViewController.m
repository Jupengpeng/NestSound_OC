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
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 80;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view = _tableView;
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 16;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"newMusicCell";
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    
    [cell addDateLabel];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cell.mas_left);
    }];
    
    cell.numLabel.hidden = YES;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击了第%zd个cell",indexPath.row);
}


@end







