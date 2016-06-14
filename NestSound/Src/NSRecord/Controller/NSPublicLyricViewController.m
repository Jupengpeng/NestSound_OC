//
//  NSPublicLyricViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPublicLyricViewController.h"

@interface NSPublicLyricViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{

    UITextView * descriptionText;
    UIButton * addTitlePageBtn;
    UILabel * addTitlePageLabel;
    UILabel * publicStateLabel;
    UISwitch * publicSwitch;
    NSMutableDictionary * lyricDic;
    NSString * description;
    UIActionSheet * chosePhotoLibrary;
    UIImagePickerController * picker;
    BOOL isLyric;
    UILabel *placeholderLabel;
}
@end

@implementation NSPublicLyricViewController

-(instancetype)initWithLyricDic:(NSMutableDictionary *)LyricDic_ withType:(BOOL)isLyric_
{
    if (self = [super init]) {
        
        lyricDic = LyricDic_;
        isLyric = isLyric_;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
    
}

-(void)configureUIAppearance
{
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //nav
//    self.showBackBtn = YES;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height * 0.5)];
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backgroundView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, backgroundView.height - 1, ScreenWidth, 1)];
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [backgroundView addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, backgroundView.height - 44, ScreenWidth, 1)];
    
    lineView1.backgroundColor = [UIColor lightGrayColor];
    
    [backgroundView addSubview:lineView1];
    
    descriptionText = [[UITextView alloc] init];
    descriptionText.font = [UIFont systemFontOfSize:15];
    descriptionText.delegate = self;
    [backgroundView addSubview:descriptionText];
    
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 6, descriptionText.width, 15)];
    
    placeholderLabel.text = @"快来写一下你为什么创作这首歌吧!";
    [placeholderLabel sizeToFit];
    placeholderLabel.textColor = [UIColor lightGrayColor];
    
    [descriptionText addSubview:placeholderLabel];
    
    addTitlePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addTitlePageBtn setBackgroundImage:[UIImage imageNamed:@"2.0_addPhoto_btn"] forState:UIControlStateNormal];
    [addTitlePageBtn addTarget:self action:@selector(addtitlePage) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:addTitlePageBtn];
    
    addTitlePageLabel = [[UILabel alloc] init];
    addTitlePageLabel.font = [UIFont systemFontOfSize:15];
    addTitlePageLabel.text = LocalizedStr(@"prompt_addTitlePage");
    [backgroundView addSubview:addTitlePageLabel];
    
    publicStateLabel = [[UILabel alloc] init];
    publicStateLabel.font = [UIFont systemFontOfSize:15];
    publicStateLabel.text = LocalizedStr(@"prompt_publicState");
    [backgroundView addSubview:publicStateLabel];
    
    publicSwitch = [[UISwitch alloc] init];
    publicSwitch.on = YES;
    publicSwitch.tintColor = [UIColor hexColorFloat:@"ffd111"];
    publicSwitch.onTintColor = [UIColor hexColorFloat:@"ffd111"];
    [backgroundView addSubview:publicSwitch];
    
    picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    chosePhotoLibrary = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedStr(@"prompt_cancel") destructiveButtonTitle:nil otherButtonTitles:LocalizedStr(@"prompt_takePhoto"),LocalizedStr(@"prompt_photoLibary"),nil];
    
    
    //constraints
    [addTitlePageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView.mas_left).offset(15);
        make.bottom.equalTo(lineView1.mas_top).offset(-10);
        make.height.mas_equalTo(66);
        make.width.mas_equalTo(66);
    }];
    
    [descriptionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView.mas_left).with.offset(15);
        make.right.equalTo(backgroundView.mas_right).with.offset(-15);
        make.top.equalTo(backgroundView.mas_top).with.offset(15);
        make.bottom.equalTo(addTitlePageBtn.mas_top).offset(-10);
    }];
    
    [addTitlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addTitlePageBtn.mas_centerY);
        make.left.equalTo(addTitlePageBtn.mas_right).with.offset(17);
    }];
    
    [publicStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView.mas_left).offset(15);
        make.right.equalTo(backgroundView.mas_centerX);
        make.center.equalTo(backgroundView.mas_bottom).offset(-22);
    }];
    
    [publicSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(-15);
        make.centerY.equalTo(backgroundView.mas_bottom).offset(-22);
    
    }];
}

-(void)addtitlePage
{

    [chosePhotoLibrary showInView:self.view];
}

#pragma mark -actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            break;
    }
    [self presentViewController:picker animated:YES completion:^{

    }];

}

#pragma mark -imagePicker
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [NSTool saveImage:image withName:@"lyricTitlePage.png"];
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"lyricTitlePage.png"];
    UIImage * titlepageImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    //set addtitlePageBtn backgroundImage
    [addTitlePageBtn setBackgroundImage:titlepageImage forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length != 0) {
        
        placeholderLabel.hidden = YES;
    } else {
        
        placeholderLabel.hidden = NO;
    }
}

@end
