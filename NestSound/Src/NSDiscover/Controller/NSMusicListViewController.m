//
//  NSMusicListViewController.m
//  NestSound
//
//  Created by Apple on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicListViewController.h"
#import "NSNewMusicTableViewCell.h"
#import "NSDiscoverBandListModel.h"
#import "NSPlayMusicViewController.h"
@interface NSMusicListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    
    UITableView *_tableView;
    NSMutableArray * lyricList;
    NSMutableArray * musicList;
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


#pragma  mark -fetchData
-(void)fetchData
{
    self.requestType =YES;
    self.requestParams = nil;
//    self.requestURL =;


}

#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
//    if ([operation.urlTag isEqualToString:]) {
//        if (!parserObject.success) {
//            NSDiscoverBandListModel * bandListModel = (NSDiscoverBandListModel *)parserObject;
//            lyricList = [NSMutableArray arrayWithArray:bandListModel.BandLyricList];
//            musicList = [NSMutableArray arrayWithArray:bandListModel.BandMusicList];
//        }
//    }

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *ID = @"musicListCell";
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    if (section == 0) {
        cell.musicModel = (NSBandMusic *)musicList[row];
    }else{
        cell.musicModel = (NSBandMusic *)lyricList[row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.numLabel.text = [NSString stringWithFormat:@"%02zd",indexPath.row + 1];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSPlayMusicViewController * playMusicVC;
    if (section == 0) {
        NSNewMusicTableViewCell * cell = (NSNewMusicTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        playMusicVC = [playMusicVC]l;
        
    }else{
        NSNewMusicTableViewCell * cell = (NSNewMusicTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
//        playMusicVC = [playMusicVC]l;
    }
    
//    [self.navigationController pushViewController: animated:YES];
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
