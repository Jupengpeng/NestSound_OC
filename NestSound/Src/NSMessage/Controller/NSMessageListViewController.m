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
#import "NSLyricViewController.h"
#import "NSPlayMusicViewController.h"
#import "NSUserPageViewController.h"
@interface NSMessageListViewController ()<
UITableViewDataSource,
UITableViewDelegate,
TTTAttributedLabelDelegate,
NSCommentTableViewCellDelegate
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
        [messageList performSelector:@selector(triggerPullToRefresh) withObject:self afterDelay:0.5];
    }
}

#pragma mark -fetchData
-(void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    self.requestType = YES;
    
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{kIsLoadingMore :@(NO)};
    } else {
       currentPage++;
        self.requestParams = @{kIsLoadingMore :@(YES)};
    }
   
    NSDictionary * dic = @{@"uid":JUserID,@"page":[NSNumber numberWithInt: currentPage],@"token":LoginToken};
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
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:upvoteUrl]) {
                NSUpvoteMessageListModel * upvoteMessage = (NSUpvoteMessageListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    messageArr = [NSMutableArray arrayWithArray:upvoteMessage.upvoteMessageList];
                }else{
                    if (upvoteMessage.upvoteMessageList.count == 0) {
                        messageList.showsInfiniteScrolling = NO;
                        
                    }else{
                        [messageArr addObjectsFromArray:upvoteMessage.upvoteMessageList];
                    }
                }
                
                emptyImage.image = [UIImage imageNamed:@"2.0_noUpvote_bk"];
            }else if ([operation.urlTag isEqualToString:collectUrl]){
                NSUpvoteMessageListModel * collecMessage = (NSUpvoteMessageListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    messageArr = [NSMutableArray arrayWithArray:collecMessage.upvoteMessageList];
                    
                    
                }else{
                    if (collecMessage.upvoteMessageList.count == 0) {
                        messageList.showsInfiniteScrolling = NO;
                        
                    }else{
                        [messageArr addObjectsFromArray:collecMessage.upvoteMessageList];
                    }
                    
                }
                emptyImage.image = [UIImage imageNamed:@"2.0_nocollection_bk"];
                
            }else if ([operation.urlTag isEqualToString:commentUrl]){
                NSCommentListModel * commentMessage = (NSCommentListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    messageArr = [NSMutableArray arrayWithArray:commentMessage.commentList];
                }else{
                    if (commentMessage.commentList.count == 0) {
                        
                        messageList.showsInfiniteScrolling = NO;
                    }else{
                        [messageArr addObjectsFromArray:commentMessage.commentList];
                    }
                    
                }
                emptyImage.image = [UIImage imageNamed:@"2.0_noComment_bk"];
                
            }else if ([operation.urlTag isEqualToString:systemUrl]){
                NSSystemMessageListModel * systemMessage = (NSSystemMessageListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    messageArr = [NSMutableArray arrayWithArray:systemMessage.systemMessageList];
                }else{
                    if (systemMessage.systemMessageList.count == 0) {
                        messageList.showsInfiniteScrolling = NO;
                        
                    }else{
                        [messageArr addObjectsFromArray:systemMessage.systemMessageList];
                    }
                    
                }
                emptyImage.image = [UIImage imageNamed:@"2.0_noMessageBk"];
            }
            
            if (messageArr.count == 0) {
                emptyImage.hidden = NO;
            } else {
                emptyImage.hidden = YES;
            }
            messageList.showsPullToRefresh = YES;
            [messageList reloadData];
            if (!operation.isLoadingMore) {
                [messageList.pullToRefreshView stopAnimating];
                messageList.showsInfiniteScrolling = YES;
            }else{
                [messageList.infiniteScrollingView stopAnimating];
            }
            
        }else{
            
        }
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
    messageList.alwaysBounceVertical = YES;
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
    messageList.showsPullToRefresh = NO;
  messageList.showsInfiniteScrolling = YES;
    
    emptyImage = [[UIImageView alloc] init];
    [self.view addSubview:emptyImage];
    emptyImage.hidden = YES;
    //constraints
    [emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
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
        return 140;
    }else if (messageType == CollectionMessageType){
        return 140;
    }else if (messageType == SystemMessageType){
        SystemMessageModel * sys = messageArr[indexPath.row];
        if (sys.type == 1) {
            return 80;
        }else{
            return 175;
        }
    }else if (messageType == CommentMessageType){
        
        NSCommentTableViewCell *cell = (NSCommentTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.commentLabelMaxY + 80;
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.isUpvote = YES;
        
        cell.upvoteMessage = messageArr[row];
        return cell;
        
    }else if (messageType == CollectionMessageType){
        NSUpvoteMessageCell * cell = (NSUpvoteMessageCell *)[tableView dequeueReusableCellWithIdentifier:collectionCellID];
        if (!cell) {
            cell = [[NSUpvoteMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collectionCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.isUpvote = NO;
        cell.upvoteMessage = messageArr[row];
        return cell;
        
        
    }else if (messageType == SystemMessageType){
        NSSystemMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:systemCellID];
        SystemMessageModel * sys = messageArr[row];
        if (!cell) {
            cell = [[NSSystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            commentCell.delegate = self;
            
            [commentCell messagePage];
        }
        commentCell.commentModel = messageArr[indexPath.row];
        commentCell.commentLabel.delegate = self;
        return commentCell;
    }
    return nil;
}



#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpvoteMessage * upvoteMessage = messageArr[indexPath.row];
    if (messageType == UpvoteMessageType || messageType == CollectionMessageType) {
        
        if (upvoteMessage.type == 2) {
            NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:upvoteMessage.workId];
            [self.navigationController pushViewController:lyricVC animated:YES];
        }else{
            NSPlayMusicViewController * playVC = [[NSPlayMusicViewController alloc] init];
            playVC.itemUid = upvoteMessage.workId;
            playVC.from = @"tuijian";
            playVC.geDanID = 0;
            [self.navigationController pushViewController:playVC animated:YES];
        }
    }else if (messageType == SystemMessageType){
        SystemMessageModel * sys = messageArr[indexPath.row];
        if (sys.type == 2) {
            NSH5ViewController * eventDetail = [[NSH5ViewController alloc] init];
            eventDetail.h5Url = sys.detailUrl;
            [self.navigationController pushViewController:eventDetail animated:YES];
        }
    }else if (messageType == CommentMessageType){
        NSCommentModel *comment = messageArr[indexPath.row];
        if (comment.type == 1) {
            
            NSPlayMusicViewController *playMusic = [NSPlayMusicViewController sharedPlayMusic];
            playMusic.itemUid = comment.itemID;
            playMusic.from = @"";
            [self.navigationController pushViewController:playMusic animated:YES];
        } else {
            
            NSLyricViewController *lyric = [[NSLyricViewController alloc] initWithItemId:comment.itemID];
            [self.navigationController pushViewController:lyric animated:YES];
        }
        
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( messageList.contentOffset.y > messageList.contentSize.height) {
        [self fetchDataWithIsLoadingMore:YES];
        messageList.showsInfiniteScrolling = YES;
    }
}


- (void)commentTableViewCell:(NSCommentTableViewCell *)cell {
    
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.userID]];
    
    pageVC.who = Other;
    
    [self.navigationController pushViewController:pageVC animated:YES];
    
}


- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSCommentTableViewCell * cell = (NSCommentTableViewCell *)label.superview.superview;
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.targetUserID]];
    pageVC.who = Other;
    [self.navigationController pushViewController:pageVC animated:YES];
    
    
}

@end
