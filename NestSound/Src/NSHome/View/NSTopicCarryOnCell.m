//
//  NSTopicCarryOnCell.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#define kSubButtonWidth 60.0f
#define kSubButtonHeight 60.0f

#import "NSTopicCarryOnCell.h"
#import "UIButton+WebCache.h"
#import "NSIndexModel.h"
@interface NSTopicCarryOnCell ()
{
    UILabel *_titleLable;
    UILabel *nameLable;
}
@property (nonatomic,strong) UIScrollView *scrollView;




@end


@implementation NSTopicCarryOnCell



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI{
    
    /**
     *  上下黑线
     */
//    UILabel *topLine = [[UILabel alloc] init];
//    topLine.size = CGSizeMake(ScreenWidth, 0.5);
//    topLine.backgroundColor = [UIColor hexColorFloat:@"e6e6e6"];
    
//    NSData * archiveData = [NSKeyedArchiver archivedDataWithRootObject:topLine];
//    UILabel* bottomLine = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
//    [self addSubview:topLine];
//    [self addSubview:bottomLine];
//    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.top.equalTo(self.mas_top);
//        make.height.mas_equalTo(0.5);
//
//    }];
    
//    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//        make.height.mas_equalTo(0.5);
//    }];
    
    
    /**
     *  设置标题
     */
//    _titleLable = [[UILabel alloc] init];
//    
//    _titleLable.font = [UIFont systemFontOfSize:15];
//    
//    
//    [self addSubview:_titleLable];
//    
//    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.mas_top).offset(10);
//        
//        make.left.equalTo(self.mas_left).offset(15);
//        
//    }];
    
//    _titleLable.text = @"话题进行中";

    
    /**
     *  设置横向滚动列表
     */
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(80);
    }];
    
}

- (void)setupDataWithTopicArray:(NSMutableArray *)topicArray{

//    NSArray *imagesArr = @[@"",@"",@"",@"",@"",@""];
//    [NSArray arrayWithArray:topicArray];
    self.scrollView.contentSize = CGSizeMake(15+(100) *topicArray.count, 60);
    self.scrollView.showsHorizontalScrollIndicator = NO;

    for (NSInteger i = 0; i < topicArray.count; i ++) {
        NSMusician *model = topicArray[i];
        UIButton *topicButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            [btn setFrame:CGRectMake(15 + (kSubButtonWidth + 15) * i, 0, kSubButtonWidth, kSubButtonHeight)];
            
            btn.backgroundColor = [UIColor whiteColor];
            
//            [btn setBackgroundImage:[UIImage imageNamed:@"2.0_placeHolder_long"] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 30.0f;
            btn.clipsToBounds = YES;
            [btn sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
            
        } action:^(UIButton *btn) {
            
            if (self.topicClickBlock) {
                self.topicClickBlock(i);
            }
            
        }];
        
        [_scrollView addSubview:topicButton];
        if (nameLable == nil) {
            nameLable = [[UILabel alloc] init];
            
            nameLable.textAlignment = NSTextAlignmentCenter;
            
            nameLable.font = [UIFont systemFontOfSize:13];
            
            nameLable.tag = 200 + i;
            
            
            
            [_scrollView addSubview:nameLable];
        }
        
        nameLable.frame = CGRectMake(15 + (kSubButtonWidth + 15) * i, 60, 60, 20);
        nameLable.text = model.nickname;
    }
    
    
}



@end
