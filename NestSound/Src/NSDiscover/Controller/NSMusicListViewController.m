//
//  NSMusicListViewController.m
//  NestSound
//
//  Created by Apple on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicListViewController.h"
#import "NSNewMusicTableViewCell.h"

@interface NSMusicListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    
    UITableView *_tableView;
}


@end

@implementation NSMusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];//]WithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 80;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.view = _tableView;

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"musicListCell";
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.numLabel.text = [NSString stringWithFormat:@"%02zd",indexPath.row + 1];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击了第%zd个cell",indexPath.row);
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    
    headerView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_vertical"]];
    
    icon.layer.cornerRadius = icon.width * 0.5;
    
    icon.clipsToBounds = YES;
    
    [headerView addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headerView.mas_left).offset(15);
        
        make.bottom.equalTo(headerView.mas_bottom);
        
    }];
    
    
    UILabel *titleLable = [[UILabel alloc] init];
    
    titleLable.font = [UIFont systemFontOfSize:15];
    
    if (section == 0) {
        
        titleLable.text = LocalizedStr(@"歌曲榜");
    } else {
        
        titleLable.text = LocalizedStr(@"歌词榜");
    }
    
    [headerView addSubview:titleLable];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(headerView.mas_bottom);
        
        make.left.equalTo(icon.mas_right).offset(8);
        
    }];
    
    return headerView;
}




@end
