//
//  NSIndexCollectionReusableView.m
//  NestSound
//
//  Created by Apple on 16/5/2.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSIndexCollectionReusableView.h"
#import "NSIndexModel.h"

@interface NSIndexCollectionReusableView () <UIScrollViewDelegate> {

    UIScrollView *_scrollView;
    
    NSInteger arrConut;
    
    NSTimer *_timer;
    
    UIPageControl *_page;
    NSMutableArray * bannerImageArr;
    NSMutableArray * songAry;
//    UIButton *_moreBtn;
    
}
@property (nonatomic,strong) UIButton *moreBtn;
@end

@implementation NSIndexCollectionReusableView
//- (UIButton *)moreBtn {
//    if (!_moreBtn) {
//        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
//        
//        [self.moreBtn setImage:[UIImage imageNamed:@"2.0_more"] forState:UIControlStateNormal];
//        
//        [self.moreBtn setTitleColor:[UIColor hexColorFloat:@"666666"] forState:UIControlStateNormal];
//        
//        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        
//        self.moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//        
//        self.moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
//    }
//    return _moreBtn;
//}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self resetupIndexCollectionReusableView];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_vertical"]];
        icon.tag = 150 ;
        icon.layer.cornerRadius = icon.width * 0.5;
        
        icon.clipsToBounds = YES;
        
        [self addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            
            make.bottom.equalTo(self.mas_bottom).offset(-8);
            
        }];
        
        _titleLable = [[UILabel alloc] init];
        
        _titleLable.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:_titleLable];
        
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(self.mas_bottom).offset(-8);
            
            make.left.equalTo(icon.mas_right).offset(8);
            
        }];
        
//
//
//        [self addTimer];
        
    }
    
    return self;
}

- (void)resetupIndexCollectionReusableView {
    self.SDCycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/5)];
    _SDCycleScrollView.placeholderImage = [UIImage imageNamed:@"2.0_placeHolder_long"];
    
    _SDCycleScrollView.autoScrollTimeInterval = 3.0;
    
    _SDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    [UIColor hexColorFloat:@"c1c1c1"]
    
    _SDCycleScrollView.currentPageDotColor = [UIColor hexColorFloat:@"ffce00"];
    [self addSubview:_SDCycleScrollView];
    
}

- (UIButton *)loadMore:(BOOL)flag {
    
    if (flag) {
//        if (self.moreBtn) {
            [self.moreBtn removeFromSuperview];
            _moreBtn = nil;
//        }
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        
        [self.moreBtn setImage:[UIImage imageNamed:@"2.0_more"] forState:UIControlStateNormal];
        
        [self.moreBtn setTitleColor:[UIColor hexColorFloat:@"666666"] forState:UIControlStateNormal];
        
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        self.moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        
        self.moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
        
        [self addSubview:self.moreBtn];
        
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);

            make.bottom.equalTo(self.mas_bottom).offset(-8);
            
            
        }];
    } else {
//        if (self.moreBtn) {
            [self.moreBtn removeFromSuperview];
            _moreBtn = nil;
//        }
    }
    return self.moreBtn;
}


- (void)addHeaderViewWithImageArray:(NSArray *)imageArray {

    if (_scrollView) {
        _scrollView.hidden = NO;
        _page.hidden = NO;
        return;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 140)];
    arrConut = imageArray.count;
    _scrollView.delegate = self;
    for (int i = 0; i < arrConut * 3; i++) {
     
        UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 140)];
        UIImageView * im = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 140)];
        
        [imageBtn setAdjustsImageWhenHighlighted:NO];
        
        imageBtn.tag = i % arrConut;
//        [im setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        im.contentMode =  UIViewContentModeScaleAspectFill;
//        im.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        im.clipsToBounds  = YES;
        
        [im setDDImageWithURLString:imageArray[i % arrConut] placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
        

        im.userInteractionEnabled = YES;
        
        
//        [imageBtn setImage:imageBtn.imageView.image forState:UIControlStateNormal];
        
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * arrConut, 0) animated:NO];
//        [im mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.top.right.bottom.equalTo(imageBtn);
//        }];
         [_scrollView addSubview:im];
        [_scrollView addSubview:imageBtn];
       
    }
    


    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * arrConut * 3, 0);
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.pagingEnabled = YES;

    _scrollView.tag = 100;
    
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
    
    _page = [[UIPageControl alloc] init];
    
    _page.numberOfPages = arrConut;
    
    _page.pageIndicatorTintColor = [UIColor hexColorFloat:@"c1c1c1"];
    
    _page.currentPageIndicatorTintColor = [UIColor hexColorFloat:@"ffce00"];
    
    _page.tag = 200;
    
    [self addSubview:_page];
    
    [_page mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_scrollView.mas_centerX);
        
        make.top.mas_equalTo(_scrollView.mas_bottom);
        
    }];
    
}

- (void)imageBtnClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(indexCollectionReusableView:withImageBtn:)]) {
    
        [self.delegate indexCollectionReusableView:self withImageBtn:btn];
    }
}

- (void)changeImage {
    


    if (_scrollView.contentOffset.x < [UIScreen mainScreen].bounds.size.width * (arrConut * 2)) {


        CGPoint point = CGPointMake(_scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width, 0);

        
        [_scrollView setContentOffset:point animated:YES];
        


        _page.currentPage = (NSInteger)((_scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width) / [UIScreen mainScreen].bounds.size.width) % (arrConut);

    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (_scrollView.contentOffset.x >= [UIScreen mainScreen].bounds.size.width * (arrConut * 2)) {
        
        [_scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * arrConut, 0) animated:NO];
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    [self addTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (_scrollView.contentOffset.x < [UIScreen mainScreen].bounds.size.width * arrConut) {
        
        [_scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * ((arrConut * 2) - 1), 0) animated:NO];

    }
    
    if (_scrollView.contentOffset.x >= [UIScreen mainScreen].bounds.size.width * arrConut * 2) {
        
        [_scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * arrConut, 0) animated:NO];
        
    }
    
    _page.currentPage = (NSInteger)(_scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width) % arrConut;
}

- (void)addTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}


- (void)removeTimer {
    
    [_timer invalidate];
    
    _timer = nil;
}

- (void)dealloc {
    
    [self removeTimer];
}


#pragma mark - setter && getter
-(void)setBannerAry:(NSMutableArray *)bannerAry
{
    _bannerAry = bannerAry;
    if (bannerAry.count) {
        NSMutableArray * bannerAry1 = [NSMutableArray array];
        for (id obj in bannerAry) {
            NSBanner * banner = (NSBanner *)obj;
            
            [bannerAry1 addObject:banner.titleImageUrl];
            
        }
        [self addHeaderViewWithImageArray:bannerAry1];
    }else{
        _scrollView.hidden = YES;
        _page.hidden = YES;
        
    }

}

@end
