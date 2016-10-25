//
//  NSMusicSayDetailController.m
//  NestSound
//
//  Created by yintao on 16/9/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicSayDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSShareView.h"
#import "NSCommentViewController.h"
#import "NSMusicSayListMode.h"
@interface NSMusicSayDetailController ()<UIWebViewDelegate>
{
    UIButton *_favourButton;
    UIButton *_commentButton;
    UIButton *_sharebutton;
    UIWebView *_webView;
    NSString *_urlString;
    NSShareView *_shareView;
    UIView *_maskView;

    BOOL _commentCountChanged;
}

@property (nonatomic,strong) NSMusicSay *musicModel;

@end

@implementation NSMusicSayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //评论数量改变了重新加载数据
    if (_commentCountChanged) {
        [self fechYueshuoDetail];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _commentCountChanged = NO;
    

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
//    _webView = nil;

}
- (void)setupUI{
//    self.title = @"乐说";
    self.title = self.name;
    //webView
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.contentUrl]]];
    [self.view addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        
    }];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 45 - 64, ScreenWidth, 45)];
    [self.view addSubview:bottomView];
    NSArray *normalIconArr = @[@"2.0_collection_normal",@"2.0_comment_no",@"2.0_share_icon"];
    NSArray *selectedIconArr = @[@"2.0_collection_selected",@"2.0_comment_no",@"2.0_share_icon"];
    CGFloat buttonWidth = ScreenWidth/3.0f;

    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, 45);
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            [btn setTitleColor:[UIColor hexColorFloat:@"646464"] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
            UIImage *normalImg = [UIImage imageNamed:normalIconArr[i]];
            [btn setImage:normalImg forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:selectedIconArr[i]] forState:UIControlStateSelected];

        } action:^(UIButton *btn) {
            
            if (btn == _favourButton) {
                CHLog(@"_favourButton");
                /**
                 *  点赞
                 */
                
                btn.selected = !btn.selected;
                [self httpPostDianzanWith:self.itemId];
            }else if (btn == _commentButton){
                CHLog(@"_commentButton");
                /**
                 type = 3表示乐说
                 
                 - returns: <#return value description#>
                 */
                NSCommentViewController *commentVC = [[NSCommentViewController alloc] initWithItemId: [self.itemId longLongValue] andType:3];
                
                commentVC.musicName = self.name;

                commentVC.commentExecuteBlock = ^(){
                    _commentCountChanged = YES;
                };
                [self.navigationController pushViewController:commentVC animated:YES];
            }else if (btn == _sharebutton){
                CHLog(@"_sharebutton");
                _maskView.hidden = NO;

                //分享
                [UIView animateWithDuration:0.25 animations:^{
                    
                    _shareView.y = ScreenHeight - _shareView.height;
                }];
            }
        }];
        switch (i) {
            case 0:
            {
                _favourButton = newButton;
            }
                break;
            case 1:
            {
                _commentButton = newButton;
            }
                break;
            case 2:
            {
                _sharebutton = newButton;
            }
                break;
            default:
                break;
        }
        [bottomView addSubview:newButton];
        
        CGPoint separatorPosition = CGPointMake((i + 1) * buttonWidth, 45/2.0f);
        CAShapeLayer *separator = [self createSeparatorLineWithColor:[UIColor hexColorFloat:@"dddfdf"] originPoint:CGPointMake(separatorPosition.x, 8) destPoint:CGPointMake(separatorPosition.x, 42) andPosition:separatorPosition ];
        [bottomView.layer addSublayer:separator];
    }
    CGPoint separatorPosition = CGPointMake(ScreenWidth/2.0f, 0.5);
    CAShapeLayer *separator = [self createSeparatorLineWithColor:[UIColor hexColorFloat:@"dddfdf"] originPoint:CGPointMake(0, 0.5) destPoint:CGPointMake(ScreenWidth, 0.5) andPosition:separatorPosition ];
    [bottomView.layer addSublayer:separator];
    
    
    
    _maskView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _maskView.backgroundColor = [UIColor lightGrayColor];
    _maskView.alpha = 0.5;
    [self.navigationController.view addSubview:_maskView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    _maskView.hidden = YES;
    [_maskView addGestureRecognizer:tap];
    /**
     *  分享界面
     */
    _shareView = [[NSShareView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 180) withType:@"yueshuo"];
    
    _shareView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < _shareView.shareArr.count; i++) {
        
        UIButton *shareBtn = (UIButton *)[_shareView viewWithTag:250+i];
        [shareBtn addTarget:self action:@selector(handleShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navigationController.view  addSubview:_shareView];

    
    [self fechYueshuoDetail];
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString *clickStr=request.URL.absoluteString;
    //如果是保全证书
//    if ([self.h5Url containsString:@"certificate"]) {
//        return YES;
//    }
//    
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

- (void)setupData{
    
    
    
    [_favourButton setTitle:[NSString stringWithFormat:@"(%d)",123] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"(%d)",123] forState:UIControlStateNormal];
    [_sharebutton setTitle:[NSString stringWithFormat:@"(%d)",123] forState:UIControlStateNormal];
    
    
}


#pragma mark - internet request 

- (void)fechYueshuoDetail{
    self.requestType = NO;
    self.requestParams = @{@"itemid":self.itemId,
                           @"uid":JUserID,
                           @"token":LoginToken};
    self.requestURL = musicSayDetailUrl;
}

- (void)postUpdateShareCount{
    
    self.requestType = NO;
    self.requestParams = @{@"itemid":self.itemId,
                           @"token":LoginToken};
    self.requestURL = updateShareCount;
    
}

- (void)httpPostDianzanWith:(NSString *)itemId{
    
    
    self.requestType = NO;
    self.requestParams = @{@"itemid":itemId,
                           @"uid":JUserID,
                           @"token":LoginToken};
    self.requestURL = musicSayDianzanUrl;
    
}



#pragma mark overwrite

- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        
    }else{
        if ([operation.urlTag isEqualToString:musicSayDianzanUrl]) {
            NSBaseModel *baseModel = (NSBaseModel *)parserObject;
            
            NSString *msg = [baseModel.data objectForKey:@"mp3URL"];
            if ([msg isEqualToString:@"取消点赞成功"]) {
                _favourButton.selected = NO;
            }else{
                _favourButton.selected = YES;

            }
            [[NSToastManager manager] showtoast:msg];
            [self fechYueshuoDetail];

        
        }else if ([operation.urlTag isEqualToString:musicSayDetailUrl]){
            NSMusicSay *musicModel = (NSMusicSay *)parserObject;
            self.musicModel = musicModel;
            
            _favourButton.selected = musicModel.isZan;
            
            [_favourButton setTitle:[NSString stringWithFormat:@"(%d)",[musicModel.zannum intValue]] forState:UIControlStateNormal];
            [_commentButton setTitle:[NSString stringWithFormat:@"(%d)",[musicModel.commentnum intValue]] forState:UIControlStateNormal];
            [_sharebutton setTitle:[NSString stringWithFormat:@"(%d)",musicModel.sharenum.intValue] forState:UIControlStateNormal];
        }else if ([operation.urlTag isEqualToString:updateShareCount]){
            
//            NSBaseModel *baseModel = (NSBaseModel *)parserObject;

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  画线
 *
 *  @param color     颜色
 *  @param oriPoint  起始位置
 *  @param destPoint 结束位置
 *  @param position  线条中心
 *
 *  @return 线条
 */
- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color
                                   originPoint:(CGPoint)oriPoint
                                     destPoint:(CGPoint)destPoint
                                   andPosition:(CGPoint)position {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(oriPoint.x,oriPoint.y)];
    [path addLineToPoint:CGPointMake(destPoint.x, destPoint.y)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = position;
    
    return layer;
}

//分享
- (void)handleShareAction:(UIButton *)sender {
    BOOL isShare = YES;
    UMSocialUrlResource * urlResource  = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:self.contentUrl];
    [UMSocialData defaultData].extConfig.title = self.name;
    
    NSDictionary *dic = _shareView.shareArr[sender.tag-250];
    NSString *contentStr = self.detailStr;
    if (dic[@"type"] == UMShareToWechatSession) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;

        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.contentUrl;
    } else if (dic[@"type"] == UMShareToWechatTimeline) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.contentUrl;
    } else if (dic[@"type"] == UMShareToSina) {
        
        [UMSocialData defaultData].extConfig.sinaData.urlResource = urlResource;
        contentStr = [NSString stringWithFormat:@"%@——%@ %@",self.name ,self.detailStr,self.contentUrl];
        
    } else if (dic[@"type"] == UMShareToQQ) {
        TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqAppId
                                               andDelegate:nil];
        QQApiNewsObject *urlObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.contentUrl] title:self.name description:self.detailStr previewImageURL:[NSURL URLWithString:self.picUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
//        [UMSocialData defaultData].extConfig.qqData.url = self.contentUrl;
        isShare = NO;
    } else if (dic[@"type"] == UMShareToQzone) {
        TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqAppId
andDelegate:nil];
        QQApiNewsObject *urlObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.contentUrl] title:self.name description:self.detailStr previewImageURL:[NSURL URLWithString:self.picUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        [self handleSendResult:sent];
        [UMSocialData defaultData].extConfig.qqData.url = self.contentUrl;
//        [UMSocialData defaultData].extConfig.qzoneData.url = self.contentUrl;
        isShare = NO;
    } else if ([dic[@"type"] isEqualToString:@"copy"]) {
        
        [UIPasteboard generalPasteboard].string = self.contentUrl;
        [[NSToastManager manager] showtoast:@"复制成功"];
        isShare = NO;
    }
    [self tapClick:nil];

    if (isShare) {
        NSLog(@"%d",urlResource.resourceType);
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[dic[@"type"]] content:contentStr image:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.picUrl]] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [self tapClick:nil];
                [[NSToastManager manager] showtoast:@"分享成功"];
                /**
                 *  跟新分享数量
                 */
                [self postUpdateShareCount];
                
                [self fechYueshuoDetail];
            }
        }];
    }
}
- (void)tapClick:(UIGestureRecognizer *)tap {
    
    _maskView.hidden = YES;

    [UIView animateWithDuration:0.25 animations:^{
        _shareView.y = ScreenHeight;
        
    }];
}

@end
