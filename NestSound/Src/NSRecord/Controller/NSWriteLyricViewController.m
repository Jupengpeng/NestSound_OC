//
//  NSWriteLyricViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSWriteLyricViewController.h"
#import "NSLyricView.h"
#import "NSImportLyricViewController.h"
#import "NSLyricCoachViewController.h"
#import "NSDrawLineView.h"

@interface WriteLyricBottomView : UIView
@property (nonatomic,strong) UIButton * importLyricBtn;
@property (nonatomic,strong) UIButton * LyricesBtn;
@property (nonatomic,strong) UIButton * cocachBtn;
@end

@implementation WriteLyricBottomView

-(instancetype)init
{
    if (self = [super init]) {
        [self configureUIAppearance];
    }
    return self;
}


-(void)configureUIAppearance
{
    
    self.backgroundColor = [UIColor whiteColor];
    _importLyricBtn = [UIButton buttonWithType:UIButtonTypeCustom
                                    configure:^(UIButton *btn) {
                                        
                                        [btn setImage:[UIImage imageNamed:@"2.0_importLyric_btn"] forState:UIControlStateNormal];
                                        [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 0)];
                                        [btn setTitle:@"导入歌词" forState:UIControlStateNormal];
                                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                        
                                    }      action:^(UIButton *btn) {
                                        
                                    }];
    
    [self addSubview:_importLyricBtn];
    
    _LyricesBtn = [UIButton buttonWithType:UIButtonTypeCustom
                                configure:^(UIButton *btn) {
                                    [btn setImage:[UIImage imageNamed:@"2.0_lyricLibrary_btn"] forState:UIControlStateNormal];
                                    [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 10)];
                                    [btn setTitle:@"词库" forState:UIControlStateNormal];
                                    [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
                                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                    
                                }
                                   action:^(UIButton *btn) {
                                       
                                   }];
    [self addSubview:_LyricesBtn];
    
    _cocachBtn = [UIButton buttonWithType:UIButtonTypeCustom
                               configure:^(UIButton *btn) {
                                   [btn setImage:[UIImage imageNamed:@"2.0_coach_btn"] forState:UIControlStateNormal];
                                   [btn setTitle:@"教程" forState:UIControlStateNormal];
                                   [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 0)];
                                   [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                               }
                                  action:^(UIButton *btn) {
                                      
                                      
                                  }];
    [self addSubview:_cocachBtn];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //constraints
    [_importLyricBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(ScreenWidth/3);
    }];
    
    [_LyricesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(_importLyricBtn.mas_right);
       make.width.mas_equalTo(ScreenWidth/3);
    }];
    
    [_cocachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(_LyricesBtn.mas_right);
        make.width.mas_equalTo(ScreenWidth/3);
    }];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ref = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    
    for (int i =1; i<=2; i++) {
        [path moveToPoint:CGPointMake(ScreenWidth/3*i, 0)];
        [path addLineToPoint:CGPointMake(ScreenWidth/3*i, self.bounds.size.height)];
    }
    
    [[UIColor hexColorFloat:@"eeeeee"] setStroke];
    [path setLineWidth:1];
    
    CGContextAddPath(ref, path.CGPath);
    CGContextStrokePath(ref);
    
}

@end


@interface NSWriteLyricViewController ()<
    UITextFieldDelegate
>
{

    NSLyricView * lyricView;
    UITextField * titleTextFiled;
    WriteLyricBottomView * bottomView;
    UIView * maskView;
    UICollectionView * typeCollectionView;
}

@end



@implementation NSWriteLyricViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
    
}

#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    //nav
    self.showBackBtn = YES;
    
    
    
    //titleTextFiled
    titleTextFiled = [[UITextField alloc] init];
    titleTextFiled.textAlignment = NSTextAlignmentCenter;
    titleTextFiled.font = [UIFont systemFontOfSize:15];
    titleTextFiled.placeholder = LocalizedStr(@"promot_title");
    titleTextFiled.borderStyle = UITextBorderStyleNone;
    titleTextFiled.delegate = self;
    [self.view addSubview:titleTextFiled];
    
    NSDrawLineView * line = [[NSDrawLineView alloc] init];
    [self.view addSubview:line];
    
    //bottomView
    bottomView = [[WriteLyricBottomView alloc] init];
    [self.view addSubview:bottomView];
    
    [bottomView.importLyricBtn addTarget:self action:@selector(imporLyric) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView.LyricesBtn addTarget:self action:@selector(lyricLibary) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.cocachBtn addTarget:self action:@selector(coachVC) forControlEvents:UIControlEventTouchUpInside];

    //lyricView
    lyricView = [[NSLyricView alloc] init];
    lyricView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lyricView];
    
    
    
    maskView = [[UIView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:maskView];
    maskView.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideenMaskView)];
    [maskView addGestureRecognizer:tap];
   
    
    //constraints
    [titleTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(19);
        make.right.equalTo(self.view.mas_right).with.offset(-58);
        make.left.equalTo(self.view.mas_left).with.offset(58);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(50);
        make.right.equalTo(self.view.mas_right).with.offset(-50);
        make.top.equalTo(titleTextFiled.mas_bottom).with.offset(5);
        make.height.mas_equalTo(1);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(52);
    }];
    
    [lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTextFiled.mas_bottom).with.offset(12);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
}



-(void)craeteLyricLib
{
    
    
}

#pragma mark -push to my lyric list page
-(void)imporLyric
{
    NSImportLyricViewController * importLyricVC = [[NSImportLyricViewController alloc] init];
    [self.navigationController pushViewController:importLyricVC animated:YES];
    
}


#pragma mrak -view the lyricLibary view
-(void)lyricLibary
{
    maskView.hidden = NO;
}




#pragma mark - push to lyric coach page
-(void)coachVC
{
    NSLyricCoachViewController * lyricCoachVC = [[NSLyricCoachViewController alloc] init];
    [self.navigationController pushViewController:lyricCoachVC animated:YES];
}

@end
