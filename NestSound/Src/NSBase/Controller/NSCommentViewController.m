//
//  NSCommentViewController.m
//  NestSound
//
//  Created by Apple on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCommentViewController.h"
#import "NSCommentTableViewCell.h"
#import "NSUserPageViewController.h"
@interface NSCommentViewController () <UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate, UIScrollViewDelegate, UITextFieldDelegate, NSCommentTableViewCellDelegate> {
    
    UITableView *commentTableView;
    
    UIView *bottomView;
    
    UIView *maskView;
    
    UITextField *inputField;
    long itemID ;
    int currentPage;
    int type;
    NSString * commentUrl;
    NSString * postCommentUrl;
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
    
    self.title = [NSString stringWithFormat:@"%@的评论",@"悟空"];
    
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 108)];
    
    commentTableView.delegate = self;
    
    commentTableView.dataSource = self;
    
    commentTableView.estimatedRowHeight = 80;
    
    [self.view addSubview:commentTableView];
    
    [self bottomView];
    
    
    
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -fetchCommentData
-(void)fetchCommentWithIsLoadingMore:(BOOL)isLoadingMore
{
    self.requestType = NO;
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{kIsLoadingMore:@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    NSDictionary * dic = @{@"itemid":[NSString stringWithFormat:@"%ld",itemID],@"page":[NSString stringWithFormat:@"%d",currentPage],@"type":[NSString stringWithFormat:@"%d",type],@"token":LoginToken};
    NSString * str = [NSTool encrytWithDic:dic];
    commentUrl = [commentURL stringByAppendingString:str];
    self.requestURL = commentURL;

}

#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (parserObject.success) {
        
       
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
            
        bottomView.y = keyBoardEndY - bottomView.height - 64;
        
    }];
    
}




- (void)bottomView {
    
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    maskView.backgroundColor = [UIColor lightGrayColor];
    
    maskView.alpha = 0.5;
    
    maskView.hidden = YES;
    
    [self.view addSubview:maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    [maskView addGestureRecognizer:tap];
    
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 108, ScreenWidth, 44)];
    
    bottomView.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self.view addSubview:bottomView];
    
//    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
//       
//        [btn setTitle:@"发送" forState:UIControlStateNormal];
//        
//        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        
//    } action:^(UIButton *btn) {
//        
//        NSLog(@"点击了发送");
//        
//    }];
    
//    [bottomView addSubview:sendBtn];
//    
//    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.equalTo(bottomView.mas_right).offset(-15);
//        
//        make.width.mas_equalTo(45);
//        
//        make.centerY.equalTo(bottomView.mas_centerY);
//        
//    }];
    
    inputField = [[UITextField alloc] init];
    
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    
    inputField.delegate = self;
    
    [bottomView addSubview:inputField];
    
    inputField.returnKeyType = UIReturnKeySend;
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bottomView.mas_left).offset(15);
        
        make.top.equalTo(bottomView.mas_top).offset(5);
        
        make.bottom.equalTo(bottomView.mas_bottom).offset(-5);
        
        make.right.equalTo(bottomView.mas_right).offset(-15);
        
    }];
}

- (void)tap:(UIGestureRecognizer *)tap {
    
    [inputField resignFirstResponder];
    
    inputField.text = nil;
    
    inputField.placeholder = nil;
    
    inputField.tag = 2;
    
    maskView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    textField.text = nil;
    
    inputField.placeholder = nil;
    
    [textField resignFirstResponder];
    
    maskView.hidden = YES;
    
    
    if (inputField.tag == 1) {
        
        NSLog(@"点击了发送. 回复他人的评论");
    } else {
        
        NSLog(@"点击了发送. 发表评论");
    }
    
    
    inputField.tag = 2;
    
    return YES;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"commentCell";
    
    NSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.delegate = self;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.commentLabel.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSCommentTableViewCell *cell = (NSCommentTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.commentLabelMaxY;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    maskView.hidden = NO;
    
    [inputField becomeFirstResponder];
    
    inputField.tag = 1;
    
    inputField.placeholder = [NSString stringWithFormat:@"回复: %@",cell.authorNameLabel.text];
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] init];
    
    [self.navigationController pushViewController:pageVC animated:YES];
    
    NSLog(@"点击了回复的用户");
}


- (void)commentTableViewCell:(NSCommentTableViewCell *)cell {
    
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] init];
    
    [self.navigationController pushViewController:pageVC animated:YES];
    
    NSLog(@"点击了用户的头像");
    
}


@end
