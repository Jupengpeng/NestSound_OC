//
//  NSUserFeedbackViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserFeedbackViewController.h"

@interface NSUserFeedbackViewController ()
<
UITextViewDelegate,
UITextFieldDelegate
>
{
    NSString * Type;
    UILabel * placeHolderLabel;
    UITextView * comment;
    UITextField * cellNumber;
}
@end

@implementation NSUserFeedbackViewController

-(instancetype)initWithType:(NSString *)type
{
    if (self = [super init]) {
        Type = type;
        [self configureUIAppearance];
    }
    return self;
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //comment textView
    comment = [[UITextView alloc] init];
    comment.delegate = self;
    comment.selectedRange = NSMakeRange(0,15);
    
    [self.view addSubview:comment];
    
    //number textFiled
    cellNumber = [[UITextField alloc] init];
    cellNumber.delegate = self;
    cellNumber.placeholder = LocalizedStr(@"number");
    cellNumber.backgroundColor = [UIColor hexColorFloat:@"ffffff"];
    
    [self.view addSubview:cellNumber];
    
    //placeHolder
    placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.font = [UIFont systemFontOfSize:12];
    placeHolderLabel.textColor = [UIColor hexColorFloat:@"dfdfdf"];
    placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:placeHolderLabel];
    
    //nav
    if ([Type isEqualToString:@"feedBack"]) {
        self.title = LocalizedStr(@"prompt_userFeedback");
        placeHolderLabel.text = LocalizedStr(@"prompt_comment");
    }else{
        self.title = LocalizedStr(@"post");
        placeHolderLabel.text = LocalizedStr(@"prompt_report");
    }
    
    
    //constraints
    [comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(-1);
        make.right.equalTo(self.view.mas_right).with.offset(1);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(250);
        
    }];
    
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(self.view.mas_top).with.offset(10);
    }];
    
    [cellNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(-1);
        make.right.equalTo(self.view.mas_right).with.offset(1);
        make.top.equalTo(comment.mas_bottom).with.offset(10);
        make.height.mas_equalTo(45);
        
    }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [comment resignFirstResponder];
    [cellNumber resignFirstResponder];
}

#pragma mark textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [cellNumber resignFirstResponder];
}

#pragma mark textViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    placeHolderLabel.hidden = YES;
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        placeHolderLabel.hidden = NO;
    }else{
        placeHolderLabel.hidden = YES ;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}


-(void)uploadComment
{
    if (comment.text.length == 0) {

    }else{
        if (cellNumber.text.length == 0) {
            
        }else{
            
        }
    }
}
@end
