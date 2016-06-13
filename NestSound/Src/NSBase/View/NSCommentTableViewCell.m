//
//  NSCommentTableViewCell.m
//  NestSound
//
//  Created by Apple on 16/5/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCommentTableViewCell.h"
#import "NSCommentListModel.h"
static inline NSRegularExpression * NameRegularExpression() {
    static NSRegularExpression *_nameRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _nameRegularExpression;
}

//static inline NSRegularExpression * ParenthesisRegularExpression() {
//    static NSRegularExpression *_parenthesisRegularExpression = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\([^\\(\\)]+\\)" options:NSRegularExpressionCaseInsensitive error:nil];
//    });
//    
//    return _parenthesisRegularExpression;
//}

@interface NSCommentTableViewCell () {
    
    //头像
    UIButton *iconBtn;
        
    //日期
    UILabel *dateLabel;
    
}

//回复内容
@property (nonatomic, copy)  NSString *replyStr;

//回复了谁
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) CGSize labelSize;

@end

@implementation NSCommentTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    //头像
    iconBtn = [[UIButton alloc] init];
    
    [iconBtn setImage:[UIImage imageNamed:@"2.0_backgroundImage"] forState:UIControlStateNormal];
    
    [iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:iconBtn];
    
    
    //作者名
    self.authorNameLabel = [[UILabel alloc] init];
    
    self.authorNameLabel.font = [UIFont systemFontOfSize:14];
    
    self.authorNameLabel.text = @"谢豪杰";
    
    [self.contentView addSubview:self.authorNameLabel];
    
    
    //日期
    dateLabel = [[UILabel alloc] init];
    
    dateLabel.font = [UIFont systemFontOfSize:10];
    
    dateLabel.text = @"2016-05-26";
    
    [self.contentView addSubview:dateLabel];

    
    //评论内容
    self.commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.commentLabel.font = [UIFont systemFontOfSize:12];
    self.commentLabel.textColor = [UIColor blackColor];
    self.commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.commentLabel.numberOfLines = 0;
    //设置高亮颜色
    //    self.commentLabel.highlightedTextColor = [UIColor greenColor];
    
    //对齐方式
    self.commentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    
    //行间距
    self.commentLabel.lineSpacing = 3;
    
    //NO 不显示下划线
    self.commentLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    
    WS(wSelf);
    self.name = @"张轩赫";
    NSString *text = [NSString stringWithFormat:@"回复 %@ :  %@",self.name, self.replyStr];;
    
    
    [self.commentLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
     {
         
         //设置可点击文字的范围
         NSRange boldRange = [[mutableAttributedString string] rangeOfString:wSelf.name options:NSCaseInsensitiveSearch];
         
         //设定可点击文字的的大小
         UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:12];
         CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
         
         if (font) {
             
             //设置可点击文本的大小
             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
             
             //设置可点击文本的颜色
             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor hexColorFloat:@"539ac2"] CGColor] range:boldRange];
             
             CFRelease(font);
             
         }
         return mutableAttributedString;
     }];
    
    //正则
    NSRegularExpression *regexp = NameRegularExpression();
    
    NSRange linkRange = [regexp rangeOfFirstMatchInString:text options:0 range:NSMakeRange(3, self.name.length)];
    
    [self.commentLabel addLinkToURL:nil withRange:linkRange];
    
    
    [self.contentView addSubview:self.commentLabel];
    
    self.labelSize = [self.commentLabel.text sizeWithFont:[UIFont systemFontOfSize:12] andLineSpacing:3 maxSize:CGSizeMake(ScreenWidth - 70, MAXFLOAT)];
    
    self.commentLabel.frame = CGRectMake(60, 55, self.labelSize.width, self.labelSize.height);
    
    self.commentLabelMaxY = CGRectGetMaxY(self.commentLabel.frame) + 10;
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //头像
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
        make.width.mas_equalTo(35);
        
        make.height.mas_equalTo(35);
        
    }];
    
    //作者名
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconBtn.mas_right).offset(10);
        
        make.top.equalTo(iconBtn.mas_top);
        
    }];
    
    //日期
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(iconBtn.mas_right).offset(10);
        
        make.bottom.equalTo(iconBtn.mas_bottom);
        
    }];
    
}

- (void)iconBtnClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(commentTableViewCell:)]) {
        
        [self.delegate commentTableViewCell:self];
    }
}


-(void)setCommentModel:(NSCommentModel *)commentModel
{
    _commentModel = commentModel;
    self.authorNameLabel.text = self.commentModel.nickName;
//    [iconBtn set]

}

@end









