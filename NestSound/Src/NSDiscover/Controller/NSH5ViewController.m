//
//  NSH5ViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSH5ViewController.h"

@interface NSH5ViewController ()
<
UIWebViewDelegate
>
{
    UIWebView * h5WebView;
}


@end


@implementation NSH5ViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIAppearance];
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    //nav
//    self.showBackBtn = YES;
    
    //webView
    h5WebView = [[UIWebView alloc] init];
    h5WebView.delegate = self;
    h5WebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [h5WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5Url]]];
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

@end
