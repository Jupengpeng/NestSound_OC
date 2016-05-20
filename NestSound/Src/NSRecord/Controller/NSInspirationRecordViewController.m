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
@interface NSInspirationRecordViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    
    UICollectionView *_collection;
    
    UIView *_bottomView;
}

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, weak) UIView *recordView;

@property (nonatomic, weak) UILabel *promptLabel;

@end
static NSString * const reuseIdentifier  = @"ReuseIdentifier";
@implementation NSInspirationRecordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = [date datetoLongStringWithDate:[NSDate date]];
    
    [self setupUI];
    
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
}

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
    
    //textView
    NSLyricView *inspiration = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 406)];
    
    inspiration.lyricText.delegate = self;
    
    [self.view addSubview:inspiration];
    
    self.placeholderLabel=[[UILabel alloc]initWithFrame:CGRectMake(4, 5, ScreenHeight, 22)];
    
    self.placeholderLabel.text = @"此时此刻你最想说些什么";
    
    self.placeholderLabel.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1.f];
    
    [inspiration.lyricText addSubview:self.placeholderLabel];
    
    //底部工具条View
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 124, ScreenWidth, 60)];
    
    [self.view addSubview:_bottomView];
    
    
    UIView *line1 = [[UIView alloc] init];//]WithFrame:CGRectMake(0, ScreenHeight - (ScreenHeight - 329), ScreenWidth, 1)];
    
    line1.backgroundColor = [UIColor lightGrayColor];
    
    [_bottomView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(_bottomView);
        
        make.height.mas_equalTo(1);
        
    }];
    
    //录音View
    UIView *recordView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 258)];
    
    self.recordView = recordView;
    
    [self.view addSubview:recordView];
    
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
    
    
    UILabel *promptLabel = [[UILabel alloc] init];
    
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
        
    }];
    
    [recordView addSubview:recordBtn];
    
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(promptLabel.mas_bottom).offset(50);
        
        make.centerX.equalTo(recordView.mas_centerX);
        
    }];
    
    //添加照片
    UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_addPicture"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了添加照片");
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 10;
        
        layout.minimumInteritemSpacing = 20;
        
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        CGFloat W = (inspiration.lyricText.width - 60) / 3;
        
        layout.itemSize = CGSizeMake(W, W);
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, inspiration.lyricText.width, W + 10) collectionViewLayout:layout];
        
        _collection.delegate = self;
        
        _collection.dataSource = self;
        
        _collection.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
        
        [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        [inspiration.lyricText addSubview:_collection];
        
        
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
        
        [wSelf.view addSubview:self.recordView];
        
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    
    return cell;
}




- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
    


@end








