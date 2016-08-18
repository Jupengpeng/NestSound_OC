//
//  NSActivityOverViewController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSActivityOverViewController.h"

@interface NSActivityOverViewController ()<
UIWebViewDelegate
>
{
    UIWebView * h5WebView;
}


@end

@implementation NSActivityOverViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIAppearance];
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    
    //webView
    h5WebView = [[UIWebView alloc] init];
    h5WebView.delegate = self;
    h5WebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [h5WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.contentUrlString]]];
    [self.view addSubview:h5WebView];
    
    [h5WebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
