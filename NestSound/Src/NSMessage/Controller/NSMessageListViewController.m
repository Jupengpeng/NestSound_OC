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
#import "NSPreserveMessageTableViewCell.h"
#import "NSSystemMessageListModel.h"
#import "NSCommentListModel.h"
#import "NSUpvoteMessageListModel.h"
#import "NSPreserveMessageListModel.h"
#import "NSH5ViewController.h"
#import "NSCommentTableViewCell.h"
#import "NSLyricViewController.h"
#import "NSPlayMusicViewController.h"
#import "NSUserPageViewController.h"
#import "NSPreserveDetailViewController.h"
@interface NSMessageListViewController ()<
UITableViewDataSource,
UITableViewDelegate,
TTTAttributedLabelDelegate,
NSCommentTableViewCellDelegate,
UITextFieldDelegate
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
    NSString * preserveUrl;
    UIImageView * emptyImage;
    UITextField *inputField;
    UIView *maskView;
    NSCommentModel *commentModel;
    UIView *bottomView;
}

@end

static NSString * const upvoteCellID = @"upvoteCellID";
static NSString * const collectionCellID = @"collectionCellID";
static NSString * const comment1CellID = @"comment1CellID";
static NSString * const comment2CellID = @"comment2CellID";
static NSString * const systemCellID = @"SystemCellID";
static NSString * const preserveCellID = @"preserveCellID";


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
        } else if (messageType == PreserveMessageType) {
            preserveUrl = [preserveMessageUrl stringByAppendingString:str];
            self.requestURL = preserveUrl;
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
                    emptyImage.image = [UIImage imageNamed:@"2.0_noUpvote_bk"];
                }else{
                    if (upvoteMessage.upvoteMessageList.count == 0) {
                        messageList.showsInfiniteScrolling = NO;
                        
                    }else{
                        [messageArr addObjectsFromArray:upvoteMessage.upvoteMessageList];
                    }
                }
                
            }else if ([operation.urlTag isEqualToString:collectUrl]){
                NSUpvoteMessageListModel * collecMessage = (NSUpvoteMessageListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    messageArr = [NSMutableArray arrayWithArray:collecMessage.upvoteMessageList];
                    
                    emptyImage.image = [UIImage imageNamed:@"2.0_nocollection_bk"];
                }else{
                    if (collecMessage.upvoteMessageList.count == 0) {
                        messageList.showsInfiniteScrolling = NO;
                        
                    }else{
                        [messageArr addObjectsFromArray:collecMessage.upvoteMessageList];
                    }
                    
                }
                
                
            }else if ([operation.urlTag isEqualToString:commentUrl]){
                NSCommentListModel * commentMessage = (NSCommentListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    messageArr = [NSMutableArray arrayWithArray:commentMessage.commentList];
                    emptyImage.image = [UIImage imageNamed:@"2.0_noComment_bk"];
                }else{
                    if (commentMessage.commentList.count == 0) {
                        
                        messageList.showsInfiniteScrolling = NO;
                    }else{
                        [messageArr addObjectsFromArray:commentMessage.commentList];
                    }
                    
                }
                
                
            }else if ([operation.urlTag isEqualToString:systemUrl]){
                NSPreserveMessageListModel * preserveMessage = (NSPreserveMessageListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    messageArr = [NSMutableArray arrayWithArray:preserveMessage.preserveMessageList];
                    emptyImage.image = [UIImage imageNamed:@"2.0_noMessageBk"];
                }else{
                    if (preserveMessage.preserveMessageList.count == 0) {
                        messageList.showsInfiniteScrolling = NO;
                        
                    }else{
                        [messageArr addObjectsFromArray:preserveMessage.preserveMessageList];
                    }
                    
                }
                
            } else if ([operation.urlTag isEqualToString:preserveUrl]) {
                NSPreserveMessageListModel * preserveMessage = (NSPreserveMessageListModel *)parserObject;
                if (!operation.isLoadingMore) {
                    messageArr = [NSMutableArray arrayWithArray:preserveMessage.preserveMessageList];
                    emptyImage.image = [UIImage imageNamed:@"2.0_noMessageBk"];
                }else{
                    if (preserveMessage.preserveMessageList.count == 0) {
                        messageList.showsInfiniteScrolling = NO;
                        
                    }else{
                        [messageArr addObjectsFromArray:preserveMessage.preserveMessageList];
                    }
                    
                }
            }
            
            messageList.showsPullToRefresh = YES;
            [messageList reloadData];
            if (!operation.isLoadingMore) {
                [messageList.pullToRefreshView stopAnimating];
                messageList.showsInfiniteScrolling = YES;
            }else{
                [messageList.infiniteScrollingView stopAnimating];
            }
            if (messageArr.count == 0) {
                emptyImage.hidden = NO;
            } else {
                emptyImage.hidden = YES;
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
    emptyImage.hidden = YES;
    [self.view addSubview:emptyImage];
    //constraints
    [emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    maskView.backgroundColor = [UIColor lightGrayColor];
    
    maskView.alpha = 0.5;
    
    maskView.hidden = YES;
    
    [self.view addSubview:maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap:)];
    
    [maskView addGestureRecognizer:tap];
    
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 44)];
    
    bottomView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self.view addSubview:bottomView];
    
    inputField = [[UITextField alloc] init];
    
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    
    inputField.placeholder = @"来~说点什么吧";
    
    inputField.delegate = self;
    
    inputField.returnKeyType = UIReturnKeySend;
    
    [bottomView addSubview:inputField];

    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bottomView.mas_left).offset(15);
        
        make.top.equalTo(bottomView.mas_top).offset(5);
        
        make.bottom.equalTo(bottomView.mas_bottom).offset(-5);
        
        make.right.equalTo(bottomView.mas_right).offset(-15);
        
    }];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
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
    }else if (messageType == SystemMessageType || messageType == PreserveMessageType){
        NSPreserveMessage *model = messageArr[indexPath.section];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        
        CGFloat height = [model.content boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:dic context:nil].size.height;
        return 65 + height;
//
    }else if (messageType == CommentMessageType){
        
        NSCommentTableViewCell *cell = (NSCommentTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.commentLabelMaxY + 80;
    }
    return 0;
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
        cell.collectionMessage = messageArr[row];
        return cell;
        
    }else if (messageType == SystemMessageType){
        NSPreserveMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:systemCellID];
//        SystemMessageModel * sys = messageArr[row];
        if (!cell) {
            cell = [[NSPreserveMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.preserveModel = messageArr[indexPath.row];
//        if (sys.type == 1 ) {
//            cell.isTu = NO;
//        }else{
//            cell.isTu = YES;
//        }
//        cell.systemMessageModel = sys;
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
    } else if (messageType == PreserveMessageType) {
        NSPreserveMessageTableViewCell *preserveCell = [tableView dequeueReusableCellWithIdentifier:preserveCellID];
        if (!preserveCell) {
            preserveCell = [[NSPreserveMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:preserveCellID];
            
        }
        preserveCell.preserveModel = messageArr[indexPath.row];
        return preserveCell;
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
//        SystemMessageModel * sys = messageArr[indexPath.row];
//        if (sys.type == 2) {
//            NSH5ViewController * eventDetail = [[NSH5ViewController alloc] init];
//            eventDetail.h5Url = sys.detailUrl;
//            [self.navigationController pushViewController:eventDetail animated:YES];
//        }
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
        
    } else if (messageType == PreserveMessageType) {
        NSPreserveMessage *model = messageArr[indexPath.row];
        NSPreserveDetailViewController *preserveDetailVC = [[NSPreserveDetailViewController alloc] initWithPreserveID:model.orderNo sortID:0];
        [self.navigationController pushViewController:preserveDetailVC animated:YES];
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( messageList.contentOffset.y > messageList.contentSize.height) {
        [self fetchDataWithIsLoadingMore:YES];
        messageList.showsInfiniteScrolling = YES;
    }
}
#pragma mark - NSCommentTableViewCellDelegate
//进入他人主页
- (void)commentTableViewCell:(NSCommentTableViewCell *)cell {
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.userID]];
    
    pageVC.who = Other;
    
    [self.navigationController pushViewController:pageVC animated:YES];
    
}
//回复评论
- (void)replyCommentTableViewCell:(NSCommentTableViewCell *)cell {
    
    maskView.hidden = NO;
    
    [inputField becomeFirstResponder];
    
    inputField.tag = 1;
    
    NSIndexPath *index = [messageList indexPathForCell:cell];
    
    commentModel = messageArr[index.row];
    
    inputField.placeholder = [NSString stringWithFormat:@"回复: %@",commentModel.nickName];
}
- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSCommentTableViewCell * cell = (NSCommentTableViewCell *)label.superview.superview;
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.targetUserID]];
    pageVC.who = Other;
    [self.navigationController pushViewController:pageVC animated:YES];
    
    
}
#pragma mark postComment
-(void)postCommentWithComment:(NSString *)comment
{
    self.requestType = NO;
    self.requestParams = @{@"comment":comment,@"uid":JUserID,@"comment_type":[NSNumber numberWithInt:2],@"itemid":[NSNumber numberWithLong:commentModel.itemID],@"type":[NSNumber numberWithInt:commentModel.type],@"target_uid":[NSNumber numberWithLong:commentModel.userID],@"token":LoginToken};
    
    //    self.commentExecuteBlock();
    
    self.requestURL = postCommentURL;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //    inputField.placeholder = nil;
    
    [textField resignFirstResponder];
    
    maskView.hidden = YES;
    
    [self postCommentWithComment:textField.text];
    
    inputField.tag = 2;
    
    textField.text = nil;
    
    return YES;
}
//回复评论

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        bottomView.y = keyBoardEndY - bottomView.height - 64;
//        inputField.y = keyBoardEndY - 108;
        maskView.hidden = NO;
    }];
    
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        bottomView.y = keyBoardEndY - 64;
//        inputField.y = keyBoardEndY - 108;
    }];
    
}
- (void)maskViewTap:(UIGestureRecognizer *)tap {
    
    inputField.tag = 2;
    
    maskView.hidden = YES;
    
    [inputField resignFirstResponder];
    
}
@end
