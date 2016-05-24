//
//  NSRecordToolView.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRecordToolView.h"

@interface NSRecordToolView ()
{
    UIImageView * processLine;
    
}
@end

@implementation NSRecordToolView

-(instancetype)init
{
    if (self = [super init]) {
        [self configureUIAppearance];
    }
    return self;
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    
}

#pragma mark layoutSubViews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //constraints
    
}
@end
