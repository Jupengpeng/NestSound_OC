//
//  NSMessageViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMessageViewController.h"


@interface NSMessageViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView * _messageTypeTab;
    
}
@end



@implementation NSMessageViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIAppearance];

}


-(void)configureUIAppearance
{
    //messageType table
    _messageTypeTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _messageTypeTab.delegate = self;
    _messageTypeTab.dataSource = self;
    
}


#pragma mark tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
    
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * MessageCellIdenfity = @"MessageCell";
    UITableViewCell * messageCell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdenfity];
    if (!messageCell) {
        messageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageCellIdenfity];
        messageCell.backgroundColor = [UIColor whiteColor];
    }
    
    return messageCell;
}


#pragma mark tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
