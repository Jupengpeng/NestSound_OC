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
#import "NSLoginViewController.h"
#import "NSPlayMusicViewController.h"
@interface NSMessageViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView * _messageTypeTab;
    NSArray * imageAry;
    NSArray * titleAry;
    NSMutableArray * bageAry;
    NSString * userID;
    NSString * url;
    UIImageView * playStatus;
    NSLoginViewController * login;
    int count;
}

@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;
@end



@implementation NSMessageViewController

- (NSPlayMusicViewController *)playSongsVC {
    
    if (!_playSongsVC) {
        
        _playSongsVC = [NSPlayMusicViewController sharedPlayMusic];
    }
    
    return _playSongsVC;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    count = 1;
    
    playStatus  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 21)];
    
    playStatus.animationDuration = 0.8;
    playStatus.animationImages = @[[UIImage imageNamed:@"2.0_play_status_1"],
                                   [UIImage imageNamed:@"2.0_play_status_2"],
                                   [UIImage imageNamed:@"2.0_play_status_3"],
                                   [UIImage imageNamed:@"2.0_play_status_4"],
                                   [UIImage imageNamed:@"2.0_play_status_5"],
                                   [UIImage imageNamed:@"2.0_play_status_6"],
                                   [UIImage imageNamed:@"2.0_play_status_7"],
                                   [UIImage imageNamed:@"2.0_play_status_8"],
                                   [UIImage imageNamed:@"2.0_play_status_9"],
                                   [UIImage imageNamed:@"2.0_play_status_10"],
                                   [UIImage imageNamed:@"2.0_play_status_11"],
                                   [UIImage imageNamed:@"2.0_play_status_12"],
                                   [UIImage imageNamed:@"2.0_play_status_13"],
                                   [UIImage imageNamed:@"2.0_play_status_14"],
                                   [UIImage imageNamed:@"2.0_play_status_15"],
                                   [UIImage imageNamed:@"2.0_play_status_16"]];
    
    [playStatus stopAnimating];
    playStatus.userInteractionEnabled = YES;
    playStatus.image = [UIImage imageNamed:@"2.0_play_status_1"];
    UIButton * btn = [[UIButton alloc] initWithFrame:playStatus.frame ];
    [playStatus addSubview:btn];
    [btn addTarget:self action:@selector(musicPaly:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:playStatus];
    
    self.navigationItem.rightBarButtonItem = item;
    [self configureUIAppearance];
}
#pragma mark -playMusic
- (void)musicPaly:(UIBarButtonItem *)palyItem {
    
    if (self.playSongsVC.player == nil) {
        [[NSToastManager manager] showtoast:@"您还没有听过什么歌曲哟"];
    } else {
        
        [self.navigationController pushViewController:self.playSongsVC animated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    count ++;
    
    [super viewWillAppear:animated];
    if (JUserID == nil) {
        login = [[NSLoginViewController alloc] init];
        UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        loginNav.navigationBar.hidden = YES;
        [self presentViewController:loginNav animated:YES completion:nil];
    }else {
        [self fetchData];
    }
    
    self.navigationController.navigationBar.hidden = NO;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!JUserID) {
        [self.tabBarController setSelectedIndex:0];
    }else{
        
        if (self.playSongsVC.player == nil) {
            
        } else {
            
            if (self.playSongsVC.player.rate != 0.0) {
                [playStatus startAnimating];
            }else{
                [playStatus stopAnimating];
            }
        }
    }
}
#pragma mark -fetchData
-(void)fetchData
{
    self.requestType = YES;
    NSDictionary * dic =@{@"uid":JUserID,@"token":LoginToken,@"timeStamp": [NSNumber  numberWithDouble:[date getTimeStamp]]};
    NSString * str = [NSTool encrytWithDic:dic];
    url = [messageURL stringByAppendingString:str];
     self.requestURL = url;
    
}


#pragma mark override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:url]) {
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
        [_messageTypeTab reloadData];
    }
}


#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    
    //imageAry;
    imageAry = @[@"2.0_message_comment.png",@"2.0_message_upvote.png",@"2.0_message_coll.png",@"2.0_message_system.png"];
    
    //titleAry
    titleAry = @[@"评论",@"赞",@"收藏",@"系统消息"];
//  @[LocalizedStr(@"prompt_commentMessage"),
//                 LocalizedStr(@"prompt_upvote"),
//                 LocalizedStr(@"prompt_collection"),
//                 LocalizedStr(@"prompt_systemMessage")
//                 ];
    
    
    //messageType table
    _messageTypeTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _messageTypeTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    _messageTypeTab.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _messageTypeTab.dataSource = self;
    _messageTypeTab.delegate = self;
    
    
    [self.view addSubview:_messageTypeTab];
    
    
    //constraints
    [_messageTypeTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
//
    WS(wSelf);
    //refresh
    [_messageTypeTab addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchData];
        }
    }];
    _messageTypeTab.showsPullToRefresh = NO;
    _messageTypeTab.showsInfiniteScrolling = NO;
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
        bage.font = [UIFont systemFontOfSize:13];
        bage.tag = 100;
        bage.textColor = [UIColor whiteColor];
        bage.backgroundColor = [UIColor redColor];
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
    
    if ([bageAry[section] isEqualToString:@"0"] || bageAry[section] == nil) {
        bage.hidden = YES;
    }else{
        bage.hidden = NO;
        bage.text = bageAry[section];
    }
    messageCell.textLabel.text = titleAry[section];
    messageCell.imageView.image = [UIImage imageNamed:imageAry[section]];
    return messageCell;
}


#pragma mark tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger section = indexPath.section;
    NSMessageListViewController * messageListVC;
    switch (section) {
        case 0:{
            messageListVC = [[NSMessageListViewController alloc] initWithMessageType:CommentMessageType];
            messageListVC.messageListType = @"评论";
//            LocalizedStr(@"prompt_commentMessage");
            break;}
        case 1:{
            messageListVC = [[NSMessageListViewController alloc] initWithMessageType:UpvoteMessageType];
            messageListVC.messageListType = @"赞";
//            LocalizedStr(@"prompt_upvote");
            break;
            }
        case 2:{
           messageListVC = [[NSMessageListViewController alloc] initWithMessageType:CollectionMessageType];
            messageListVC.messageListType = @"收藏";
//            LocalizedStr(@"prompt_collection");
            break;}
        case 3:{
            messageListVC = [[NSMessageListViewController alloc] initWithMessageType:SystemMessageType];
            messageListVC.messageListType = @"系统消息";
//            LocalizedStr(@"prompt_systemMessage");
            break;}
            
        default:
            break;
    }
    [self.navigationController pushViewController:messageListVC animated:YES];
    
}



@end
