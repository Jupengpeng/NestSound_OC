//
//  NSCommentViewController.m
//  NestSound
//
//  Created by Apple on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//
static NSString * const kDefaultTip = @"来~说点什么";

#import "NSCommentViewController.h"
#import "NSCommentTableViewCell.h"
#import "NSUserPageViewController.h"
#import "NSCommentListModel.h"
@interface NSCommentViewController () <UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate, UIScrollViewDelegate, UITextFieldDelegate, NSCommentTableViewCellDelegate> {
    
    UITableView *commentTableView;
    NSMutableArray * commentAry;
    UIView *bottomView;
    
    UIView *maskView;
    
    /**
     *  评论内容
     */
    NSString *_commentContent;
    UITextField *inputField;
    long itemID ;
    int currentPage;
    int type;
    long targetUserId;
    NSString * commentUrl;
    
    NSString *_musicSayComUrl;
    //无数据提示
    UIImageView *_emptyImage;

    NSString *_coWorkCommentUrl;
    
}

@end

@implementation NSCommentViewController

-(instancetype)initWithItemId:(long)itemid andType:(int)type_
{
    if (self = [super init]) {
        itemID = itemid;
        type = type_;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = [NSString stringWithFormat:@"%@的评论",self.musicName];
    
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 108) style:UITableViewStylePlain];
    
//    commentTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    commentTableView.delegate = self;
    
    commentTableView.dataSource = self;
    
    commentTableView.backgroundColor = KBackgroundColor;
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [commentTableView setTableFooterView:noLineView];
    
    [self.view addSubview:commentTableView];
    WS(wSelf);
    //refresh
    [commentTableView addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchCommentWithIsLoadingMore:NO];
        }
    }];
    
    //loadingMore
    [commentTableView addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchCommentWithIsLoadingMore:YES];
        }
    }];
    
    _emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    //    emptyThreeImage.hidden = YES;
    
    _emptyImage.centerX = ScreenWidth/2;
    
    _emptyImage.centerY = ScreenHeight/2.0 - 64 ;
//    commentTableView.showsInfiniteScrolling = NO;
    
    
    [self bottomView];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (commentAry.count == 0) {
        [commentTableView setContentOffset:CGPointMake(0, -60) animated:YES];
        [commentTableView performSelector:@selector(triggerPullToRefresh) withObject:self afterDelay:0.2];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [inputField resignFirstResponder];
    [bottomView removeFromSuperview];
}
#pragma mark -fetchCommentData

-(void)fetchCommentWithIsLoadingMore:(BOOL)isLoadingMore
{
    if (!self.isCoWork) {
        self.requestType = YES;
        if (!isLoadingMore) {
            currentPage = 1;
            self.requestParams = @{kIsLoadingMore:@(NO)};
        }else{
            ++currentPage;
            self.requestParams = @{kIsLoadingMore:@(YES)};
        }
        NSString * str = nil;
        switch (type) {
                
                /**
                 *  乐说
                 */
            case 3:
            {
                NSDictionary * dic = @{@"itemid":[NSString stringWithFormat:@"%ld",itemID],@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:type],@"token":LoginToken};
                str = [NSTool encrytWithDic:dic];
                break;
            }
            default:
            {
                NSDictionary * dic = @{@"itemid":[NSString stringWithFormat:@"%ld",itemID],@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:type],@"token":LoginToken};
                str = [NSTool encrytWithDic:dic];
                
            }
                break;
        }
        commentUrl = [commentURL stringByAppendingString:str];
        self.requestURL = commentUrl;
    }else{
        
        self.requestType = YES;
        if (!isLoadingMore) {
            currentPage = 1;
            self.requestParams = @{kIsLoadingMore:@(NO)};
        }else{
            ++currentPage;
            self.requestParams = @{kIsLoadingMore:@(YES)};
        }
        NSDictionary * dic = @{@"itemid":[NSString stringWithFormat:@"%ld",itemID],@"page":[NSNumber numberWithInt:currentPage],@"type":[NSNumber numberWithInt:type],@"token":LoginToken};
        NSString *str = [NSTool encrytWithDic:dic];
        _coWorkCommentUrl = [coWorkCommentListUrl stringByAppendingString:str];
        self.requestURL = _coWorkCommentUrl;
        
    }
    
    
}

#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        [commentTableView.pullToRefreshView stopAnimating];
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:commentUrl]||
                [operation.urlTag isEqualToString:_coWorkCommentUrl]) {
                NSCommentListModel * commentList = (NSCommentListModel *)parserObject;
                [commentTableView.pullToRefreshView stopAnimating];
                [commentTableView.infiniteScrollingView stopAnimating];
                if (!operation.isLoadingMore) {
                    commentAry = [NSMutableArray arrayWithArray:commentList.commentList];
                    
                }else{
                    [commentAry addObjectsFromArray:commentList.commentList];
                    
                }
                
            }else if ([operation.urlTag isEqualToString:postCommentURL]||
                      [operation.urlTag isEqualToString:coWorkCommentUrl]){
                [[NSToastManager manager] showtoast:@"发表评论成功"];
                [self fetchCommentWithIsLoadingMore:NO];
            }else if ([operation.urlTag isEqualToString:deleteCommentURL]||
                      [operation.urlTag isEqualToString:coWorkDeleteUrl]){
                [[NSToastManager manager] showtoast:@"删除评论成功"];
                [self fetchCommentWithIsLoadingMore:NO];
            }else if([operation.urlTag isEqualToString:_musicSayComUrl]){
                /**
                 *  乐说部分
                 */
                NSCommentListModel * commentList = (NSCommentListModel *)parserObject;
                [commentTableView.pullToRefreshView stopAnimating];
                [commentTableView.infiniteScrollingView stopAnimating];
                if (!operation.isLoadingMore) {
                    commentAry = [NSMutableArray arrayWithArray:commentList.commentList];
                    
                }else{
                    [commentAry addObjectsFromArray:commentList.commentList];
                }
            }
            if (!commentAry.count) {

                [commentTableView addSubview:_emptyImage];
            }
            else{
                if (_emptyImage.superview) {
                    [_emptyImage removeFromSuperview];
                }
                [commentTableView reloadData];

            }
        }
    }
}

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
        
//        maskView.hidden = NO;
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
        
        bottomView.y = keyBoardEndY - bottomView.height - 64;
        
    }];
    
}




- (void)bottomView {
    
//    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//    
//    maskView.backgroundColor = [UIColor lightGrayColor];
//    
//    maskView.alpha = 0.5;
//    
//    maskView.hidden = YES;
//    
//    [self.navigationController.view addSubview:maskView];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    
//    [maskView addGestureRecognizer:tap];
    
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 108, ScreenWidth, 44)];
    
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
}

- (void)tap:(UIGestureRecognizer *)tap {

    inputField.tag = 2;
    
    maskView.hidden = YES;
    
    [inputField resignFirstResponder];

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (_commentContent) {
//        textField.text = _commentContent;
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    _commentContent = textField.text;
//    inputField.text = nil;
//
//    textField.placeholder = kDefaultTip;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//    inputField.placeholder = nil;
    if (!textField.text.length) {
        [[NSToastManager manager] showtoast:@"说点什么吧"];
    } else {
        [textField resignFirstResponder];
        
        maskView.hidden = YES;
        
        if (inputField.tag == 1) {
            
            [self postCommentWithComment:textField.text andUser:nil andType:2 andTargetUID:targetUserId];
            
        } else {
            
            [self postCommentWithComment:textField.text andUser:nil andType:1 andTargetUID:0];
            
        }
    }
    
    inputField.tag = 2;
    
    textField.text = nil;
    
    return YES;
}


#pragma mark postComment
-(void)postCommentWithComment:(NSString *)comment andUser:(NSString *)user andType:(int)commentType andTargetUID:(long)targetUID
{
    self.requestType = NO;
    
    if (type == 3) {
        self.requestParams = @{@"comment":comment,@"uid":JUserID,@"comment_type":[NSNumber numberWithInt:commentType],@"itemid":[NSNumber numberWithLong:itemID],@"type":[NSNumber numberWithInt:type],@"target_uid":[NSNumber numberWithLong:targetUID],@"token":LoginToken};
        
        self.commentExecuteBlock();
    }else{
        self.requestParams = @{@"comment":comment,@"uid":JUserID,@"comment_type":[NSNumber numberWithInt:commentType],@"itemid":[NSNumber numberWithLong:itemID],@"type":[NSNumber numberWithInt:type],@"target_uid":[NSNumber numberWithLong:targetUID],@"token":LoginToken};
        
    }
    
    if (self.isCoWork) {
        self.requestURL = coWorkCommentUrl;
    }else{
        self.requestURL = postCommentURL;
    }

}


#pragma mark deleteComment
-(void)deleteCommentWithComentID:(long)commentID
{

    self.requestType = NO;


    
    if (type == 3) {
        self.requestParams = @{@"id":[NSNumber numberWithLong:commentID],@"itemid":[NSNumber numberWithLong:itemID],@"type":[NSNumber numberWithInt:type],@"token":LoginToken};
        self.commentExecuteBlock();

    }else{
        self.requestParams = @{@"id":[NSNumber numberWithLong:commentID],@"itemid":[NSNumber numberWithLong:itemID],@"type":[NSNumber numberWithInt:type],@"token":LoginToken};
        
    }
    
    if (self.isCoWork) {
        self.requestURL = coWorkDeleteUrl;

    }else{
        self.requestURL = deleteCommentURL;

    }


}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return commentAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"commentCell";
    
    NSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.delegate = self;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentModel = commentAry[indexPath.row];
    cell.commentLabel.delegate = self;
    

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSCommentTableViewCell *cell = (NSCommentTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.commentLabelMaxY;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 10.0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    

    targetUserId = cell.commentModel.userID;
//    maskView.hidden = NO;
    
    [inputField becomeFirstResponder];
    
    inputField.tag = 1;
    
    inputField.placeholder = [NSString stringWithFormat:@"回复: %@",cell.authorNameLabel.text];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.commentModel.userID == [JUserID longLongValue]) {
        
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCommentWithComentID:cell.commentModel.commentID];
        [commentAry removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    
    NSCommentTableViewCell * cell = (NSCommentTableViewCell *)label.superview.superview;
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.targetUserID]];
    pageVC.who = Other;
    [self.navigationController pushViewController:pageVC animated:YES];
    
}


- (void)commentTableViewCell:(NSCommentTableViewCell *)cell {
    
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.userID]];
    
    pageVC.who = Other;
    
    [self.navigationController pushViewController:pageVC animated:YES];
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
