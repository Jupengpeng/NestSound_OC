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
#import "NSWriteLyricMaskView.h"
#import "NSShareViewController.h"
#import "NSLyricLibraryListModel.h"
#import "NSPublicLyricViewController.h"
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
#import "NSShareViewController.h"
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
    UITextFieldDelegate,UITextViewDelegate,lyricsDelegate,ImportLyric
>
{

    NSLyricView * lyricView;
    UITextField * titleTextFiled;
    WriteLyricBottomView * bottomView;
    UIView * maskView;
    NSWriteLyricMaskView *lexiconView;
    UICollectionView * typeCollectionView;
    NSImportLyricViewController * importLyricVC;
    NSString * url;
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
//    self.showBackBtn = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    
    
    
    lexiconView.delegate = self;
    
    //titleTextFiled
    titleTextFiled = [[UITextField alloc] init];
    titleTextFiled.textAlignment = NSTextAlignmentCenter;
    titleTextFiled.font = [UIFont systemFontOfSize:15];
    titleTextFiled.placeholder = @"请输入标题";
//    LocalizedStr(@"promot_title");
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
    lyricView = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight - 162)];
    lyricView.backgroundColor = [UIColor whiteColor];
    lyricView.lyricText.delegate = self;
    lyricView.lyricText.editable = YES;
    lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lyricView];
    
    //maskView
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    maskView.alpha = 0.5;
    maskView.backgroundColor = [UIColor lightGrayColor];
    [self.navigationController.view addSubview:maskView];
    
    lexiconView = [[NSWriteLyricMaskView alloc] initWithFrame:CGRectMake(0, maskView.height, maskView.width, 300)];
    
    [self.navigationController.view addSubview:lexiconView];
    
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
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
    
    
}

- (void)rightClick:(UIBarButtonItem *)right {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // = @{@"lyricName" : titleTextFiled.text, @"lyric" : lyricView.lyricText.text};
    
    
    if (titleTextFiled.text.length == 0) {
        [[NSToastManager manager] showtoast:@"歌词标题不能为空"];
    }else{
        if (lyricView.lyricText.text.length == 0) {
            [[NSToastManager manager] showtoast:@"歌词不能为空"];
            
        }else{
            [dict setValue:titleTextFiled.text forKey:@"lyricName"];
            
            [dict setValue:lyricView.lyricText.text forKey:@"lyric"];
            NSLog(@"dict %@",dict);
            NSPublicLyricViewController * publicVC = [[NSPublicLyricViewController alloc] initWithLyricDic:dict withType:YES];
            
            //    NSShareViewController *shareView = [[NSShareViewController alloc] init];
            //
            [self.navigationController pushViewController:publicVC animated:YES];
        
        }
    }
    
    }

- (void)tapClick {
    
    [self hiddenMaskView:YES];
}
#pragma mark -createLyricLib
-(void)hiddenMaskView:(BOOL)hidden
{
    if (hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            maskView.y = ScreenHeight;
            lexiconView.y = maskView.height;
        }];

    }else{
        [UIView animateWithDuration:0.2 animations:^{
            maskView.y = 0;
            lexiconView.y = maskView.height - 300;
            
        }];
    }
    
}

#pragma mark -push to my lyric list page
-(void)imporLyric
{
    importLyricVC = [[NSImportLyricViewController alloc] init];
    [self.navigationController pushViewController:importLyricVC animated:YES];
    importLyricVC.delegate = self;
}

#pragma mrak -view the lyricLibary view
-(void)lyricLibary
{
    
    
    
    [self hiddenMaskView:NO];
}

#pragma mark -fetchLyricLibraryData
-(void)fetchLyricLibraryData
{
    self.requestType = YES;
    NSDictionary * dic = @{@"keyword":@""};
    NSString * str = [NSTool encrytWithDic:dic];
    url = [lyricLibraryURL stringByAppendingString:str];
    self.requestURL = url;

}

#pragma mark - overrider actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        if ([operation.urlTag isEqualToString:url]) {
            NSLyricLibraryListModel * lyricLibrary = (NSLyricLibraryListModel *)parserObject;
            lexiconView.lyricLibraryListModel = lyricLibrary;
            
        }
    }
    
}


#pragma mark - push to lyric coach page
-(void)coachVC
{
    NSLyricCoachViewController * lyricCoachVC = [[NSLyricCoachViewController alloc] init];
    
    [self presentViewController:lyricCoachVC animated:YES completion:nil];
    
}

@end
