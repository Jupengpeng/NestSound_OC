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
    
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    nameText = [[UITextField alloc] init];
    nameText.font = [UIFont systemFontOfSize:15];
    nameText.textColor = [UIColor hexColorFloat:@"181818"];
    nameText.backgroundColor = [UIColor whiteColor];
    nameText.textAlignment = NSTextAlignmentLeft;
    nameText.delegate = self;
    [self.view addSubview:nameText];
    
    //constraints
    [nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45);
    }];
    
}


-(void)changeNameWithContent:(NSString *)content
{
   
    self.requestParams =@{@"type":@(NO),@"":@"",@"":@""};
    if ([Type isEqualToString:@"name"]) {
#warning changeName url
//        self.requestURL = ;
    }else{
#warning changeDetaile url
//        self.requestURL = ;
    }
}
#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
//    if ([operation.urlTag isEqualToString:]) {
//    
//        
//    }else if ([operation.urlTag isEqualToString:]){
//    
//    
//    }
}


@end
