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
#import <AVFoundation/AVFoundation.h>
#import "HudView.h"
extern NSString *mp3PathTTest;
extern Boolean plugedHeadset;

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
    UILabel *placeholderLabel;
    NSString * titleImageURL;
    NSString * getQiNiuURL;
    
    UIButton *auditionBtn;
    UILabel *auditionLabel;
    
    NSString *mp3URL;
    NSString *oldMp3URL;

}
@property (nonatomic,copy) NSString * titleImage;
@property (nonatomic, strong) AVPlayerItem *musicItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, weak) UIBarButtonItem *btn;
@property (nonatomic, strong)UIAlertController* alertView;
@property (nonatomic, strong)NSShareViewController * shareVC;
@end

@implementation NSPublicLyricViewController

-(instancetype)initWithLyricDic:(NSMutableDictionary *)LyricDic_ withType:(BOOL)isLyric_
{
    if (self = [super init]) {
        lyricDic = [NSMutableDictionary dictionary];
        lyricDic = LyricDic_;
        self.isLyric = isLyric_;
        mp3URL = lyricDic[@"mp3URL"];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"----------self.mp3File = %@",self.mp3File);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];
    [self configureUIAppearance];
    self.titleImage = [lyricDic[@"lyricImgUrl"] substringFromIndex:22];
   

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    [self.view addGestureRecognizer:tap];
        
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicItem];


}
- (void)receiveDictionaryData:(NSNotification*)sender{
    auditionBtn.enabled=YES;

    NSDictionary* LyricDic_ = [sender userInfo];
    
    lyricDic = [NSMutableDictionary dictionary];
    lyricDic = LyricDic_;

    mp3URL = lyricDic[@"mp3URL"];

    

}
- (void)tapClick:(UIGestureRecognizer *)tap {
    
    [descriptionText resignFirstResponder];
}

-(void)configureUIAppearance
{
    
    self.view.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(uploadPhoto:)];
    
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height * 0.5)];
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backgroundView];
    
    UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
    
    lineView0.backgroundColor = [UIColor lightGrayColor];
    
    [backgroundView addSubview:lineView0];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, backgroundView.height - 1, ScreenWidth, 0.5)];
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [backgroundView addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, backgroundView.height - 44, ScreenWidth, 0.5)];
    
    lineView1.backgroundColor = [UIColor lightGrayColor];
    
    [backgroundView addSubview:lineView1];
    
    descriptionText = [[UITextView alloc] init];
    descriptionText.font = [UIFont systemFontOfSize:15];
    descriptionText.delegate = self;
    if (lyricDic[@"lyricDetail"]!=NULL) {
        descriptionText.text = lyricDic[@"lyricDetail"];
    } else {
        
    }
    [backgroundView addSubview:descriptionText];
    
    
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 6, descriptionText.width, 15)];
    placeholderLabel.text = @"快来写一下你为什么创作这首歌吧!";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    if (lyricDic[@"lyricDetail"]!=NULL) {
        placeholderLabel.hidden = YES;
    } else {
        placeholderLabel.hidden = NO;
    }
    [placeholderLabel sizeToFit];
    
    
    [descriptionText addSubview:placeholderLabel];
    
    addTitlePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (lyricDic[@"lyricImgUrl"]!=NULL) {
        [addTitlePageBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:lyricDic[@"lyricImgUrl"]]]] forState:UIControlStateNormal];
    } else {
    [addTitlePageBtn setBackgroundImage:[UIImage imageNamed:@"2.0_addPhoto_btn"] forState:UIControlStateNormal];
    }
    [addTitlePageBtn addTarget:self action:@selector(addtitlePage) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:addTitlePageBtn];
    
    addTitlePageLabel = [[UILabel alloc] init];
    addTitlePageLabel.font = [UIFont systemFontOfSize:15];
    addTitlePageLabel.text = @"添加封面";
//    LocalizedStr(@"prompt_addTitlePage");
    [backgroundView addSubview:addTitlePageLabel];
    
    
    publicSwitch = [[UISwitch alloc] init];
    publicSwitch.on = YES;
    publicSwitch.tintColor = [UIColor hexColorFloat:@"ffd111"];
    publicSwitch.onTintColor = [UIColor hexColorFloat:@"ffd111"];
    [backgroundView addSubview:publicSwitch];
    
    
    if (self.isLyric) {
        
        publicStateLabel = [[UILabel alloc] init];
        publicStateLabel.font = [UIFont systemFontOfSize:15];
        publicStateLabel.text = @"是否发布";
        publicStateLabel.textAlignment = NSTextAlignmentLeft;
        //    LocalizedStr(@"prompt_publicState");
        [backgroundView addSubview:publicStateLabel];
        
        [publicStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView.mas_left).offset(15);
            make.right.equalTo(backgroundView.mas_centerX);
            make.centerY.equalTo(backgroundView.mas_bottom).offset(-22);
        }];
        
    } else {
        
        publicStateLabel = [[UILabel alloc] init];
        publicStateLabel.font = [UIFont systemFontOfSize:15];
        publicStateLabel.text = @"是否发布";
        publicStateLabel.textAlignment = NSTextAlignmentRight;
        //    LocalizedStr(@"prompt_publicState");
        [backgroundView addSubview:publicStateLabel];
        
        [publicStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(publicSwitch.mas_left).offset(-15);
            make.left.equalTo(backgroundView.mas_centerX);
            make.centerY.equalTo(backgroundView.mas_bottom).offset(-22);
        }];
        
        auditionBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
           
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_play"] forState:UIControlStateNormal];
            
            [btn setImage:[UIImage imageNamed:@"2.0_writeMusic_btn01"] forState:UIControlStateSelected];
            
        } action:nil];
       // auditionBtn.enabled=NO;
                [auditionBtn addTarget:self action:@selector(playRemoteMusic:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)playRemoteMusic:(UIButton*)btn{
    
    btn.selected = !btn.selected;

    if (btn.selected) {
        
        NSString* url = [NSString stringWithFormat:@"http://api.yinchao.cn%@",mp3URL];
                NSLog(@"-------------url = %@",url);

        
        [self listenMp3Online:url];
        
        
        
    } else {
        [self.player pause];

    }
    
}


#pragma mark -stopPlaying
- (void)endPlaying {
    
    auditionBtn.selected = NO;
    self.musicItem = nil;
    self.player =nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.musicItem=nil;
    self.player=nil;
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"lyricTitlePage.png"];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fullPath]) {
        [fm removeItemAtPath:fullPath error:nil];
    }
}

#pragma mark -uploadPhoto
-(void)uploadPhoto:(UIBarButtonItem *)btn
{
    self.btn = btn;
    
    [self.player pause];
    
    btn.enabled = NO;
    
    auditionBtn.selected = NO;
    
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"lyricTitlePage.png"];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fullPath]||lyricDic[@"lyricImgUrl"]!=NULL) {
        
        self.alertView = [UIAlertController alertControllerWithTitle:nil message:@"正在发布中，请稍后..." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:self.alertView animated:YES completion:nil];
        
        if (lyricDic[@"lyricImgUrl"] !=NULL) {
            if (self.isLyric) {
                [self publicWithType:YES];
            }else{
                [self publicWithType:NO];
            }
        } else {
            if (self.isLyric) {
                
                getQiNiuURL = [self getQiniuDetailWithType:1 andFixx:@"lyrcover"];
            }else{
                getQiNiuURL = [self getQiniuDetailWithType:1 andFixx:@"muscover"];
            }
        }
        
        
        
        
    }else{
        btn.enabled = YES;
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
            NSString *shareUrl = [NSString stringWithFormat:@"%@?id=%ld",publicLyric.publicLyricModel.shareURL,publicLyric.publicLyricModel.itemID];
            
            [lyricDic setValue: shareUrl forKeyPath:@"shareURL"];
            [lyricDic setValue:self.titleImage forKey:@"titleImageUrl"];
            [lyricDic setValue:lyricDic[@"lyric"] forKeyPath:@"desc"];
            [lyricDic setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"userName"] forKey:@"author"];
            [lyricDic setValue:mp3URL forKey:@"mp3Url"];
            
            
        }
         self.shareVC =[[NSShareViewController alloc] init];
        self.shareVC.shareDataDic = lyricDic;
        self.shareVC.lyricOrMusic = self.isLyric;
        
        
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        [manager removeItemAtPath:self.mp3File error:nil];
    }
    
    
    
}
#pragma mark -public
-(void)publicWithType:(BOOL)type
{
    self.requestType = NO;
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if (type == YES) {
        if (!self.lyricId) {
            self.requestParams = @{@"uid":JUserID,@"author":dic[@"userName"],@"title":lyricDic[@"lyricName"],@"lyrics":lyricDic[@"lyric"],@"pic":self.titleImage,@"detail":descriptionText.text,@"status":[NSNumber numberWithInt:publicSwitch.isOn],@"token":LoginToken};
        } else {
        self.requestParams = @{@"id":@(self.lyricId),@"uid":JUserID,@"author":dic[@"userName"],@"title":lyricDic[@"lyricName"],@"lyrics":lyricDic[@"lyric"],@"pic":self.titleImage,@"detail":descriptionText.text,@"status":[NSNumber numberWithInt:publicSwitch.isOn],@"token":LoginToken};
        }
        self.requestURL = publicLyricURL;
    }else{
        self.requestParams = @{@"uid":JUserID,@"author":dic[@"userName"],@"title":lyricDic[@"lyricName"],@"lyrics":lyricDic[@"lyric"],@"pic":self.titleImage,@"diyids":[NSString stringWithFormat:@"%@",descriptionText.text],@"is_issue":[NSNumber numberWithInt:publicSwitch.isOn],@"token":LoginToken,@"hotid":[NSString stringWithFormat:@"%@",lyricDic[@"itemID"]],@"mp3":mp3URL,@"useheadset":[NSString stringWithFormat:@"%@",lyricDic[@"isHeadSet"]]};
        self.requestURL = publicMusicURL;
   
    }
    
    
    
    [self.alertView dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:self.shareVC animated:YES];
    
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
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            break;
        default:
            break;
    }
    

}

#pragma mark -imagePicker
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:@"lyricTitlePage.png"];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fullPath]) {
        [fm removeItemAtPath:fullPath error:nil];
    }
    [NSTool saveImage:image withName:@"lyricTitlePage.png"];
    
    UIImage * titlepageImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    //set addtitlePageBtn backgroundImage
    [addTitlePageBtn setBackgroundImage:[titlepageImage scaleFillToSize:CGSizeMake(66, 66)] forState:UIControlStateNormal];
    
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
            if (self.isLyric) {
                [wSelf publicWithType:YES];
            }else{
                [wSelf publicWithType:NO];
            }
    
            
        } option:nil];
    }
    
    return file;
}


- (void)listenMp3Online:(NSString*)file{
    //NSString* urlString = @"http://api.yinchao.cn/uploadfiles2/2016/07/22/20160722165746979_out.mp3";

        NSURL* url = [NSURL URLWithString:file];

    if (!self.musicItem||!self.player) {
        self.musicItem = [AVPlayerItem playerItemWithURL:url];
        self.player = [AVPlayer playerWithPlayerItem:self.musicItem];
    }

    
    [self.player play];

    
    
}


@end
