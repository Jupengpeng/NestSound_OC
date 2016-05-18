//
//  NSUserPageViewController.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserPageViewController.h"
#import "NSTableHeaderView.h"
#import "UINavigationItem+NSAdditions.h"
#import "NSToolbarButton.h"
#import "NSNewMusicTableViewCell.h"



@interface NSUserPageViewController () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate> {
    
    UITableView *_tableView;
}


@end

@implementation NSUserPageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSTableHeaderView *headerView = [[NSTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 290)];
    
    if (self.who == Myself) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settingClick:)];
        
        [array addObject:setting];
        
        UIBarButtonItem *draft = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_draft"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(draftClick:)];
        
        [array addObject:draft];
        
        self.navigationItem.rightBarButtonItems = array;
        
        headerView.iconView.image = [UIImage imageNamed:@"img_03"];
        
        headerView.userName.text = @"子夜";
        
        headerView.introduction.text = @"我要这铁棒有何用,我有这变化又如何,还是不安,还是低惆,金箍当头,欲说还休.";
        
        [headerView.followBtn setTitle:[NSString stringWithFormat:@"关注: %zd",8] forState:UIControlStateNormal];
        
        [headerView.fansBtn setTitle:[NSString stringWithFormat:@"粉丝: %zd",16] forState:UIControlStateNormal];
    }
    
    if (self.who == Other) {
        
        UIBarButtonItem *follow = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2.0_follow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(followClick:)];
        
        self.navigationItem.rightBarButtonItem = follow;
        
        headerView.iconView.image = [UIImage imageNamed:@"img_02"];
        
        headerView.userName.text = @"烟魂";
        
        headerView.introduction.text = @"我要这铁棒醉舞魔,我有这变化乱迷浊,踏破凌霄,放肆桀骜,事恶道险,终究难逃.";
        
        [headerView.followBtn setTitle:[NSString stringWithFormat:@"关注: %zd",9] forState:UIControlStateNormal];
        
        [headerView.fansBtn setTitle:[NSString stringWithFormat:@"粉丝: %zd",17] forState:UIControlStateNormal];
        
    }
    
    
    [headerView.followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView.fansBtn addTarget:self action:@selector(fansBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableHeaderView = headerView;
    
    [self.view addSubview:_tableView];
    
    
}

- (void)followBtnClick:(UIButton *)follow {
    if (self.who == Myself) {
        
        NSLog(@"点击了自己的关注");
    }
    
    if (self.who == Other) {
        
        NSLog(@"点击了他人的关注");
    }
    
}

- (void)fansBtnClick:(UIButton *)fansBtn {
    if (self.who == Myself) {
        
        NSLog(@"点击了自己的粉丝");
    }
    
    if (self.who == Other) {
        
        NSLog(@"点击了他人的粉丝");
    }
    
}



- (void)settingClick:(UIBarButtonItem *)editing {
    
    NSLog(@"点击了设置");
}


- (void)draftClick:(UIBarButtonItem *)record {
    
    NSLog(@"点击了草稿");
}

- (void)followClick:(UIBarButtonItem *)follow {
    
    NSLog(@"点击了Nav的关注");
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 16;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cell.mas_left);
    }];
    
    cell.numLabel.hidden = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    
    
    NSArray *array = @[@"灵感记录",@"歌曲",@"歌词",@"收藏"];
    
    UIView *backgoundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    
    backgoundView.backgroundColor = [UIColor whiteColor];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    line1.backgroundColor = [UIColor lightGrayColor];
    
    [backgoundView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 1)];
    
    line2.backgroundColor = [UIColor lightGrayColor];
    
    [backgoundView addSubview:line2];
    
    CGFloat W = ScreenWidth / 4;
    
    for (int i = 0; i < array.count; i++) {
        
        if (i != 0) {
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(W * i, 0, 1, 60)];
            
            line.backgroundColor = [UIColor lightGrayColor];
            
            [backgoundView addSubview:line];
        }
        
        NSToolbarButton *toolbarBtn = [[NSToolbarButton alloc] initWithFrame:CGRectMake(W * i, 0, W, 60) image:[UIImage imageNamed:[NSString stringWithFormat:@"2.0_toolbarBtn%02d",i]] addTitle:array[i]];
        
        toolbarBtn.tag = i;
        
        [toolbarBtn addTarget:self action:@selector(toolbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backgoundView addSubview:toolbarBtn];
        
    }
    
    
    return backgoundView;
    
    
    
}

- (void)toolbarBtnClick:(UIButton *)toolbarBtn {
    
    switch (toolbarBtn.tag) {
        
        case 0:
            
            NSLog(@"点击了灵感记录");
            
            break;
        
        case 1:
        
            NSLog(@"点击了歌曲");
            
            break;
        
        case 2:
        
            NSLog(@"点击了歌词");
            
            break;
        
        case 3:
        
            NSLog(@"点击了收藏");
            
            break;
        
        default:
        
            break;
    }
    
    
}


@end






