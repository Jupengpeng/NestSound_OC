//
//  NSUserFeedbackViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserFeedbackViewController.h"

@interface NSUserFeedbackViewController ()
{
    NSString * Type;
    UITextView * comment;
    UITextField * cellNumber;
}
@end

@implementation NSUserFeedbackViewController

-(instancetype)initWithType:(NSString *)type
{
    if (self = [super init]) {
        Type = type;
        [self configureUIAppearance];
    }
    return self;
}

-(void)configureUIAppearance
{
    
}

@end
