//
//  NSInspirationRecordViewController.m
//  NestSound
//
//  Created by Apple on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInspirationRecordViewController.h"
#import "NSLyricView.h"
#import "NSPictureCollectionView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XHSoundRecorder.h"
#import "HUImagePickerViewController.h"
#import "NSImageCell.h"
#import "NSGetQiNiuModel.h"
#import "NSInspirtationModel.h"
#import "NSPlayMusicViewController.h"
@interface NSInspirationRecordViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate> {
    
    UICollectionView *_collection;
    
    UIView *_bottomView;
    NSMutableArray * ImageArr;
    HUImagePickerViewController * ImagePicker;
    NSString * getQiniuImage;
    NSString * getQiniuAudio;
    NSString * getInspiration;
    NSGetQiNiuModel * getQiniuImageModel;
    NSGetQiNiuModel * getQiniuAudioModel;
    NSLyricView *inspiration ;
    
    long itemID;
    BOOL isWrite;
}

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, weak) UIView *recordView;

@property (nonatomic, weak) UIButton *soundBtn;

@property (nonatomic, weak) UILabel *promptLabel;

@property (nonatomic, weak) UIButton *recordBtn;

@property (nonatomic, weak) UIButton *playSongsBtn;

@property (nonatomic, weak) UIButton *deleteBtn;

@property (nonatomic, strong)  CADisplayLink *link;

@property (nonatomic, assign) CGFloat timeNum;

@property (nonatomic, assign) NSInteger totalTime;

@property (nonatomic, assign) BOOL isPlayer;

@property (nonatomic, weak) UIImageView *volume;
@property (nonatomic,copy) NSString * titleImageURL;
@property (nonatomic,copy) NSString * audioURL;
@property (nonatomic,copy) NSString * audioPath;
//录音时长
@property (nonatomic, weak) UILabel *recordDuration;
@property (nonatomic,strong) NSInspirtation * inspritationModel;
@property (nonatomic, strong) NSString *mp3FilePath;
@end
static NSString * const reuseIdentifier  = @"ReuseIdentifier";
@implementation NSInspirationRecordViewController

-(instancetype)initWithItemId:(long)itemId_ andType:(BOOL)Type_
{
    if (self = [super init]) {
        itemID = itemId_;
        isWrite = Type_;
    }
    return  self;
}

-(NSMutableArray *)ImageArr{
    if (!ImageArr) {
        ImageArr = [NSMutableArray array];
    }

    return ImageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [date datetoLongStringWithDate:[NSDate date]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    
    if (!isWrite) {
        [self fetchInspirationDataWithItemId:itemID];
    }
    [self fetchDataWithType:1];
    [self fetchDataWithType:2];
    
    
    //stop the music
    NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
    
    playVC.playOrPauseBtn.selected = NO;
    
    [playVC.player pause];
    
    
    
    [self setupUI];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
}

- (void)backClick:(UIBarButtonItem *)back {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager removeItemAtPath:self.audioPath error:nil];
    
    self.audioPath = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - getQiniuDetail
-(void)fetchDataWithType:(int)type
{
    self.requestType = YES;
    NSDictionary * dic  = @{@"type":[NSNumber numberWithInt:type],@"fixx":@"inspire"};
    NSString * str = [NSTool encrytWithDic:dic];
    if (type == 1) {
        getQiniuImage = [getQiniuDetail stringByAppendingString:str];
        self.requestURL = getQiniuImage;
    }else{
        getQiniuAudio = [getQiniuDetail stringByAppendingString:str];
        self.requestURL = getQiniuAudio;

    }
    
}

#pragma mark -fetchInspirationData
-(void)fetchInspirationDataWithItemId:(long)itemID_
{
    self.requestType = YES;
    NSDictionary * dic = @{@"id":[NSNumber numberWithLong:itemID_],@"token":LoginToken};
    NSString * str = [NSTool encrytWithDic:dic];
    getInspiration = [getInspirationURL stringByAppendingString:str];
    self.requestURL = getInspiration;

}


#pragma mark -uploadPhoto
-(void)uploadPhotoWith:(NSString *)photoPath type:(BOOL)type_ token:(NSString *)token url:(NSString *)url
{
    
    WS(wSelf);
   
    if (ImageArr.count != 0) {
        QNUploadManager * upManager = [[QNUploadManager alloc] init];
        
        for (int i = 0 ; i<ImageArr.count; ++i) {
            UIImage * image = ImageArr[i];
            NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
            [upManager putData:imageData key:[NSString stringWithFormat:@"%d.png",i] token:getQiniuImageModel.qiNIuModel.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                wSelf.titleImageURL = [wSelf.titleImageURL stringByAppendingString:[NSString stringWithFormat:@",%@",[resp objectForKey:@"key"]]];
                if (i == ImageArr.count) {
                    [wSelf uploadAudioWithImageURL:wSelf.titleImageURL];
                }
                
            } option:nil];

        }
        
    }else{
        [self uploadAudioWithImageURL:nil];
    }
    
}

#pragma mark -uploadAudio
-(void)uploadAudioWithImageURL:(NSString *)Image
{
    WS(wSelf);
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.audioPath]){
        QNUploadManager * upManager = [[QNUploadManager alloc] init];
        
        
            NSData * audioData = [NSData dataWithContentsOfFile:self.audioPath];
            [upManager putData:audioData key:[NSString stringWithFormat:@"%@",self.audioPath.lastPathComponent] token:getQiniuAudioModel.qiNIuModel.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                wSelf.audioURL = [NSString stringWithFormat:@"%@",key];
                [wSelf publicWithType:YES andAudioURL:wSelf.audioURL andImageURL:Image];
            } option:nil];
        
        
    }else{
        [self publicWithType:NO andAudioURL:nil andImageURL:Image];
    }
}


#pragma mark -public
-(void)publicWithType:(BOOL)type_ andAudioURL:(NSString *)audioURL_ andImageURL:(NSString *)imageURL_
{
    self.requestType = NO;
    if (audioURL_!= nil&&imageURL_!= nil&&inspiration.lyricText.text.length>0) {
        self.requestParams = @{@"uid":JUserID,@"token":LoginToken,@"spirecontent":inspiration.lyricText.text,@"pics":imageURL_,@"audio":audioURL_};
    }else if (audioURL_!= nil&&imageURL_== nil&&inspiration.lyricText.text.length>0){
        self.requestParams = @{@"uid":JUserID,@"token":LoginToken,@"spirecontent":inspiration.lyricText.text,@"audio":audioURL_};
    
    }else if (audioURL_== nil&&imageURL_!= nil&&inspiration.lyricText.text.length>0){
        self.requestParams = @{@"uid":JUserID,@"token":LoginToken,@"spirecontent":inspiration.lyricText.text,@"pics":imageURL_};
    }else if (audioURL_!= nil&&imageURL_!= nil&&inspiration.lyricText.text.length==0){
        self.requestParams = @{@"uid":JUserID,@"token":LoginToken,@"pics":imageURL_,@"audio":audioURL_};
    }else if (audioURL_== nil&&imageURL_== nil&&inspiration.lyricText.text.length!=0){
        self.requestParams = @{@"uid":JUserID,@"token":LoginToken,@"spirecontent":inspiration.lyricText.text};
    }
    
    self.requestURL = publicInspirationURL;
}

#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:getQiniuImage]) {
            getQiniuImageModel = (NSGetQiNiuModel *)parserObject;
            
        }else if ([operation.urlTag isEqualToString:getQiniuAudio]){
            getQiniuAudioModel = (NSGetQiNiuModel *)parserObject;
        }else if ([operation.urlTag isEqualToString:getInspiration]){
            NSInspirtationModel * inspirtation = (NSInspirtationModel *)parserObject;
            self.inspritationModel = inspirtation.inspirtationModel;
        }
        
    }else{
        if ([operation.urlTag isEqualToString:publicInspirationURL]){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if ([operation.urlTag isEqualToString:getInspiration]){
            NSInspirtationModel * insp = (NSInspirtationModel *)parserObject;
            self.inspritationModel = insp.inspirtationModel;
        
        }
    
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager removeItemAtPath:self.audioURL error:nil];
}

#pragma mark -setter && getter
-(void)setInspritationModel:(NSInspirtation *)inspritationModel
{
    _inspritationModel = inspritationModel;
    NSString * str = _inspritationModel.pics;
    NSArray * arr =[str componentsSeparatedByString:@","];
    self.title = [date datetoLongStringWithDate:_inspritationModel.createDate];
    inspiration.lyricText.text = _inspritationModel.spireContent;
    self.placeholderLabel.hidden = YES;
    ImageArr = [NSMutableArray arrayWithArray:arr];
    [_collection reloadData];

}

#pragma mark -action to notifiction
- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary *userInfo = [aNotification userInfo];

    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    WS(wSelf);
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        _bottomView.y = keyBoardEndY - _bottomView.height - 64;
        
        if (!(wSelf.recordView.y >= ScreenHeight - 64)) {
            
            wSelf.recordView.y = ScreenHeight - 64;
        }

    }];
    
    
    
}



-(void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    WS(wSelf);
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        if (wSelf.recordView.y >= ScreenHeight - 64) {
            
            _bottomView.y = keyBoardEndY - _bottomView.height - 64;
        } else {
            
            _bottomView.y = wSelf.recordView.y - _bottomView.height;
        }
        
        
    }];
    
}

- (void)setupUI {
    
    WS(wSelf);
    
    CGFloat H;
    
    if (ScreenHeight < 667) {
        
        H = 160;
    } else {
        
        H = 200;
    }
    
    
    //textView

    inspiration = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, H)];


    inspiration.lyricText.delegate = self;
    
    [self.view addSubview:inspiration];
    
    self.placeholderLabel=[[UILabel alloc]initWithFrame:CGRectMake(4, 5, ScreenHeight, 22)];
    
    self.placeholderLabel.text = @"此时此刻你最想说些什么";
    
    self.placeholderLabel.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1.f];
    
    [inspiration.lyricText addSubview:self.placeholderLabel];
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 5;
    
    layout.minimumInteritemSpacing = 20;
    
    layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
    
    CGFloat W = (self.view.width - 120) / 3;
    
    layout.itemSize = CGSizeMake(W, W);
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, H, self.view.width, W * 3 + 15) collectionViewLayout:layout];
    
    _collection.delegate = self;
    
    _collection.dataSource = self;
    
    _collection.pagingEnabled = YES;
    
    _collection.backgroundColor = [UIColor whiteColor];
    
    [_collection registerClass:[NSImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:_collection];
    
    
    
    //底部工具条View
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 124, ScreenWidth, 60)];
    
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_bottomView];
    
    
    UIView *line1 = [[UIView alloc] init];
    
    line1.backgroundColor = [UIColor lightGrayColor];
    
    [_bottomView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(_bottomView);
        
        make.height.mas_equalTo(1);
        
    }];
    
    //imagePicker
    ImagePicker = [[HUImagePickerViewController alloc] init];
    ImagePicker.delegate = self;
    ImagePicker.maxAllowSelectedCount = 9;
    
    
    //录音View
    UIView *recordView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 258)];
    
    recordView.backgroundColor = [UIColor whiteColor];
    
    self.recordView = recordView;
    
    [self.view addSubview:recordView];
    
    
    //收回录音View的按钮
    UIButton *retractBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_record_retract"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            recordView.y = ScreenHeight - 64;
            
            _bottomView.y = wSelf.recordView.y - _bottomView.height;
        }];
        
    }];
    
    [recordView addSubview:retractBtn];
    
    [retractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wSelf.recordView.mas_top).offset(15);
        
        make.centerX.equalTo(wSelf.recordView.mas_centerX);
        
    }];
    
    
    //遮罩View
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - recordView.height)];
    
    maskView.backgroundColor = [UIColor darkGrayColor];
    
    maskView.alpha = 0.5;
    
    maskView.hidden = YES;
    
    [self.navigationController.view addSubview:maskView];
    
    
    //音量大小的图片
    UIImageView *volume = [[UIImageView alloc] init];
    
    volume.contentMode = UIViewContentModeCenter;
    
    volume.image = [UIImage imageNamed:@"2.0_volume"];
    
    volume.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    volume.layer.cornerRadius = 5;
    
    volume.clipsToBounds = YES;
    
    volume.hidden = YES;
    
    self.volume = volume;
    
    [self.navigationController.view addSubview:volume];
    
    [volume mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(maskView.mas_centerX);
        
        make.centerY.equalTo(maskView.mas_centerY).offset(32);
        
        make.width.mas_equalTo(220);
        
        make.height.mas_equalTo(90);
    }];
    
    //录音时长
    UILabel *recordDuration = [[UILabel alloc] init];
    
    recordDuration.font = [UIFont systemFontOfSize:12];
    
    recordDuration.text = @"00:00";
    
    self.recordDuration = recordDuration;
    
    [volume addSubview:recordDuration];
    
    [recordDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(volume.mas_centerX);
        
        make.centerY.equalTo(volume.mas_centerY);
    }];
    
    
    //提示Label
    UILabel *promptLabel = [[UILabel alloc] init];
    
    promptLabel.textColor = [UIColor hexColorFloat:@"666666"];
    
    promptLabel.text = @"点击录音";
    
    self.promptLabel = promptLabel;
    
    [recordView addSubview:promptLabel];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(retractBtn.mas_bottom).offset(10);
        
        make.centerX.equalTo(retractBtn.mas_centerX);
        
    }];
    //录音按钮
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_record_record"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_record_recording"] forState:UIControlStateSelected];
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
        if (btn.selected) {
            
            [self.soundBtn setImage:[UIImage imageNamed:@"2.0_addedSound"] forState:UIControlStateNormal];
            
            [[XHSoundRecorder sharedSoundRecorder] startRecorder:^(NSString *filePath) {
                

                wSelf.audioPath = filePath;
                

                NSLog(@"%@",filePath);
            }];
            
            wSelf.promptLabel.text = @"点击完成";
            
            maskView.hidden = NO;
            
            volume.hidden = NO;
            
            retractBtn.userInteractionEnabled = NO;
            
            [wSelf addLink];
            
             NSLog(@"点击了录音");
        } else {
            
            [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
            
            btn.hidden = YES;
            
            wSelf.playSongsBtn.hidden = NO;
            wSelf.playSongsBtn.selected = NO;
            maskView.hidden = YES;
            
            volume.hidden = YES;
            
            self.deleteBtn.hidden = NO;
            
            retractBtn.userInteractionEnabled = YES;
            
            wSelf.promptLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)self.timeNum / 60, (NSInteger)self.timeNum % 60];
            
            wSelf.totalTime = self.timeNum;
            
            [wSelf removeLink];
            
             NSLog(@"点击了暂停录音");
        }
        
    }];
    
    self.recordBtn = recordBtn;
    
    [recordView addSubview:recordBtn];
    
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(promptLabel.mas_bottom).offset(50);
        
        make.centerX.equalTo(recordView.mas_centerX);
        
    }];
    
    
    //播放录音按钮
    UIButton *playSongsBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_record_play"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"2.0_record_stop"] forState:UIControlStateSelected];
        
        btn.hidden = YES;
        
    } action:^(UIButton *btn) {
        
        btn.selected = !btn.selected;
        
        if (btn.selected) {
            
            wSelf.isPlayer = YES;
            
            [wSelf addLink];
            
            [[XHSoundRecorder sharedSoundRecorder] playsound:nil withFinishPlaying:^{
                
                btn.selected = NO;
                
//                self.timeNum = 0;
                
                [wSelf removeLink];
            }];
            
            wSelf.promptLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",(NSInteger)self.timeNum / 60, (NSInteger)self.timeNum % 60, self.totalTime / 60, self.totalTime % 60];
            
            NSLog(@"点击了播放录音");
        } else {
            
            [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
            
            [wSelf removeLink];
            
            NSLog(@"点击了停止播放录音");
        }
        
        
    }];
    
    self.playSongsBtn = playSongsBtn;
    
    [recordView addSubview:playSongsBtn];
    
    [playSongsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(promptLabel.mas_bottom).offset(50);
        
        make.centerX.equalTo(recordView.mas_centerX);
        
    }];
    
    
    //删除录音按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
       
        [btn setImage:[UIImage imageNamed:@"2.0_record_delete"] forState:UIControlStateNormal];
        
        btn.hidden = YES;
        
    } action:^(UIButton *btn) {
        
        [wSelf.soundBtn setImage:[UIImage imageNamed:@"2.0_addSound"] forState:UIControlStateNormal];
        
        wSelf.recordBtn.hidden = NO;
        
        wSelf.playSongsBtn.hidden = YES;
        
        [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
        
        [[XHSoundRecorder sharedSoundRecorder] removeSoundRecorder];
        
        wSelf.promptLabel.text = @"点击录音";
        
        [wSelf removeLink];
        
        wSelf.isPlayer = NO;
        
        btn.hidden = YES;
        
        NSLog(@"点击了删除录音");
    }];
    
    self.deleteBtn = deleteBtn;
    
    [recordView addSubview:deleteBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(recordBtn.mas_right).offset(35);
        
        make.centerY.equalTo(recordBtn.mas_centerY);
        
    }];
    
    
    //添加照片
    UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_addPicture"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了添加照片");
        
        
        [wSelf presentViewController:ImagePicker animated:YES completion:nil];
        
        
    }];
    
    [_bottomView addSubview:pictureBtn];
    
    [pictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line1.mas_bottom).offset(15);
        
        make.left.equalTo(_bottomView.mas_left).offset(15);
        
        make.width.height.mas_equalTo(30);
        
    }];
    
    //添加录音
    UIButton *soundBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_addSound"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        [inspiration.lyricText resignFirstResponder];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            if (wSelf.recordView.y >= ScreenHeight - 64) {
                
                wSelf.recordView.y = ScreenHeight - 258 - 64;
                
                _bottomView.y = wSelf.recordView.y - _bottomView.height;
            } else {
                
                wSelf.recordView.y = ScreenHeight - 64;
                
                _bottomView.y = wSelf.recordView.y - _bottomView.height;
            }
            
        }];
        
        NSLog(@"点击了添加录音");
        
    }];
    
    self.soundBtn = soundBtn;
    
    [_bottomView addSubview:soundBtn];
    
    [soundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line1.mas_bottom).offset(15);
        
        make.left.equalTo(pictureBtn.mas_right).offset(15);
        
        make.width.height.mas_equalTo(30);
        
    }];
    
    
    UIView *line2 = [[UIView alloc] init];//]WithFrame:CGRectMake(0, ScreenHeight - (ScreenHeight - 329), ScreenWidth, 1)];
    
    line2.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(_bottomView);
        
        make.height.mas_equalTo(1);
        
    }];
    
    
}


-(void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text length] == 0) {
        
        self.placeholderLabel.hidden = NO;
        
    }else{
        
        self.placeholderLabel.hidden = YES;
    }
    
}

/**
 *  添加定时器
 */
- (void)addLink {
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionTiming)];
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

/**
 *  移除定时器
 */
- (void)removeLink {
    
    self.timeNum = 0;
    
    self.recordDuration.text = @"00:00";
    
    [self.link invalidate];
    
    self.link = nil;
}

- (void)actionTiming {
    
    self.timeNum += 1/60.0;
    
    if (self.deleteBtn.hidden) {
        
        CGFloat count = [[XHSoundRecorder sharedSoundRecorder] decibels];
        
        if (count <= -35) {
            
            self.volume.image = [UIImage imageNamed:@"2.0_volume"];
            
        } else if (count <= -25 && count >= -35) {
            
            self.volume.image = [UIImage imageNamed:@"2.0_volume1"];
            
        } else if (count <= -15 && count >= -25) {
            
            self.volume.image = [UIImage imageNamed:@"2.0_volume2"];
            
        } else if (count <= 5 && count >= 15) {
            
            self.volume.image = [UIImage imageNamed:@"2.0_volume3"];
            
        } else {
            
            self.volume.image = [UIImage imageNamed:@"2.0_volume4"];
        }
        
    }
    
    
    self.recordDuration.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)self.timeNum / 60, (NSInteger)self.timeNum % 60];
    
    if (self.isPlayer) {
        
        self.promptLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",(NSInteger)self.timeNum / 60, (NSInteger)self.timeNum % 60, self.totalTime / 60, self.totalTime % 60];
    }
    
}

#pragma mark -collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return ImageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSImageCell *cell = (NSImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (isWrite) {
       cell.image.image = ImageArr[indexPath.row];
    }else{
        [cell.image setDDImageWithURLString:[self.inspritationModel.picDomain stringByAppendingString:ImageArr[indexPath.row]] placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
    }
        
    
    return cell;
}


- (void)rightItemClick:(UIBarButtonItem *)rightItem {
    
    WS(wSelf);
    if (self.audioPath != nil) {
        [[XHSoundRecorder sharedSoundRecorder] recorderFileToMp3WithType:TrueMachine filePath:self.audioPath FilePath:^(NSString *newfilePath) {
            
            wSelf.audioPath = newfilePath;
            [wSelf uploadPhotoWith:nil type:YES token:nil url:nil];
            
            NSLog(@"点击了发布");
            
        }];
    }else{
        [self uploadPhotoWith:nil type:YES token:nil url:nil];
    }
    
    
    
    
}


#pragma mark - imagePickerDelegate
-(void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImages:(NSArray *)images
{
    ImageArr = [NSMutableArray arrayWithArray:images];
    [_collection reloadData];

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end








