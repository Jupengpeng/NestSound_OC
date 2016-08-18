//
//  NSChangeNameViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSChangeNameViewController.h"

@interface NSChangeNameViewController ()
<
UITextFieldDelegate
>
{
    UITextField * nameText;
    NSString * Type;
    UIBarButtonItem * complete;
}
@end

@implementation NSChangeNameViewController


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

-(void)configureUIAppearance
{
    if ([Type isEqualToString:@"name"]) {
        self.title = @"修改昵称";
    }else{
        self.title = @"修改描述";
    }
    self.view.backgroundColor = KBackgroundColor;
    complete = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeChange)];
    self.navigationItem.rightBarButtonItem = complete;
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    nameText = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 45)];
    nameText.font = [UIFont systemFontOfSize:15];
    nameText.textColor = [UIColor hexColorFloat:@"181818"];
    nameText.backgroundColor = [UIColor whiteColor];
    [nameText addTarget:self action:@selector(calculateTextLength:) forControlEvents:UIControlEventEditingChanged];
    nameText.delegate = self;
    [self.view addSubview:nameText];
    
}
- (void)calculateTextLength:(UITextField *)textField {
    
    if (textField.text.length > 30) {
        complete.enabled = NO;
        [[NSToastManager manager] showtoast:@"请限制在30字以内哦"];
    } else {
        complete.enabled = YES;
    }
}
-(void)completeChange
{
    self.returnNameBlock(nameText.text);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)returnName:(returnName)block
{
    self.returnNameBlock = block;
}

@end
