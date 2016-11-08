//
//  NSCooperationMessageViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationMessageViewController.h"
#import "NSCooperationMessageTableViewCell.h"
#import "NSUserPageViewController.h"
#import "NSCommentListModel.h"
@interface NSCooperationMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TTTAttributedLabelDelegate>
//NSCooperationMessageTableViewCellDelegate
{
    UITableView * _messageTableView;
    UIImageView * _emptyImage;
    UIView *maskView;
    UIView *bottomView;
    NSTextField *inputField;
    int currentPage;
    int messageType;
    long targetUid;
}
@property (nonatomic, strong) NSMutableArray *messageArr;
@end

@implementation NSCooperationMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    messageType = 1;
    [self setupCooperationMessageView];
    [self fetchCooperationMessageListWithIsLoadingMore:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [inputField resignFirstResponder];
    [bottomView removeFromSuperview];
}
#pragma mark - Network Requests and Data Handling
- (void)fetchCooperationMessageListWithIsLoadingMore:(BOOL)isLoadingMore {
    self.requestType = NO;
    if (!isLoadingMore) {
        currentPage = 1;
    }else{
        ++currentPage;
    }
    self.requestParams = @{@"page":@(currentPage),@"did":@(self.cooperationId),kIsLoadingMore:@(isLoadingMore),@"token":LoginToken};
    self.requestURL = cooperationMessageListUrl;
    
}
- (void)publicCooperationMessageWithMessage:(NSString *)message andTargetUID:(long)targetUID{
    self.requestType = NO;
    if (!messageType) {
        self.requestParams = @{@"comment":message,@"uid":JUserID,@"comment_type":@(2),@"itemid":@(self.cooperationId),@"type":@(3),@"token":LoginToken,@"target_uid":@(targetUID)};
    } else {
        self.requestParams = @{@"comment":message,@"uid":JUserID,@"comment_type":@(1),@"itemid":@(self.cooperationId),@"type":@(3),@"token":LoginToken};
    }
    
    self.requestURL = publicCooperationMessageUrl;
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:cooperationMessageListUrl]) {
            NSCommentListModel * commentList = (NSCommentListModel *)parserObject;
            
            if (!operation.isLoadingMore) {
                [_messageTableView.pullToRefreshView stopAnimating];
                self.messageArr = [NSMutableArray arrayWithArray:commentList.commentList];
                
            }else{
                [_messageTableView.infiniteScrollingView stopAnimating];
                [self.messageArr addObjectsFromArray:commentList.commentList];
                
            }
            [_messageTableView reloadData];
        } else if ([operation.urlTag isEqualToString:publicCooperationMessageUrl]) {
            [self fetchCooperationMessageListWithIsLoadingMore:NO];
        }
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"commentCell";
    
    NSCooperationMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSCooperationMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
//        cell.delegate = self;
    }
    cell.commentModel = self.messageArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentLabel.delegate = self;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSCommentModel *model = self.messageArr[indexPath.row];
    [inputField becomeFirstResponder];
    messageType = 0;
    targetUid = model.userID;
    inputField.placeholder = [NSString stringWithFormat:@"回复: %@",model.nickName];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSCooperationMessageTableViewCell *cell = (NSCooperationMessageTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.commentLabelMaxY;
}

#pragma mark - setupUI
- (void)setupCooperationMessageView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"留言";
    
    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 108) style:UITableViewStylePlain];
    
    //    commentTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _messageTableView.delegate = self;
    
    _messageTableView.dataSource = self;
    
    _messageTableView.backgroundColor = KBackgroundColor;
    
    [self.view addSubview:_messageTableView];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _messageTableView.tableFooterView = noLineView;
    WS(wSelf);
    //refresh
    [_messageTableView addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchCooperationMessageListWithIsLoadingMore:NO];
        }
    }];
    
    //loadingMore
    [_messageTableView addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchCooperationMessageListWithIsLoadingMore:YES];
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
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap:)];
//    
//    [maskView addGestureRecognizer:tap];
    
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 108, ScreenWidth, 44)];
    
    bottomView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self.view addSubview:bottomView];
    
    // 手机号
    UIImage *phoneImg = [UIImage imageNamed:@"2.0_phonenumber_icon"];
    
    UIImageView *phoneImgView = [[UIImageView alloc] initWithImage:phoneImg];
    
    phoneImgView.frame = CGRectMake(0, 0, 12, 18);
    
    inputField = [[NSTextField alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth -30, 34) drawingLeft:phoneImgView];
    
    inputField.layer.borderColor = [[UIColor clearColor] CGColor];
    
    inputField.font = [UIFont systemFontOfSize:12];
    
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    
    inputField.placeholder = @"来~说点什么吧";
    
    inputField.delegate = self;
    
    inputField.returnKeyType = UIReturnKeySend;
    
    [bottomView addSubview:inputField];
    
}
- (void)maskViewTap:(UIGestureRecognizer *)tap {
    
//    inputField.tag = 2;
    
    maskView.hidden = YES;
    
    [inputField resignFirstResponder];
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    
    maskView.hidden = YES;
    
    
    if (self.msgActBlock) {
        self.msgActBlock();
    }
    
//    [self publicCooperationMessageWithMessage:textField.text];
    if (messageType) {
    
        [self publicCooperationMessageWithMessage:textField.text andTargetUID:targetUid];
        
    } else {
        
        [self publicCooperationMessageWithMessage:textField.text andTargetUID:targetUid];
        
    }
    
    messageType = 1;
    
    textField.text = nil;
    
    return YES;
}
- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSCooperationMessageTableViewCell * cell = (NSCooperationMessageTableViewCell *)label.superview.superview;
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cell.commentModel.targetUserID]];
    pageVC.who = Other;
    [self.navigationController pushViewController:pageVC animated:YES];
    
}
- (NSMutableArray *)messageArr {
    if (!_messageArr) {
        self.messageArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _messageArr;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
