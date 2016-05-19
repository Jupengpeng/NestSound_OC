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
    
    //nav
    if ([Type isEqualToString:@"feedBack"]) {
        self.title = LocalizedStr(@"prompt_userFeedback");
    }else{
        self.title = LocalizedStr(@"post");
    }
    //comment textView
    comment = [[UITextView alloc] init];
    comment.delegate = self;

    [self.view addSubview:comment];
    
    //number textFiled
    cellNumber = [[UITextField alloc] init];
    cellNumber.delegate = self;
    cellNumber.placeholder = LocalizedStr(@"number");
    [self.view addSubview:cellNumber];
    
    //constraints
    [comment mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [cellNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
}


#pragma mark textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

}

#pragma mark textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{

}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}

@end
