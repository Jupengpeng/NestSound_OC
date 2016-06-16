//
//  NSMessageListViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMessageListViewController.h"
#import "NSUpvoteMessageCell.h"
#import "NSCommentMessageCell.h"
#import "NSSystemMessageCell.h"
#import "NSSystemMessageListModel.h"
#import "NSCommentListModel.h"
#import "NSUpvoteMessageListModel.h"
#import "NSH5ViewController.h"
#import "NSCommentTableViewCell.h"
@interface NSMessageListViewController ()<
UITableViewDataSource,
UITableViewDelegate
>
{
    UITableView * messageList;
    NSMutableArray * messageArr;
    MessageType messageType;
    int currentPage;
    NSString * upvoteUrl;
    NSString * collectUrl;
    NSString * commentUrl;
    NSString * systemUrl;
    UIImageView * emptyImage;
}

@end

static NSString * const upvoteCellID = @"upvoteCellID";
static NSString * const collectionCellID = @"collectionCellID";
static NSString * const comment1CellID = @"comment1CellID";
static NSString * const comment2CellID = @"comment2CellID";
static NSString * const systemCellID = @"SystemCellID";



@implementation NSMessageListViewController


-(instancetype)initWithMessageType:(MessageType)messageType_
{
    if (self = [super init]) {
        messageType = messageType_;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchMessageData];
    
}

-(void)fetchMessageData
{
    if (messageArr.count == 0) {
        [messageList setContentOffset:CGPointMake(0, -60) animated:YES];
        [messageList performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
    }
}

#pragma mark -fetchData
-(void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    self.requestType = YES;
    
    
    if (!isLoadingMore) {
        
        currentPage = 1;
    } else {
        
        ++ currentPage;
    }
    self.requestParams = @{kIsLoadingMore:@(isLoadingMore)};
   
    NSDictionary * dic = @{@"uid":JUserID,@"page":[NSString stringWithFormat:@"%d",currentPage],@"token":LoginToken};
    NSString * str = [NSTool encrytWithDic:dic];
    if (messageType == UpvoteMessageType) {
        upvoteUrl = [upvoteMessageURL stringByAppendingString:str];
        self.requestURL = upvoteUrl;
        }else if (messageType == CollectionMessageType){
            collectUrl = [collectMessageURL stringByAppendingString:str];
            self.requestURL = collectUrl;
        }else if (messageType == SystemMessageType){
            systemUrl = [systemMessageURL stringByAppendingString:str];
            self.requestURL = systemUrl;
        }else if (messageType == CommentMessageType){
            commentUrl =[commentMessageURL stringByAppendingString:str];
            self.requestURL = commentUrl;
        }
}

#pragma mark -override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        
        
        if ([operation.urlTag isEqualToString:upvoteUrl]) {
            NSUpvoteMessageListModel * upvoteMessage = (NSUpvoteMessageListModel *)parserObject;
            if (!operation.isLoadingMore) {
                messageArr = [NSMutableArray arrayWithArray:upvoteMessage.upvoteMessageList];
            }else{
                if (upvoteMessage.upvoteMessageList.count == 0) {
                    
                }else{
                [messageArr addObjectsFromArray:upvoteMessage.upvoteMessageList];
            
                }
            }
        }else if ([operation.urlTag isEqualToString:collectUrl]){
            NSUpvoteMessageListModel * collecMessage = (NSUpvoteMessageListModel *)parserObject;
            if (!operation.isLoadingMore) {
                messageArr = [NSMutableArray arrayWithArray:collecMessage.upvoteMessageList];
            }else{
                if (collecMessage.upvoteMessageList.count == 0) {
                    
                }else{
                    [messageArr addObjectsFromArray:collecMessage.upvoteMessageList];
                }
                
            }
        }else if ([operation.urlTag isEqualToString:commentUrl]){
            NSCommentListModel * commentMessage = (NSCommentListModel *)parserObject;
            if (!operation.isLoadingMore) {
                messageArr = [NSMutableArray arrayWithArray:commentMessage.commentList];
            }else{
                if (commentMessage.commentList.count == 0) {
                    
                }else{
                    [messageArr addObjectsFromArray:commentMessage.commentList];
                }
                
            }
        }else if ([operation.urlTag isEqualToString:systemUrl]){
            NSSystemMessageListModel * systemMessage = (NSSystemMessageListModel *)parserObject;
            if (!operation.isLoadingMore) {
                messageArr = [NSMutableArray arrayWithArray:systemMessage.systemMessageList];
            }else{
                if (systemMessage.systemMessageList.count == 0) {
                    
                }else{
                    [messageArr addObjectsFromArray:systemMessage.systemMessageList];
                }
                
            }
        }
        
        [messageList reloadData];
        if (!operation.isLoadingMore) {
            [messageList.pullToRefreshView stopAnimating];
        }else{
            [messageList.infiniteScrollingView stopAnimating];
        }
        
    }else{
    }
    
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    //nav
    self.title = self.messageListType;
    
    //messageList tableview
    messageList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    messageList.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    messageList.delegate = self;
    messageList.dataSource = self;
    messageList.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:messageList];
    
    [messageList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    //refresh
    WS(wSelf);
    [messageList addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
        
            [wSelf fetchDataWithIsLoadingMore:NO];
        }
        
    }];
   
    //loadingMore
    [messageList addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchDataWithIsLoadingMore:YES];
        }
    }];
    // hide infiniteView
  messageList.showsInfiniteScrolling = NO;
    NSLog(@"thise%f",messageList.contentOffset.y);
}


#pragma mark tableview dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageArr.count;
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
    if (messageType == UpvoteMessageType) {
        return 80;
    }else if (messageType == CollectionMessageType){
        return 80;
    }else if (messageType == SystemMessageType){
        SystemMessageModel * sys = messageArr[indexPath.row];
        if (sys.type == 1) {
            return 80;
        }else{
            return 175;
        }
    }else if (messageType == CommentMessageType){
            return 160;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    
    if (messageType == UpvoteMessageType) {
        NSUpvoteMessageCell * cell = (NSUpvoteMessageCell *)[tableView dequeueReusableCellWithIdentifier:upvoteCellID];
        if (!cell) {
            cell = [[NSUpvoteMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:upvoteCellID];
        }
        cell.isUpvote = YES;
        cell.upvoteMessage = messageArr[row];
        return cell;
        
    }else if (messageType == CollectionMessageType){
        NSUpvoteMessageCell * cell = (NSUpvoteMessageCell *)[tableView dequeueReusableCellWithIdentifier:upvoteCellID];
        if (!cell) {
            cell = [[NSUpvoteMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:upvoteCellID];
        }
        cell.isUpvote = NO;
        cell.upvoteMessage = messageArr[row];
        return cell;
        
        
    }else if (messageType == SystemMessageType){
        NSSystemMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:systemCellID];
         SystemMessageModel * sys = messageArr[row];
        if (!cell) {
            cell = [[NSSystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemCellID];
        }

        if (sys.type == 1 ) {
            cell.isTu = NO;
        }else{
            cell.isTu = YES;
        }
        cell.systemMessageModel = sys;
        return cell;
        
    }else if (messageType == CommentMessageType){
        NSCommentTableViewCell * commentCell = [tableView dequeueReusableCellWithIdentifier:comment1CellID];
        if (!commentCell) {
            commentCell = [[NSCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:comment1CellID];
        }
        commentCell.commentModel = messageArr[indexPath.row];
        return commentCell;
    }
    return nil;
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (messageType == UpvoteMessageType) {
       
    }else if (messageType == CollectionMessageType){
        
    }else if (messageType == SystemMessageType){
        SystemMessageModel * sys = messageArr[indexPath.row];
        if (sys.type == 2) {
            NSH5ViewController * eventDetail = [[NSH5ViewController alloc] init];
            eventDetail.h5Url = sys.detailUrl;
            [self.navigationController pushViewController:eventDetail animated:YES];
        }
    }else if (messageType == CommentMessageType){
        
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"this %f",messageList.contentOffset.y);
}

@end
