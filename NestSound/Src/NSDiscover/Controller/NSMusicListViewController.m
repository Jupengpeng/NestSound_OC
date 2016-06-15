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
#import "NSLyricViewController.h"

@interface NSMusicListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    
    UITableView *_tableView;
    NSMutableArray * lyricList;
    NSMutableArray * musicList;
    NSString * musicUrl;
    NSString * lyricUrl;
}


@end

@implementation NSMusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUIAppearance];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchData];
}

#pragma mark - configureUIAppearance
-(void)configureUIAppearance
{
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
    self.requestType = YES;
    self.requestParams = @{@"type":@(YES)};
    NSDictionary * dic = @{@"modelType":@"1"};
    NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:YES];
    NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
    
    musicUrl = [discoverBandURL stringByAppendingString:str];
    self.requestURL = musicUrl;

    NSDictionary * di = @{@"modelType":@"2"};
    NSDictionary * di1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":di} isEncrypt:YES];
    NSString * str1 = [NSString stringWithFormat:@"data=%@",[di1 objectForKey:requestData]];
    lyricUrl = [discoverBandURL stringByAppendingString:str1];
    self.requestURL = lyricUrl;
   
}

#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    
    if (!parserObject.success) {
        NSDiscoverBandListModel * bandListModel = (NSDiscoverBandListModel *)parserObject;
        if ([operation.urlTag isEqualToString:musicUrl]) {
            musicList = [NSMutableArray arrayWithArray:bandListModel.BandMusicList];
        }else if ([operation.urlTag isEqualToString:lyricUrl]){
            lyricList = [NSMutableArray arrayWithArray:bandListModel.BandLyricList];
        }
        
    }else{
    
    }
    
    
    [_tableView reloadData];
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
    NSPlayMusicViewController * playMusicVC;
    if (section == 0) {
        NSNewMusicTableViewCell * cell = (NSNewMusicTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        playMusicVC.itemId = cell.musicModel.itemId;
        [self.navigationController pushViewController:playMusicVC animated:YES];

        
    }else{
        NSNewMusicTableViewCell * cell = (NSNewMusicTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:cell.musicModel.itemId];
        [self.navigationController pushViewController:lyricVC animated:YES];

    }
    
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
