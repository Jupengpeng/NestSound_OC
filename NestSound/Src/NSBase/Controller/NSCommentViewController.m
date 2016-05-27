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

@interface NSCommentViewController () <UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate, UIScrollViewDelegate, UITextFieldDelegate> {
    
    UITableView *commentTableView;
    
    UIView *bottomView;
    
    UIView *maskView;
    
    UITextField *inputField;
}

@end

@implementation NSCommentViewController

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
    
    maskView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"点击了发送");
    
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
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.commentLabel.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSCommentTableViewCell *cell = (NSCommentTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.commentLabelMaxY;
}


- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] init];
    
    [self.navigationController pushViewController:pageVC animated:YES];
    
    NSLog(@"点击了回复的用户");
}




@end
