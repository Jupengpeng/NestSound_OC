//
//  AFHTTPRequestOperation+additionals.h
//  FramePackage
//
//  Created by yandi on 15/10/14.
//  Copyright © 2015年 yinchao. All rights reserved.
//

@interface NSURLSessionTask (NSAdditionals)

@property (nonatomic,copy) NSString *urlTag;
@property (nonatomic,assign) BOOL isLoadingMore;
@end
