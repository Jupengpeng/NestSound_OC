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
#import "NSTemplateViewController.h"
#import "NSDraftListViewController.h"
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    //constraints
  


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
    UITextFieldDelegate,UITextViewDelegate,lyricsDelegate,ImportLyric,lyricsDelegate,UIAlertViewDelegate, NSDraftListViewControllerDelegate
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
    NSString *draftText;
    NSString *drafttitle;
}
@property (nonatomic,strong) UIButton * rhymeBtn;
@property (nonatomic,strong) UIButton * lyicLibrary;

@property (nonatomic,strong) UIButton *guideCaoGaoButton;

@property (nonatomic,strong) UIButton *guideToolButton;



@end



@implementation NSWriteLyricViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    [self.view addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self setupGuideView];

}


- (void)leftBackClick {
    
    if (titleTextFiled.text.length || lyricView.lyricText.text.length) {
        if ([lyricView.lyricText.text isEqualToString:draftText] && [titleTextFiled.text isEqualToString:drafttitle]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否保存到草稿箱" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"保存", nil];
        [alert show];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**
 *  抠圆
 */
- (void)setupRoundMaskToButton:(UIButton *)button withPoint:(CGPoint)point radius:(CGFloat)radius{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path = path.CGPath;
    
    [button.layer setMask:shapeLayer];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
        {
//            self.requestParams = @{kIsLoadingMore:@(NO)};
            self.requestType = NO;
            self.requestParams = @{@"title":titleTextFiled.text,@"draftdesc":@"",@"content":lyricView.lyricText.text,@"uid":@([JUserID integerValue]),@"token":LoginToken};
            NSString * str = [NSTool encrytWithDic:self.requestParams];
            self.requestURL = [saveDraftUrl stringByAppendingString:str];
            
        }
            break;
        default:
            break;
    }
}
- (void)tapClick:(UIGestureRecognizer *)tap {
    
    [lyricView.lyricText resignFirstResponder];
    
    [titleTextFiled resignFirstResponder];
}


#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBackClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    
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
    lyricView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    lyricView.lyricText.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    if (self.lyricText.length) {
        lyricView.lyricText.text = self.lyricText;
    } else {
        
    }
    lyricView.lyricText.autoAdaptKeyboard = YES;
    lyricView.lyricText.alwaysBounceVertical = YES;
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
    UIView *midView = [UIView new];
    
    midView.backgroundColor = KBackgroundColor;
    
    [rhymeAndLibraryView addSubview:midView];
    
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
    
    [bottomView.LyricesBtn addTarget:self action:@selector(lyricTemplate) forControlEvents:UIControlEventTouchUpInside];
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
        make.height.mas_equalTo(51);
    }];
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_rhymeBtn.mas_bottom).offset(0);
        
        make.left.right.equalTo(rhymeAndLibraryView).offset(0);
        
        make.height.mas_equalTo(1);
        
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
            publicVC.aid = self.aid;
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
        maskView.backgroundColor = [UIColor lightGrayColor];
        maskView.hidden = YES;
        rhymeAndLibraryView.y = maskView.height;
    }];
}
#pragma mark -push to my lyric list page
-(void)imporLyric
{
    /**
     倒入草稿
          */
    NSDraftListViewController *draftListVC = [[NSDraftListViewController alloc] init];
    
    draftListVC.delegate = self;
    
    [self.navigationController pushViewController:draftListVC animated:YES];
    
//    importLyricVC = [[NSImportLyricViewController alloc] init];
//    
//    importLyricVC.delegate = self;
//    
//    [self.navigationController pushViewController:importLyricVC animated:YES];
//    importLyricVC.delegate = self;
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
- (void)lyricTemplate {
    
    NSTemplateViewController *templateVC = [[NSTemplateViewController alloc] init];
    
    [self.navigationController pushViewController:templateVC animated:YES];
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
            } else {
                [[NSToastManager manager] showtoast:@"保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
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
            maskView.backgroundColor = [UIColor clearColor];
            maskView.hidden = NO;
            rhymeAndLibraryView.y = ScreenHeight - rhymeAndLibraryView.height - 52;
        }];
    }
    sender.selected = !sender.selected;
//    NSLyricCoachViewController * lyricCoachVC = [[NSLyricCoachViewController alloc] init];
//    
//    [self presentViewController:lyricCoachVC animated:YES completion:nil];
    
}
#pragma mark ImportLyric
- (void)selectedlrcString:(NSString *)lrcString_ {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
//    paragraphStyle.lineSpacing = 4;
    paragraphStyle.paragraphSpacing = 8;
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    lyricView.lyricText.attributedText = [[NSAttributedString alloc] initWithString:[lyricView.lyricText.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",lrcString_]] attributes:attributes];
    
}
#pragma mark -  NSDraftListViewControllerDelegate
-(void)selectDraft:(NSString *)draft withDraftTitle:(NSString *)draftTitle {
    
    titleTextFiled.text = draftTitle;
    
    lyricView.lyricText.text = draft;
    
    draftText = draft;
    
    drafttitle = draftTitle;
}
- (void)selectLyric:(NSString *)lyrics withMusicName:(NSString *)musicName {
    
    titleTextFiled.text = musicName;
    
    lyricView.lyricText.text = lyrics;
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView.text.length < 1) {
        textView.text = @"间距";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    paragraphStyle.paragraphSpacing = 8;
//    paragraphStyle.lineSpacing = 4;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    if ([textView.text isEqualToString:@"间距"]) {           //之所以加这个判断是因为再次编辑的时候还会进入这个代理方法，如果不加，会把你之前输入的内容清空。你也可以取消看看效果。
        textView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];//主要是把“间距”两个字给去了。
    }
    return YES;
}




- (void)setupGuideView{
    BOOL isLyricInited = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLyricInited"];
    if (!isLyricInited) {
        if (bottomView.importLyricBtn.imageView.frame.size.width) {
            [self.navigationController.view addSubview:self.guideCaoGaoButton];
            [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"isLyricInited"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        
    }
}
#pragma mark - lazy init

- (UIButton *)guideCaoGaoButton{
    if (!_guideCaoGaoButton) {
        _guideCaoGaoButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            btn.backgroundColor = [UIColor colorWithRed:8/255.0 green:4/255.0 blue:3/255.0 alpha:0.6];
            CGFloat imageWidth = ScreenWidth - 110;
            CGFloat imageHeight = imageWidth * 192/234;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, ScreenHeight - 30 - imageHeight, imageWidth, imageHeight)];
            imageView.image = [UIImage imageNamed:@"guide_caogao"];
            [btn addSubview:imageView];
            CGFloat imagePointX = bottomView.importLyricBtn.imageView.width/2.0 + bottomView.importLyricBtn.imageView.x;
            
            [self setupRoundMaskToButton:btn withPoint:CGPointMake(imagePointX, ScreenHeight - 26) radius:16];
            
        } action:^(UIButton *btn) {
            
            [btn removeFromSuperview];
            [self.navigationController.view addSubview:self.guideToolButton];
        }];
    }
    return _guideCaoGaoButton;
}

- (UIButton *)guideToolButton{
    if (!_guideToolButton) {
        _guideToolButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            btn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            btn.backgroundColor = [UIColor colorWithRed:8/255.0 green:4/255.0 blue:3/255.0 alpha:0.6];
            CGFloat imagePointX = bottomView.toolBtn.imageView.width/2.0 + bottomView.toolBtn.imageView.x + ScreenWidth*2/3.0;;

            
            CGFloat imageMaxX = ScreenWidth/3 - bottomView.toolBtn.imageView.x + 5;
            CGFloat imageWidth = ScreenWidth -  140;
            CGFloat imageHeight = imageWidth * 442/415;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - imageMaxX - imageWidth, ScreenHeight - 30 - imageHeight, imageWidth, imageHeight)];
            imageView.image = [UIImage imageNamed:@"guide_gongju"];
            [btn addSubview:imageView];
            
            [self setupRoundMaskToButton:btn withPoint:CGPointMake(imagePointX, ScreenHeight - 26) radius:16];

            
            
        } action:^(UIButton *btn) {
            [btn removeFromSuperview];
        }];
    }
    return _guideToolButton;
}

//- (void)textViewDidChange:(UITextView *)textView {
//    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n", _messageModel.title, _messageModel.date, _messageModel.content];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textView.text];
    
    //设置字体
//    [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGB(0x333333)} range:NSMakeRange(0, _messageModel.title.length + 1)];
//    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} range:NSMakeRange(_messageModel.title.length + 1, _messageModel.date.length + 1)];
    //设置段落格式
//    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
//    [paragraphStyle1 setParagraphSpacing:8];
//    [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle1} range:NSMakeRange(0, _messageModel.title.length + _messageModel.date.length + 2)];
    
    //设置字体
//    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(_messageModel.title.length + _messageModel.date.length + 2, _messageModel.content.length + 1)];
    //设置段落格式
//    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle2 setLineSpacing:6];
//    [paragraphStyle2 setFirstLineHeadIndent:20];
//    [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle2} range:NSMakeRange(_messageModel.title.length + _messageModel.date.length + 2, _messageModel.content.length + 1)];
    
//    self.textView.attributedText = attributedString;
//}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
////    if ([text isEqualToString:@"\n"]) {
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        
//        paragraphStyle.alignment = NSTextAlignmentCenter;
//        
////        paragraphStyle.lineSpacing = 2;// 字体的行间距
//    paragraphStyle.paragraphSpacing = 8;
//    
//        NSDictionary *attributes = @{
//                                     
//                                     NSFontAttributeName:[UIFont systemFontOfSize:15],
//                                     
//                                     NSParagraphStyleAttributeName:paragraphStyle
//                                     
//                                     };
//        
//        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
////    }
//    return YES;
//}

@end
