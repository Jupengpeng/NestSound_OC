//
//  NSBaseViewController.h
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSBaseModel;
@interface NSBaseViewController : UIViewController

@property (nonatomic, assign) BOOL showBackBtn;
@property (nonatomic,copy) NSString *requestURL;
@property (nonatomic,strong) NSDictionary *requestParams;


- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject
                     error:(NSError *)requestErr; // subclass can override
@end
