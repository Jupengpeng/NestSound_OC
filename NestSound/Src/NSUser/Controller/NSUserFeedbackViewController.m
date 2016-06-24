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


-(void)viewDidLoad
{
    [super viewDidLoad];
    
   
}

-(void)feedBackWithContent:(NSString *)content_ andNumber:(NSString *)number
{   
    self.requestType = NO;
    
    self.requestParams= @{@"userid":JUserID,@"text":[NSString stringWithFormat:@"%@",content_],@"phone":[NSString stringWithFormat:@"%@",number],@"token":LoginToken};

    if ([Type isEqualToString:@"feedBack"]) {
        self.requestURL = feedBackURL;
        
    }else{
        
        self.requestURL = reportURL;
        
    }
    
}

-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{

    if (!parserObject.success) {
        [[NSToastManager manager] showtoast:@"发布成功，我们运营会尽快解决您反馈的问题"];
        [self.navigationController popViewControllerAnimated:YES];
    }

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
    cellNumber.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 10)];
    cellNumber.leftViewMode = UITextFieldViewModeAlways;
    cellNumber.delegate = self;
    cellNumber.placeholder = @"请输入你的邮箱或电话号码，我们会及时与您取得联系";
//    LocalizedStr(@"number");
    cellNumber.font = [UIFont systemFontOfSize:12];
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
        self.title = @"用户反馈";
//        LocalizedStr(@"prompt_userFeedback");
        placeHolderLabel.text = @"请输入您的意见或建议，我们将不断改进";
//        LocalizedStr(@"prompt_comment");
    }else{
        self.title = @"举报";
//        LocalizedStr(@"prompt_post");
        placeHolderLabel.text = @"我们会尽快对您举报内容做处理";
//        LocalizedStr(@"prompt_report");
    }
    
    UIBarButtonItem * upload = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(uploadComment)];
    self.navigationItem.rightBarButtonItem = upload;
    
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
        [[NSToastManager manager] showtoast:@"反馈内容不能为空"];
    }else{
        if (cellNumber.text.length == 0) {
            [[NSToastManager manager] showtoast:@"手机号码不能为空"];
        }else{
            [self feedBackWithContent:comment.text andNumber:cellNumber.text];
            
        }
    }
}
@end
