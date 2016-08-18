//
//  NSCustomMusicController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

/**
 *  拨打电话：
 */

static NSString  * const phoneUrlStr = @"yinchao://customization/tel/057186693441";

//查看音乐人列表：
static NSString  * const musicianListUrlStr = @"yinchao://customization/musician/list";

//查看一条音乐人记录：(uid => 音乐人id)
static NSString  * const musicianSigleUrlStr = @"yinchao://customization/musician/uid/";

//进行中的活动：(type => 0 为歌曲  1 => 歌词，aid => 活动id）
static NSString  * const activityBeOnUrlStr = @"yinchao://customization/match/ing/";
        
//  已结束的活动：(type => 0 为歌曲  1 => 歌词，aid => 活动id）
static NSString  * const activityBeOverUrlStr = @"yinchao://customization/match/end/aid/";
//aid=2&type=1

#import "NSCustomMusicController.h"
#import "NSStarMusicianListController.h"
#import "NSStarMusicianDetailController.h"
#import "NSActivityOverViewController.h"
#import "NSThemeActivityController.h"
@interface NSCustomMusicController ()<UIWebViewDelegate>

@property (nonatomic,copy) NSString *phoneUrlStr;


@property (nonatomic,strong) UIWebView *customMusicWebView;

@end

@implementation NSCustomMusicController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)initUI{

    self.title = @"大牌定制工坊";
    [self.view addSubview:self.customMusicWebView];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *clickStr=request.URL.absoluteString;
    
    /**
     *  电话
     */
    if ([clickStr isEqualToString:phoneUrlStr]) {
        NSMutableString * str1=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18501423218"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str1]]];
        [self.view addSubview:callWebview];
        /**
         音乐人列表
         */
    }else if([clickStr isEqualToString:musicianListUrlStr]){
        NSStarMusicianListController *musicianController = [[NSStarMusicianListController alloc] init];
        [self.navigationController pushViewController:musicianController animated:YES];
    }else if([clickStr containsString:musicianSigleUrlStr]){
        NSRange range = [clickStr rangeOfString:musicianSigleUrlStr];
        /**
         音乐人 id
         */
        NSRange uidRange = NSMakeRange(range.location + range.length, clickStr.length - (range.location + range.length));
        NSString *uid = [clickStr substringWithRange:uidRange];
        NSStarMusicianDetailController *detailController = [[NSStarMusicianDetailController alloc]init];
        detailController.uid = uid;
        [self.navigationController pushViewController:detailController animated:YES];
        
    }else if([clickStr containsString:activityBeOnUrlStr]){
        /**
         *  进行中活动
         */
        NSRange range = [clickStr rangeOfString:activityBeOnUrlStr];

        NSRange parametersRange = NSMakeRange(range.location + range.length, clickStr.length - (range.location + range.length));
        NSString *parameterStr = [clickStr substringWithRange:parametersRange];
        
        NSArray *parameters = [parameterStr componentsSeparatedByString:@"&"];
        
        NSString *aidKeyValue = parameters[0];
        NSString *typeKeyValue = parameters[1];
        
        NSString *aid = [aidKeyValue substringWithRange:NSMakeRange(4, aidKeyValue.length - 4)];
        NSString *type = [typeKeyValue substringWithRange:NSMakeRange(5, typeKeyValue.length - 5)];

        NSThemeActivityController *activityController = [[NSThemeActivityController alloc]init];
        activityController.aid = aid;
        activityController.type = type;
        [self.navigationController pushViewController:activityController animated:YES];

        
        
    }else  if([clickStr containsString:activityBeOverUrlStr]){
        /**
         关闭的活动
                  */
        NSActivityOverViewController *actOverController = [[NSActivityOverViewController alloc] init];
        actOverController.contentUrlString = clickStr;
        [self.navigationController pushViewController:actOverController animated:YES];
    }
    
    return YES;
}

- (UIWebView *)customMusicWebView{
    if (!_customMusicWebView) {
        _customMusicWebView = [[UIWebView alloc] init ];
        _customMusicWebView.delegate = self;
        _customMusicWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_customMusicWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kCustomMusicUrl]]];
        [self.view addSubview:_customMusicWebView];
        
        [_customMusicWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
        
    }
    return _customMusicWebView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
