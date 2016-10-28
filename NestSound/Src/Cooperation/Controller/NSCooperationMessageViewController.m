//
//  NSCooperationMessageViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationMessageViewController.h"
#import "NSCooperationMessageTableViewCell.h"
@interface NSCooperationMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSCooperationMessageTableViewCellDelegate,TTTAttributedLabelDelegate>
{
    UITableView * _messageTableView;
    UIImageView * _emptyImage;
    UIView *maskView;
    UIView *bottomView;
    NSTextField *inputField;
}
@end

@implementation NSCooperationMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCooperationMessageView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [inputField resignFirstResponder];
    [bottomView removeFromSuperview];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"commentCell";
    
    NSCooperationMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSCooperationMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.delegate = self;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentLabel.delegate = self;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSCooperationMessageTableViewCell *cell = (NSCooperationMessageTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.commentLabelMaxY;
}
- (void)setupCooperationMessageView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"留言";
    
    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 108) style:UITableViewStylePlain];
    
    //    commentTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _messageTableView.delegate = self;
    
    _messageTableView.dataSource = self;
    
    _messageTableView.backgroundColor = KBackgroundColor;
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_messageTableView setTableFooterView:noLineView];
    
    [self.view addSubview:_messageTableView];
    WS(wSelf);
    //refresh
    [_messageTableView addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
//            [wSelf fetchCommentWithIsLoadingMore:NO];
        }
    }];
    
    //loadingMore
    [_messageTableView addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
//            [wSelf fetchCommentWithIsLoadingMore:YES];
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
    
    //    inputField.placeholder = nil;
    
    [textField resignFirstResponder];
    
    maskView.hidden = YES;
    
//    if (inputField.tag == 1) {
    
//        [self postCommentWithComment:textField.text andUser:nil andType:2 andTargetUID:targetUserId];
        
//    } else {
//        
//        [self postCommentWithComment:textField.text andUser:nil andType:1 andTargetUID:0];
//        
//    }
    
//    inputField.tag = 2;
    
    textField.text = nil;
    
    return YES;
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
