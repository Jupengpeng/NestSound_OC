//
//  NSLyricView.m
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricView.h"

@interface NSLyricView () <UIScrollViewDelegate>

@end

@implementation NSLyricView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI {
    
    UIScrollView *lyricView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,5, self.width, self.height)];
    
    lyricView.contentSize = CGSizeMake(self.width, self.height + 1);
    
    lyricView.delegate = self;
    
    [self addSubview:lyricView];
    
    self.lyricText = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, lyricView.width - 30, lyricView.height - 15)];
    
    self.lyricText.font = [UIFont systemFontOfSize:15];
    
    [lyricView addSubview:self.lyricText];
//    self.backgroundColor = [UIColor whiteColor];
}




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.lyricText resignFirstResponder];
}



@end
