//
//  NSBaseViewController.m
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSHttpClient.h"
#import "NSBaseViewController.h"

@interface NSBaseViewController ()

@end

@implementation NSBaseViewController

@synthesize requestURL;

- (instancetype)init {
    if (self = [super init]) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - subclass can override
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject
                     error:(NSError *)requestErr {
    // subclass can override
}

#pragma mark - settter & getter
-(void)setRequestType:(BOOL)requestType
{
    _requestType = requestType;
}

- (void)setRequestURL:(NSString *)url {
    requestURL = url;
    __weak typeof(self) wSelf = self;
    

    
    NSURLSessionDataTask *operation =[[NSHttpClient client] requestWithURL:requestURL type:self.requestType                                          paras:self.requestParams
                                                                    success:^(NSURLSessionDataTask *operation, NSObject *parserObject) {
                                                                        
                                                                        
                                                                        
                                                                        NSBaseModel *responseModel = (NSBaseModel *)parserObject;
                                                                        
                                                                        
                                                                        // callback
                                                                        [wSelf actionFetchRequest:operation
                                                                                           result:responseModel
                                                                                            error:nil];
                                                                    }
                                                                    failure:^(NSURLSessionDataTask *operation, NSError *requestErr) {
                                                                        
                                                                        [wSelf actionFetchRequest:operation result:nil error:requestErr];
                                                                    }];
#ifdef DEBUG
    NSLog(@"requestURL %@",operation.originalRequest.URL.absoluteString);
#endif
}

- (void)setShowBackBtn:(BOOL)showBackBtn {
    _showBackBtn = showBackBtn;
    if (_showBackBtn) {
        WS(wSelf);
        [self.navigationItem actionCustomLeftBarButton:nil
                                              nrlImage:@"2.0_back"
                                              hltImage:@"2.0_back"
                                                action:^{
                                                    
                                                    if (!wSelf) {
                                                        return ;
                                                    }
                                                    if (wSelf.navigationController.presentingViewController && [wSelf isEqual:wSelf.navigationController.viewControllers.firstObject]) {
                                                        [wSelf.navigationController dismissViewControllerAnimated:YES completion:NULL];
                                                    } else {
                                                        [wSelf.navigationController popViewControllerAnimated:YES];
                                                    }
                                                }];
    }
}

#pragma mark - authFromLoginWithReqURL
- (void)authFromLoginWithReqURL:(NSString *)reqURL {
    
}

#pragma mark - upvote music/lyric
-(void)upvoteItemId:(long)itemId_ _targetUID:(long)targetUID_ _type:(long)type_ _isUpvote:(BOOL)isUpvote
{


}


@end
