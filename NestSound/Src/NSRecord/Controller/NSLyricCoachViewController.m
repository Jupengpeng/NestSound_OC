//
//  NSLyricCoachViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricCoachViewController.h"

@interface NSLyricCoachViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *coachScrollView;

@property (nonatomic, strong) UIPageControl *page;
@end

@implementation NSLyricCoachViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coachScrollView = [[UIScrollView alloc] init];
    
    self.coachScrollView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.coachScrollView setContentSize:CGSizeMake(self.coachScrollView.frame.size.width * 3, [UIScreen mainScreen].bounds.size.height-20)];
    
    self.coachScrollView.pagingEnabled = YES;
    
    self.coachScrollView.delegate = self;
    
    self.coachScrollView.showsHorizontalScrollIndicator = NO;
    
    self.coachScrollView.bounces = NO;
    
    [self.view addSubview:self.coachScrollView];
    
    UIImageView *_page1=[[UIImageView alloc]init];
    _page1.clipsToBounds=YES;
    _page1.contentMode=UIViewContentModeScaleAspectFill;
    _page1.image=[UIImage imageNamed:@"2.0_coach00"];
    _page1.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.coachScrollView addSubview:_page1];
    
    
    UIImageView *_page2=[[UIImageView alloc]init];
    _page2.clipsToBounds=YES;
    _page2.contentMode=UIViewContentModeScaleAspectFill;
    _page2.image=[UIImage imageNamed:@"2.0_coach01"];
    _page2.frame=CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.coachScrollView addSubview:_page2];
    
    UIImageView *_page3=[[UIImageView alloc]init];
    _page3.image=[UIImage imageNamed:@"2.0_coach02"];
    _page3.contentMode=UIViewContentModeScaleAspectFill;
    _page3.frame=CGRectMake([UIScreen mainScreen].bounds.size.width*2, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.coachScrollView addSubview:_page3];
    
    
    UIPageControl *page = [[UIPageControl alloc] init];
    
    page.numberOfPages = 3;
    
    page.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    page.currentPageIndicatorTintColor = [UIColor hexColorFloat:@"ffd705"];
    
    self.page = page;
    
    [self.view addSubview:page];
    
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    
    UIButton *page3Btn=[[UIButton alloc]init];
    [page3Btn setImage:[UIImage imageNamed:@"2.0_record_retract"] forState:UIControlStateNormal];
    [page3Btn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    page3Btn.frame=CGRectMake(15, 32, 30, 30);
        [page3Btn.layer setMasksToBounds:YES];
    [self.view addSubview:page3Btn];

    
    
}


#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.page.currentPage = self.coachScrollView.contentOffset.x / ScreenWidth;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > ScreenWidth * 3 + 50) {
        
        
    }
    
}

- (void)doBack:(UIButton *)btn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
