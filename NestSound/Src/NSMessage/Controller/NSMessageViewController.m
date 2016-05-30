//
//  NSMessageViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMessageViewController.h"
#import "NSMessageListViewController.h"
#import "NSMessageListModel.h"

@interface NSMessageViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView * _messageTypeTab;
    NSArray * imageAry;
    NSArray * titleAry;
    NSMutableArray * bageAry;
    
}
@end



@implementation NSMessageViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIAppearance];

}

#pragma mark -fetchData
-(void)fetchData
{
    NSString * userID;
    
    
//    self.requestType = NO;
//    self.requestURL =;
//    self.requestParams = ;
    

}


#pragma mark override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        
        NSMessageListModel * messageList = (NSMessageListModel *)parserObject;
        
        messageCountModel * mess = messageList.messageCount;
        bageAry = [NSMutableArray array];
 
        [bageAry addObject:[NSString stringWithFormat:@"%d",mess.commentCount]];
        [bageAry addObject:[NSString stringWithFormat:@"%d",mess.upvoteCount]];
        [bageAry addObject:[NSString stringWithFormat:@"%d",mess.collecCount]];
        [bageAry addObject:[NSString stringWithFormat:@"%d",mess.systemCount]];
    }
    
}


#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //imageAry;
    imageAry = @[@"",@"",@"",@""];
    
    //titleAry
    titleAry = @[LocalizedStr(@"prompt_commentMessage"),
                 LocalizedStr(@"prompt_upvote"),
                 LocalizedStr(@"prompt_collection"),
                 LocalizedStr(@"prompt_systemMessage")
                 ];
    
    
    //messageType table
    _messageTypeTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _messageTypeTab.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _messageTypeTab.dataSource = self;
    _messageTypeTab.delegate = self;
    
    
    [self.view addSubview:_messageTypeTab];
    
    
    //constraints
    [_messageTypeTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
//
}


#pragma mark tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * MessageCellIdenfity = @"MessageCell";
    UITableViewCell * messageCell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdenfity];
    NSInteger section= indexPath.section;
    if (!messageCell) {
        messageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageCellIdenfity];
//        messageCell.backgroundColor = [UIColor whiteColor];
        UILabel * bage = [[UILabel alloc] init];
        bage.textAlignment = NSTextAlignmentCenter;
        bage.backgroundColor = [UIColor redColor];
        bage.font = [UIFont systemFontOfSize:13];
        bage.tag = 100;
        bage.textColor = [UIColor whiteColor];
        
        [messageCell.contentView addSubview:bage];
        
        messageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //comstraints
        [bage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(messageCell.contentView.mas_centerY);
            make.right.equalTo(messageCell.contentView.mas_right).with.offset(-5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
        bage.layer.masksToBounds = YES;
        bage.layer.cornerRadius = 10;
    }
    UILabel * bage = (UILabel *)[messageCell.contentView viewWithTag:100];
    
    
    if ([bageAry[section] isEqualToString:@"0"]) {
        bage.hidden = YES;
    }else{
        bage.text = bageAry[section];
    }
    messageCell.textLabel.text = titleAry[section];
//    messageCell.imageView.image = [UIImage imageNamed:imageAry[row]];
    return messageCell;
}


#pragma mark tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSMessageListViewController * messageListVC = [[NSMessageListViewController alloc] init];
    switch (row) {
        case 0:
            messageListVC.messageListType = LocalizedStr(@"prompt_commentMessage");
            break;
        case 1:
            messageListVC.messageListType = LocalizedStr(@"prompt_upvote");
            break;
        case 2:
            messageListVC.messageListType = LocalizedStr(@"prompt_collection");
            break;
        case 3:
            messageListVC.messageListType = LocalizedStr(@"prompt_systemMessage");
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:messageListVC animated:YES];
}



@end
