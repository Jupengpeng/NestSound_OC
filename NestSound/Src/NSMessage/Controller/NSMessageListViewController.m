//
//  NSMessageListViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMessageListViewController.h"

@interface NSMessageListViewController ()<
UITableViewDataSource,
UITableViewDelegate
>
{
    UITableView * messageList;
    NSMutableArray * messageArr;
}

@end


@implementation NSMessageListViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIAppearance];
    
}


#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    //nav
    self.title = self.messageListType;
    self.showBackBtn = YES;
    
    //messageList tableview
    messageList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    messageList.delegate = self;
    messageList.dataSource = self;
    messageList.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //messageArr
    messageArr = [[NSMutableArray alloc] init];
    [self.view addSubview:messageList];

    
    //constraints
    [messageList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}


#pragma mark tableview dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell = [[UITableViewCell alloc] init];
    
    return cell;
}

@end
