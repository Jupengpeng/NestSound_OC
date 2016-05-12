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

@interface NSInspirationRecordViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    
    UICollectionView *_collection;
}

@property (nonatomic, strong) UILabel *label;

@end
static NSString * const reuseIdentifier  = @"ReuseIdentifier";
@implementation NSInspirationRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *dateStr = [formatter stringFromDate:date];
    
    self.title = dateStr;
    
    [self setupUI];
    
}

- (void)setupUI {
    
    NSLyricView *inspiration = [[NSLyricView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 406)];
    
    inspiration.lyricText.delegate = self;
    
    [self.view addSubview:inspiration];
    
    self.label=[[UILabel alloc]initWithFrame:CGRectMake(4, 5, ScreenHeight, 22)];
    
    self.label.text = @"此刻你最想说些什么";
    
    self.label.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1.f];
    
    [inspiration.lyricText addSubview:self.label];
    
    
    UIView *line = [[UIView alloc] init];//]WithFrame:CGRectMake(0, ScreenHeight - (ScreenHeight - 329), ScreenWidth, 1)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.top.equalTo(inspiration.mas_bottom);
        
        make.height.mas_equalTo(1);
        
    }];
    
    
    UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_addPicture"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了添加照片");
        #warning mark hahahhaha
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 10;
        
        layout.minimumInteritemSpacing = 20;
        
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        CGFloat W = (inspiration.lyricText.width - 60) / 3;
        
        layout.itemSize = CGSizeMake(W, W);
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 190, inspiration.lyricText.width, 120) collectionViewLayout:layout];
        
        _collection.delegate = self;
        
        _collection.dataSource = self;
        
        _collection.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
        
        [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        [inspiration.lyricText addSubview:_collection];
        
     
    }];
    
    [self.view addSubview:pictureBtn];
    
    [pictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line.mas_bottom).offset(15);
        
        make.left.equalTo(self.view.mas_left).offset(15);
        
        make.width.height.mas_equalTo(30);
        
    }];
    
    
    UIButton *soundBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_addSound"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        NSLog(@"点击了添加录音");
        
    }];
    
    [self.view addSubview:soundBtn];
    
    [soundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line.mas_bottom).offset(15);
        
        make.left.equalTo(pictureBtn.mas_right).offset(15);
        
        make.width.height.mas_equalTo(30);
        
    }];
    
    
    UIView *line2 = [[UIView alloc] init];//]WithFrame:CGRectMake(0, ScreenHeight - (ScreenHeight - 329), ScreenWidth, 1)];
    
    line2.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.top.equalTo(pictureBtn.mas_bottom).offset(15);
        
        make.height.mas_equalTo(1);
        
    }];
    
    
}


-(void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text length] == 0) {
        
        _label.hidden = NO;
        
    }else{
        
        _label.hidden = YES;
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

@end








