//
//  NSLyricView.m
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricView.h"

@interface NSLyricView () <UIScrollViewDelegate,UITextViewDelegate>

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
    
    self.lyricView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    self.lyricView.contentSize = CGSizeMake(self.width, self.height + 1);
    
    self.lyricView.delegate = self;
    
    [self addSubview:self.lyricView];
    
    self.lyricText = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, self.lyricView.width - 30, self.lyricView.height - 15)];
        
    self.lyricText.font = [UIFont systemFontOfSize:15];
    
    [self.lyricView addSubview:self.lyricText];

}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.lyricText resignFirstResponder];
}

@end
