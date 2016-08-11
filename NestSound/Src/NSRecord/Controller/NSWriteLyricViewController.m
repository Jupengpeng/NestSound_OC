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
#import "NSRhymeViewController.h"
#import "NSLyricModelViewController.h"
@interface WriteLyricBottomView : UIView
@property (nonatomic,strong) UIButton * importLyricBtn;
@property (nonatomic,strong) UIButton * LyricesBtn;
@property (nonatomic,strong) UIButton * toolBtn;

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
    self.importLyricBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_importLyricBtn setImage:[UIImage imageNamed:@"2.0_importLyric_btn"] forState:UIControlStateNormal];
    _importLyricBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_importLyricBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 0)];
    [_importLyricBtn setTitle:@"导入草稿" forState:UIControlStateNormal];
    [_importLyricBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_importLyricBtn];
    
    self.LyricesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_LyricesBtn setImage:[UIImage imageNamed:@"2.0_lyricModel_btn"] forState:UIControlStateNormal];
    _LyricesBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_LyricesBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 10)];
    [_LyricesBtn setTitle:@"模版" forState:UIControlStateNormal];
    [_LyricesBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
    [_LyricesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_LyricesBtn];
    
    self.toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _toolBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_toolBtn setImage:[UIImage imageNamed:@"2.0_lyricTool_btn"] forState:UIControlStateNormal];
    [_toolBtn setTitle:@"工具箱" forState:UIControlStateNormal];
    [_toolBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 0)];
    [_toolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_toolBtn];
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
    
    [_toolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    UITextFieldDelegate,UITextViewDelegate,lyricsDelegate,ImportLyric,lyricsDelegate
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
    UIView *rhymeAndLibraryView;
    BOOL isTap;
}
@property (nonatomic,strong) UIButton * rhymeBtn;
@property (nonatomic,strong) UIButton * lyicLibrary;
@end



@implementation NSWriteLyricViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)tapClick:(UIGestureRecognizer *)tap {
    
    [lyricView.lyricText resignFirstResponder];
    
    [titleTextFiled resignFirstResponder];
}


#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    
    lexiconView.delegate = self;
    
    titleTextFiled = [[UITextField alloc] init];
    titleTextFiled.textAlignment = NSTextAlignmentCenter;
    titleTextFiled.font = [UIFont systemFontOfSize:15];
    if (self.lyricTitle.length) {
        titleTextFiled.text = self.lyricTitle;
    } else {
    titleTextFiled.placeholder = @"标  题";
    }
//    LocalizedStr(@"promot_title");
    titleTextFiled.borderStyle = UITextBorderStyleNone;
    titleTextFiled.delegate = self;
    [self.view addSubview:titleTextFiled];
    
    NSDrawLineView * line = [[NSDrawLineView alloc] init];
    [self.view addSubview:line];

    //lyricView
    lyricView = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight - 162)];
    lyricView.backgroundColor = [UIColor whiteColor];
    if (self.lyricText.length) {
        lyricView.lyricText.text = self.lyricText;
    } else {
        
    }
    lyricView.lyricText.delegate = self;
    lyricView.lyricText.editable = YES;
    lyricView.lyricText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lyricView];
    
    //maskView
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    maskView.alpha = 0.5;
    maskView.hidden = YES;
//    maskView.backgroundColor = [UIColor lightGrayColor];
    [self.navigationController.view addSubview:maskView];
    
    lexiconView = [[NSWriteLyricMaskView alloc] initWithFrame:CGRectMake(0, maskView.height, maskView.width, 300)];
    
    lexiconView.delegate = self;
    
    [self.navigationController.view addSubview:lexiconView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMaskView)];
    [maskView addGestureRecognizer:tap];
    
    rhymeAndLibraryView = [[UIView alloc] initWithFrame:CGRectMake(2*ScreenWidth/3, ScreenHeight, ScreenWidth/3, 104)];
    
    rhymeAndLibraryView.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.view addSubview:rhymeAndLibraryView];
    
    _rhymeBtn = [UIButton buttonWithType:UIButtonTypeCustom
                               configure:^(UIButton *btn) {
                                   btn.titleLabel.font = [UIFont systemFontOfSize:15];
                                   [btn setImage:[UIImage imageNamed:@"2.0_rhyme_btn"] forState:UIControlStateNormal];
                                   [btn setTitle:@"韵脚" forState:UIControlStateNormal];
                                   [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 0)];
                                   [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                               }
                                  action:^(UIButton *btn) {
                                      
                                      [self hiddenRhymeAndLibraryView];
                                      
                                      bottomView.toolBtn.selected = NO;
                                      
                                      NSRhymeViewController *rhymeVC = [[NSRhymeViewController alloc] init];
                                      
                                      [self.navigationController pushViewController:rhymeVC animated:YES];
                                      
                                  }];
    [rhymeAndLibraryView addSubview:_rhymeBtn];
    
    _lyicLibrary = [UIButton buttonWithType:UIButtonTypeCustom
                                  configure:^(UIButton *btn) {
                                      btn.titleLabel.font = [UIFont systemFontOfSize:15];
                                      [btn setImage:[UIImage imageNamed:@"2.0_lyricLibrary_btn"] forState:UIControlStateNormal];
                                      [btn setTitle:@"词库" forState:UIControlStateNormal];
                                      [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 0)];
                                      [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                  }
                                     action:^(UIButton *btn) {
                                         [self lyricLibrary];
                                     }];
    [rhymeAndLibraryView addSubview:_lyicLibrary];
    
    //bottomView
    bottomView = [[WriteLyricBottomView alloc] init];
    [self.view addSubview:bottomView];
    
    [bottomView.importLyricBtn addTarget:self action:@selector(imporLyric) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView.LyricesBtn addTarget:self action:@selector(lyricModel) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.toolBtn addTarget:self action:@selector(toolBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_rhymeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(rhymeAndLibraryView).offset(0);
        make.height.mas_equalTo(52);
    }];
    
    [_lyicLibrary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(rhymeAndLibraryView).offset(0);
        make.height.mas_equalTo(52);
    }];
}

- (void)rightClick:(UIBarButtonItem *)right {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (titleTextFiled.text.length == 0) {
        [[NSToastManager manager] showtoast:@"歌词标题不能为空"];
    }else{
        if (lyricView.lyricText.text.length == 0) {
            [[NSToastManager manager] showtoast:@"歌词不能为空"];
            
        }else{
            [dict setValue:titleTextFiled.text forKey:@"lyricName"];
            
            [dict setValue:lyricView.lyricText.text forKey:@"lyric"];
            
            [dict setValue:self.lyricDetail forKey:@"lyricDetail"];
            
            [dict setValue:self.lyricImgUrl forKey:@"lyricImgUrl"];
            
            NSPublicLyricViewController * publicVC = [[NSPublicLyricViewController alloc] initWithLyricDic:dict withType:YES];
            publicVC.lyricId = self.lyricId;
            [self.navigationController pushViewController:publicVC animated:YES];
            
        }
    }
}

#pragma mark -createLyricLib
-(void)hiddenMaskView
{
    if (isTap) {
        [self hiddenRhymeAndLibraryView];
        bottomView.toolBtn.selected = NO;
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            maskView.hidden = YES;
            lexiconView.y = maskView.height;
        }];
    }
}
- (void)hiddenRhymeAndLibraryView {
    [UIView animateWithDuration:0.2 animations:^{
        maskView.hidden = YES;
        maskView.backgroundColor = [UIColor lightGrayColor];
        rhymeAndLibraryView.y = maskView.height;
    }];
}
#pragma mark -push to my lyric list page
-(void)imporLyric
{
    importLyricVC = [[NSImportLyricViewController alloc] init];
    
    importLyricVC.delegate = self;
    
    [self.navigationController pushViewController:importLyricVC animated:YES];
    importLyricVC.delegate = self;
}

#pragma mrak -view the lyricLibary view
-(void)lyricLibrary
{
    rhymeAndLibraryView.y = maskView.height;
    bottomView.toolBtn.selected = NO;
    isTap = NO;
    [self fetchLyricLibraryData];
    [UIView animateWithDuration:0.2 animations:^{
        maskView.hidden = NO;
        maskView.backgroundColor = [UIColor lightGrayColor];
        lexiconView.y = maskView.height - 300;
    }];
//    [self hiddenMaskView:NO];
}

#pragma mark -fetchLyricLibraryData
-(void)fetchLyricLibraryData
{
    self.requestType = YES;
    NSDictionary * dic = @{@"token":LoginToken};
    NSString * str = [NSTool encrytWithDic:dic];
    url = [lyricLibraryURL stringByAppendingString:str];
    self.requestURL = url;
    
}
#pragma mark - push to NSLyricModelViewController
- (void)lyricModel {
    NSLyricModelViewController *lyricModelVC = [[NSLyricModelViewController alloc] init];
    
    [self.navigationController pushViewController:lyricModelVC animated:YES];
}
#pragma mark - overrider actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                NSLyricLibraryListModel * lyricLibrary = (NSLyricLibraryListModel *)parserObject;
                lexiconView.lyricLibraryListModel = lyricLibrary;
            }
        }
    }
}


#pragma mark - push to lyric coach page
-(void)toolBtnEvent:(UIButton *)sender
{
    isTap = YES;
    if (sender.selected) {
        
        [self hiddenRhymeAndLibraryView];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            maskView.hidden = NO;
            maskView.backgroundColor = [UIColor clearColor];
            rhymeAndLibraryView.y = ScreenHeight - rhymeAndLibraryView.height - 52;
        }];
    }
    sender.selected = !sender.selected;
//    NSLyricCoachViewController * lyricCoachVC = [[NSLyricCoachViewController alloc] init];
//    
//    [self presentViewController:lyricCoachVC animated:YES completion:nil];
    
}

- (void)selectedlrcString:(NSString *)lrcString_ {
    
    lyricView.lyricText.text = [lyricView.lyricText.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",lrcString_]];
}

- (void)selectLyric:(NSString *)lyrics withMusicName:(NSString *)musicName {
    
    titleTextFiled.text = musicName;
    
    lyricView.lyricText.text = lyrics;
}

@end
