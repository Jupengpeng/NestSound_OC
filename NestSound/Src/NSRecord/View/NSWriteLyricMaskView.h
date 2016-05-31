//
//  NSWriteLyricMaskView.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSLyricLibraryListModel;


@protocol lyricsDelegate;

@interface NSWriteLyricMaskView : UIView

@property (nonatomic,strong) NSLyricLibraryListModel * lyricLibraryListModel;

@property (nonatomic,unsafe_unretained) id<lyricsDelegate> delegate;
@end

@protocol lyricsDelegate<NSObject>
- (void)selectedlrcString:(NSString *)lrcString_;//chose Lyric
@end
