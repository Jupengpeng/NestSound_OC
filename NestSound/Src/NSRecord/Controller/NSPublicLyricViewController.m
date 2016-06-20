//
//  NSPublicLyricViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPublicLyricViewController.h"
#import "NSGetQiNiuModel.h"
#import "NSPublicLyricModel.h"
#import "NSShareViewController.h"
#import "NSPlayMusicTool.h"

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
    NSString * titleImageURL;
    NSString * getQiNiuURL;
    
    UIButton *auditionBtn;
    UILabel *auditionLabel;
    
    NSString *mp3URL;
}
@property (nonatomic,copy) NSString * titleImage;
@property (nonatomic, strong) AVPlayerItem *musicItem;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation NSPublicLyricViewController

-(instancetype)initWithLyricDic:(NSMutableDictionary *)LyricDic_ withType:(BOOL)isLyric_
{
    if (self = [super init]) {
        
        lyricDic = [NSMutableDictionary dictionaryWithDictionary:LyricDic_];
        isLyric = isLyric_;
        mp3URL = lyricDic[@"mp3URL"];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIAppearance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
}

-(void)configureUIAppearance
{
    WS(wSelf);
    
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(uploadPhoto)];
    
    //nav
//    self.showBackBtn = YES;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height * 0.5)];
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backgroundView];
    
    UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    
    lineView0.backgroundColor = [UIColor lightGrayColor];
    
    [backgroundView addSubview:lineView0];

    
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
    addTitlePageLabel.text = @"添加封面";
//    LocalizedStr(@"prompt_addTitlePage");
    [backgroundView addSubview:addTitlePageLabel];
    
    if (isLyric) {
        
        publicStateLabel = [[UILabel alloc] init];
        publicStateLabel.font = [UIFont systemFontOfSize:15];
        publicStateLabel.text = @"是否发布";
        //    LocalizedStr(@"prompt_publicState");
        [backgroundView addSubview:publicStateLabel];
        
        [publicStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView.mas_left).offset(15);
            make.right.equalTo(backgroundView.mas_centerX);
            make.centerY.equalTo(backgroundView.mas_bottom).offset(-22);
        }];
        
    } else {
        
        auditionBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
           
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_play"] forState:UIControlStateNormal];
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_btn01"] forState:UIControlStateSelected];
            
        } action:^(UIButton *btn) {
            
            btn.selected = !btn.selected;
            
            if (btn.selected) {
                
                wSelf.player = [NSPlayMusicTool playMusicWithUrl:[NSString stringWithFormat:@"http://112.124.125.2%@",mp3URL] block:^(AVPlayerItem *item) {
                    NSLog(@"%@",mp3URL);
                    wSelf.musicItem = item;
                    
                }];
                
                NSLog(@"%@",_player);
                
            } else {
                
                [wSelf.player pause];
            }
            
        }];
        
        [backgroundView addSubview:auditionBtn];
        
        
        [auditionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView.mas_left).offset(15);
            
            make.centerY.equalTo(backgroundView.mas_bottom).offset(-22);
        }];
        
        
        auditionLabel = [[UILabel alloc] init];
        
        auditionLabel.text = @"试听";
        
        [auditionBtn sizeToFit];
        
        [backgroundView addSubview:auditionLabel];
        
        [auditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(auditionBtn.mas_right).offset(15);
            
            make.centerY.equalTo(backgroundView.mas_bottom).offset(-22);
        }];
    }
    
   
    
    publicSwitch = [[UISwitch alloc] init];
    publicSwitch.on = YES;
    publicSwitch.tintColor = [UIColor hexColorFloat:@"ffd111"];
    publicSwitch.onTintColor = [UIColor hexColorFloat:@"ffd111"];
    [backgroundView addSubview:publicSwitch];
    
    picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    chosePhotoLibrary = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册",nil];
    
    
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
    
   
    
    [publicSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(-15);
        make.centerY.equalTo(backgroundView.mas_bottom).offset(-22);
    
    }];
}


#pragma mark -stopPlaying
- (void)endPlaying {
    
    auditionBtn.selected = NO;
    
    self.player = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"lyricTitlePage.png"];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fullPath]) {
        [fm removeItemAtPath:fullPath error:nil];
    }
}

#pragma mark -uploadPhoto
-(void)uploadPhoto
{
  
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"lyricTitlePage.png"];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fullPath]) {
        if (descriptionText.text.length == 0) {
            [[NSToastManager manager ] showtoast:@"描述不能为空哦"];
        }else{
            if (isLyric) {
                getQiNiuURL = [self getQiniuDetailWithType:1 andFixx:@"lyrcover"];
            }else{
                getQiNiuURL = [self getQiniuDetailWithType:1 andFixx:@"muscover"];
            }
        }
        
    }else{
        [[NSToastManager manager] showtoast:@"封面不能为空哟"];
    }
    
   
    
}

#pragma mark -override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        
        if ([operation.urlTag isEqualToString:getQiNiuURL]) {
            
            NSGetQiNiuModel * GetqiNiuModel = (NSGetQiNiuModel *)parserObject;
            qiNiu * data = GetqiNiuModel.qiNIuModel;
            NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"lyricTitlePage.png"];
            titleImageURL = [self uploadPhotoWith:fullPath type:YES token:data.token url:data.qiNIuDomain];
            
        }else if ([operation.urlTag isEqualToString:publicLyricURL] || [operation.urlTag isEqualToString:publicMusicURL]){
            NSPublicLyricModel * publicLyric = (NSPublicLyricModel *)parserObject;
            [lyricDic setObject:publicLyric.publicLyricModel.shareURL forKey:@"shareURL"];
            [lyricDic setObject:descriptionText.text forKey:@"desc"];
            NSShareViewController * shareVC =[[NSShareViewController alloc] init];
            shareVC.shareDataDic = lyricDic;
            [self.navigationController pushViewController:shareVC animated:YES];
        }
        
    }
    
}
#pragma mark -public
-(void)publicWithType:(BOOL)type
{
    self.requestType = NO;
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if (type == YES) {
        self.requestParams = @{@"uid":JUserID,@"author":dic[@"userName"],@"title":lyricDic[@"lyricName"],@"lyrics":lyricDic[@"lyric"],@"pic":self.titleImage,@"detail":descriptionText.text,@"status":[NSNumber numberWithInt:publicSwitch.isOn],@"token":LoginToken};
        self.requestURL = publicLyricURL;
    }else{
         self.requestParams = @{@"uid":JUserID,@"author":dic[@"userName"],@"title":lyricDic[@"lyricName"],@"lyrics":lyricDic[@"lyric"],@"pic":self.titleImage,@"diyids":descriptionText.text,@"is_issue":[NSNumber numberWithInt:publicSwitch.isOn],@"token":LoginToken,@"hotid":lyricDic[@"itemID"],@"mp3":mp3URL,@"useheadset":lyricDic[@"isHeadset"]};
        self.requestURL = publicMusicURL;
   
    }
    
}

#pragma mark -addtitlePage
-(void)addtitlePage
{
    [descriptionText resignFirstResponder];
    
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
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"lyricTitlePage.png"];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fullPath]) {
        [fm removeItemAtPath:fullPath error:nil];
    }
    [NSTool saveImage:image withName:@"lyricTitlePage.png"];
    
    UIImage * titlepageImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    //set addtitlePageBtn backgroundImage
    [addTitlePageBtn setBackgroundImage:titlepageImage forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark -placeHolder
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length != 0) {
        
        placeholderLabel.hidden = YES;
    } else {
        
        placeholderLabel.hidden = NO;
    }
}


#pragma mark -uploadPhoto
-(NSString *)uploadPhotoWith:(NSString *)photoPath type:(BOOL)type_ token:(NSString *)token url:(NSString *)url
{
   
    WS(wSelf);
    __block NSString * file = titleImageURL;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:photoPath]) {
        QNUploadManager * upManager = [[QNUploadManager alloc] init];
        NSData * imageData = [NSData dataWithContentsOfFile:photoPath];
        [upManager putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            wSelf.titleImage = [NSString stringWithFormat:@"%@",[resp objectForKey:@"key"]];
            if (isLyric) {
                [wSelf publicWithType:YES];
            }else{
                [wSelf publicWithType:NO];
            }
            
        } option:nil];
    }
    
    return file;
}


@end
