//
//  NSLyricCoachViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricCoachViewController.h"

@interface NSLyricCoachViewController ()
<
UIScrollViewDelegate
>
{
    UIScrollView * coachScro;
    UIPageControl * page;
    NSMutableArray * ImageAry;
}
@end

@implementation NSLyricCoachViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
}

#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //coachScro
    coachScro = [[UIScrollView alloc] init];
    coachScro.delegate = self;
    coachScro.contentSize =CGSizeMake(ScreenWidth*ImageAry.count, ScreenHeight);
    coachScro.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:coachScro];
    
    //page
    page = [[UIPageControl alloc] init];
    page.numberOfPages = ImageAry.count;
    [self.view addSubview:page];
    
    //constarints
    [coachScro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
    }];
    
    
    
}

#pragma mark UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    page.currentPage = scrollView.contentOffset.x/ScreenWidth;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > (ImageAry.count-1)*ScreenWidth) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
