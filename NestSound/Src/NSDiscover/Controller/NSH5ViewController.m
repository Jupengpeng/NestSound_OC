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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self configureUIAppearance];

    NSLog(@"%@",self.h5Url);
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToBefore)];
    //webView
    h5WebView = [[UIWebView alloc] init];
    h5WebView.delegate = self;
    h5WebView.dataDetectorTypes = UIDataDetectorTypeNone;
    h5WebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [h5WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5Url]]];
    [self.view addSubview:h5WebView];
    
    [h5WebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
}
-(void)backToBefore{
    
    // 点击返回时，返回操作的上一页
    
    if (h5WebView.canGoBack) {
        
        [h5WebView goBack];
        
    } else {
        
//        [super backToBefore];
        
        [h5WebView stopLoading];
        
        h5WebView.delegate =nil;
        
        h5WebView = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString *clickStr=request.URL.absoluteString;
    //如果是保全证书
//    if ([self.h5Url containsString:@"certificate"]) {
//        return YES;
//    }
    
//    if (![self.h5Url isEqualToString:clickStr]) {
//        NSH5ViewController * eventVC = [[NSH5ViewController alloc] init];
//        eventVC.h5Url = clickStr;
//        [self.navigationController pushViewController:eventVC animated:YES];
//    }

    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
