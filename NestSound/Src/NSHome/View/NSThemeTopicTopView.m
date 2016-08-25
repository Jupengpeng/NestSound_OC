//
//  NSThemeTopicTopView.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSThemeTopicTopView.h"
#import "NSTool.h"
#import "UIButton+WebCache.h"
#import "NSActivityDetailModel.h"
#import "NSActivityJoinerListModel.h"
@interface NSThemeTopicTopView ()



@property (nonatomic,strong) UIImageView *activityCover;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *durationLabel;

@property (nonatomic,strong) UILabel *workNumberLabel;

@property (nonatomic,strong) UILabel *watchedLabel;

//@property (nonatomic,strong) UILabel *descriptionLabel;

@property (nonatomic,strong) UILabel *joinCountLabel;

@property (nonatomic,strong) UIScrollView *headPortraitScrollView;

@end


@implementation NSThemeTopicTopView


- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self) {
        self = [super initWithFrame:frame];
        
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    
    self.backgroundColor = [UIColor hexColorFloat:@"f6f6f6"];

    
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(100);
    }];
    /**
     上部视图
     */
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(1);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-10.0f);
        make.height.mas_equalTo(150);

    }];
    /**
     封面
     
     */
    self.activityCover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 90)];
    self.activityCover.clipsToBounds = YES;
    self.activityCover.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.topView addSubview:self.activityCover];
    [self.activityCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).offset(10);
        make.left.equalTo(self.topView).offset(10);
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(90);
    }];
    
    /**
     *  标题
     *
     */
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor hexColorFloat:@"222222"];
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).offset(17);
        make.left.equalTo(self.activityCover.mas_right).offset(15);
        make.right.equalTo(self.topView.mas_right).offset(-15);
    }];
    
    /**
     *  活动时间
     *
     */
    
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.font = [UIFont systemFontOfSize:13.0f];
    self.durationLabel.textColor = [UIColor hexColorFloat:@"7d7d7d"];
    [self.topView addSubview:self.durationLabel];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.equalTo(self.activityCover.mas_right).offset(15);
        make.right.equalTo(self.topView.mas_right).offset(-15);
        
    }];
    
    /**
     *  作品数量
     */
    UIImageView *workNumberIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_zuopin"]];
    
    [self.topView addSubview:workNumberIcon];
    [workNumberIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityCover.mas_right).offset(15);
        make.top.equalTo(self.durationLabel.mas_bottom).offset(16);
        
    }];
    
    self.workNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.workNumberLabel.textColor = [UIColor hexColorFloat:@"a3a3a3"];
    self.workNumberLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.topView addSubview:self.workNumberLabel];
    [self.workNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workNumberIcon.mas_right).offset(5);
        make.top.equalTo(self.durationLabel.mas_bottom).offset(16);
    }];
    /**
     *  查看数量
     */
    UIImageView *watchedNumberIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IC_yanjing"]];
    
    [self.topView addSubview:watchedNumberIcon];
    [watchedNumberIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.workNumberLabel.mas_right).offset(35);
        make.top.equalTo(self.durationLabel.mas_bottom).offset(18);
        
    }];
    
    self.watchedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.watchedLabel.textColor = [UIColor hexColorFloat:@"a3a3a3"];
    self.watchedLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.topView addSubview:self.watchedLabel];
    [self.watchedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(watchedNumberIcon.mas_right).offset(5);
        make.top.equalTo(self.durationLabel.mas_bottom).offset(16);
    }];
    /**
     *  描述
     */

    self.descriptionLabel = [[TTTAttributedLabel alloc ]initWithFrame:CGRectZero];
    self.descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
    self.descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.descriptionLabel.numberOfLines = 0 ;
    //    //对齐方式
    self.descriptionLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    //    //行间距
    self.descriptionLabel.lineSpacing = 3;
    self.descriptionLabel.tag = kTopViewLabelTag;
    /**
     *  显示样式
     */
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    [linkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [linkAttributes setValue:(__bridge id)[UIColor hexColorFloat:@"539ac2"].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    self.descriptionLabel.linkAttributes = linkAttributes;
    
    [self.topView addSubview:self.descriptionLabel];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.top.equalTo(self.activityCover.mas_bottom).offset(10);
    }];
    
    /**
     *  参与人数
     */
    
    self.joinCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.bottomView addSubview:self.joinCountLabel];
    
    [self.joinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(13.0f);
        make.left.equalTo(self.bottomView.mas_left).offset(10.0f);
        
    }];
    
    
    
    
    /**
     *  参与人头像
     */
    

 
}

- (void)setupDataWithData:(id)data joinerArray:(NSArray *)joinerArr descriptionIsFoldOn:(BOOL)isFoldOn {
    
    if (!data) {
        return;
    }
    
    ActivityDetailModel *detailModel = ((NSActivityDataModel *)data).activityDetailModel;
    
    _isFoldOn = isFoldOn;
 
    
    
    [self.activityCover setDDImageWithURLString:detailModel.pic placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];

    self.titleLabel.text = detailModel.title;
    NSString * dateStr = [NSString stringWithFormat:@"%@ ~ %@",[date datetoMonthStringWithDate:detailModel.begindate],[date datetoMonthStringWithDate:detailModel.enddate]];

    self.durationLabel.text = dateStr;
    
    if (detailModel.worknum > 9999) {
        double count = (double)detailModel.worknum/10000.0;
        self.workNumberLabel.text = [NSString stringWithFormat:@"%.1f万",count];
    }else{
        self.workNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)detailModel.worknum];
    }
    self.workNumberLabel.size =CGSizeMake([NSTool getWidthWithContent:self.workNumberLabel.text font:[UIFont systemFontOfSize:11.0f]], 10);

    
    if (detailModel.looknum > 9999) {
        double count = (double)detailModel.looknum/10000.0;
        self.watchedLabel.text = [NSString stringWithFormat:@"%.1f万",count];
    }else{
        self.watchedLabel.text = [NSString stringWithFormat:@"%ld",(long)detailModel.looknum];
    }
    self.watchedLabel.size =CGSizeMake([NSTool getWidthWithContent:self.watchedLabel.text font:[UIFont systemFontOfSize:11.0f]], 10);
    
    NSString *string = detailModel.actDesc;
//    @"我们有最棒的音乐，但还不够，我们希望有更多的高手加入，为我们增添一抹靓丽的磨彩。为此，我们准备了230万原创音乐基金作为奖励，支持优胜者参赛，并提供亚洲最大的音乐为我们增添一抹亮丽的墨彩";
    NSString *string2 = @"展开";
    NSString *string3 = @"收起";
    
    NSString *testLineStr = [NSString stringWithFormat:@"%@... %@",string,string2];

    self.descriptionLabel.text = testLineStr;
    
    NSInteger numOflines = [NSTool numberOfTextIn:self.descriptionLabel];
    
    if (numOflines <= 2) {
        
        self.descriptionLabel.text = string;
        
    }
    else{
    /**
     *  未展开
     */
    if (!isFoldOn) {
        NSString *twoLinesStr = [NSString stringWithFormat:@"%@... %@",[string substringToIndex:40],string2];
        self.descriptionLabel.text = twoLinesStr;
        
        NSRange range = NSMakeRange(twoLinesStr.length - string2.length, string2.length);
        [self.descriptionLabel addLinkToURL:nil withRange:range];

    }else{
        NSString *totalString = [NSString stringWithFormat:@"%@  %@",string,string3];
        
        self.descriptionLabel.text = totalString;
        
        NSRange range = NSMakeRange(totalString.length - string3.length, string3.length);
        [self.descriptionLabel addLinkToURL:nil withRange:range];
    }
    }
 
    if (joinerArr.count) {
        
        
        
        self.joinCountLabel.font = [UIFont systemFontOfSize:14.0f];
        self.joinCountLabel.text = [NSString stringWithFormat:@"参加人数%ld人",joinerArr.count];
        CGFloat padding = 9.0f;
        CGFloat headerWidth = (ScreenWidth - padding * 9)/8.0f;
        
        NSMutableArray *pickArray = [NSMutableArray array];

        for (NSActivityJoinerDetailModel *joinerDetailModel in joinerArr) {
            [pickArray addObject:joinerDetailModel.headurl];
        }
        
        
        
        NSInteger headerCount ;
        if (pickArray.count <= 8) {
            headerCount = pickArray.count;
        }else{
            headerCount = 8 ;
        }
        
        for (NSInteger i = 0; i < headerCount; i ++) {
            NSActivityJoinerDetailModel *joinerDetailModel = joinerArr[i];
            UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
                
                btn.contentMode = UIViewContentModeScaleAspectFill;
                btn.frame = CGRectMake(padding + (headerWidth + padding) * i, 43, headerWidth, headerWidth);
                btn.clipsToBounds = YES;
                btn.layer.cornerRadius = headerWidth/2.0f;
                if (pickArray.count > 8 && i == 7) {
                    
                    [btn setImage:[UIImage imageNamed:@"ic_sandian"] forState:UIControlStateNormal];
                }else{
                    [btn sd_setImageWithURL:[NSURL URLWithString:pickArray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"2.0_placeHolder_long"]];
                }
            } action:^(UIButton *btn) {
                
                if (self.headerClickBlock) {
                    self.headerClickBlock(i,joinerDetailModel);
                }
            }];
            headButton.centerY = 67;
            [self.bottomView addSubview:headButton];
        }
        
    }
    
  
    

}

- (void)updateTopViewWithHeight:(CGFloat)height{

    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-10.0f);
        make.height.mas_equalTo(height);
    }];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
