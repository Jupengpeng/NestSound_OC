//
//  NSLexiconCollectionViewCell.m
//  NestSound
//
//  Created by Apple on 16/6/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLexiconCollectionViewCell.h"
#import "NSLyricLibraryListModel.h"
@interface NSLexiconCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation NSLexiconCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        
        label.textColor = [UIColor blackColor];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        self.label = label;
        
        [self.contentView addSubview:label];
    }
    return self;
}

- (void)setLyricLibraryListModel:(NSTypeLyricListModel *)lyricLibraryListModel {
    
    self.label.text = lyricLibraryListModel.typeTitle;
}

@end
