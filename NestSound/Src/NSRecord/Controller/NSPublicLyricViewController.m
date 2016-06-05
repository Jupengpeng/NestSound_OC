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
    self.showBackBtn = YES;
    
    descriptionText = [[UITextView alloc] init];
    descriptionText.font = [UIFont systemFontOfSize:15];
    descriptionText.delegate = self;
    [self.view addSubview:descriptionText];
    
    addTitlePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addTitlePageBtn addTarget:self action:@selector(addtitlePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addTitlePageBtn];
    
    addTitlePageLabel = [[UILabel alloc] init];
    addTitlePageLabel.font = [UIFont systemFontOfSize:15];
    addTitlePageLabel.text = LocalizedStr(@"prompt_addTitlePage");
    [self.view addSubview:addTitlePageLabel];
    
    publicStateLabel = [[UILabel alloc] init];
    publicStateLabel.font = [UIFont systemFontOfSize:15];
    publicStateLabel.text = LocalizedStr(@"prompt_publicState");
    [self.view addSubview:publicStateLabel];
    
    publicSwitch = [[UISwitch alloc] init];
    publicSwitch.on = YES;
    publicSwitch.tintColor = [UIColor hexColorFloat:@"ffd111"];
    [self.view addSubview:publicSwitch];
    
    picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    chosePhotoLibrary = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedStr(@"prompt_cancel") destructiveButtonTitle:nil otherButtonTitles:LocalizedStr(@"prompt_takePhoto"),LocalizedStr(@"prompt_photoLibary"),nil];
    
    
    //constraints
    [descriptionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.top.equalTo(self.view.mas_top).with.offset(15);
        make.height.mas_equalTo(125);
    }];
    
    [addTitlePageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descriptionText.mas_left);
        make.top.equalTo(descriptionText.mas_top).with.offset(10);
        make.height.mas_equalTo(66);
        make.width.mas_equalTo(66);
    }];
    
    [addTitlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addTitlePageBtn.mas_centerY);
        make.left.equalTo(addTitlePageBtn.mas_right).with.offset(17);
    }];
    
    [publicStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addTitlePageBtn.mas_left);
    }];

    [publicSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        
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

@end
