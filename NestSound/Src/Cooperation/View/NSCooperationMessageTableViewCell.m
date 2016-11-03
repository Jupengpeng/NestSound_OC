//
//  NSCooperationMessageTableViewCell.m
//  NestSound
//
//  Created by yinchao on 16/10/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationMessageTableViewCell.h"

static inline NSRegularExpression * NameRegularExpression() {
    static NSRegularExpression *_nameRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _nameRegularExpression;
}

@interface NSCooperationMessageTableViewCell () {
    
    //头像
    UIButton *iconBtn;
    
    //日期
    UILabel *dateLabel;
    
    
    UIView * bkView;
    UIImageView * titlePage;
    UILabel * authorName;
    UILabel * workNameLabel;
}


@property (nonatomic, assign) CGSize labelSize;

//回复内容
@property (nonatomic, copy)  NSString *replyStr;

//回复了谁
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL message;
//@property (nonatomic, strong) UILabel *replyLabel;
//
@property (nonatomic, strong) UIButton *replyBtn;
//
//@property (nonatomic, strong) UILabel *contentLabel;

@end
@implementation NSCooperationMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.userInteractionEnabled = YES;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    //头像
    iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"2.0_weChat"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:iconBtn];
    iconBtn.clipsToBounds = YES;
    iconBtn.layer.cornerRadius = 40/2.0f;
    
    //作者名
    self.authorNameLabel = [[UILabel alloc] init];
    
    self.authorNameLabel.font = [UIFont systemFontOfSize:14];
    
    self.authorNameLabel.text = @"疯子";
    
    [self.contentView addSubview:self.authorNameLabel];
    
    
    //日期
    dateLabel = [[UILabel alloc] init];
    
    dateLabel.font = [UIFont systemFontOfSize:10];
    
    dateLabel.textColor = [UIColor lightGrayColor];
    
    dateLabel.text = @"2016-05-26";
    
    [self.contentView addSubview:dateLabel];
    //
    
    //    //评论内容
    self.commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.commentLabel.font = [UIFont systemFontOfSize:12];
    self.commentLabel.textColor = [UIColor blackColor];
    self.commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.commentLabel.numberOfLines = 0;
    //    //设置高亮颜色
    //        self.commentLabel.highlightedTextColor = [UIColor greenColor];
    //
    //    //对齐方式
    self.commentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    //
    //    //行间距
    self.commentLabel.lineSpacing = 3;
    //
    //    //NO 不显示下划线
    self.commentLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    //
    
    [self.contentView addSubview:self.commentLabel];
    //
    self.name = [NSString stringWithFormat:@"回复 %@ :",@"Lonfey"];
    self.replyStr = @"合作留言";
    NSString *text = [NSString stringWithFormat:@"%@ %@",self.name, self.replyStr];
    
    WS(wSelf);
        [self.commentLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
         {
    
             //设置可点击文字的范围
             NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"Lonfey" options:NSCaseInsensitiveSearch];
    
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
             //         }
             return mutableAttributedString;
         }];
    
//        if (self.commentModel.commentType != 1) {
    
            //正则
            NSRegularExpression *regexp = NameRegularExpression();
    
            NSRange linkRange = [regexp rangeOfFirstMatchInString:text options:0 range:NSMakeRange(3, 2)];
    
            [self.commentLabel addLinkToURL:nil withRange:linkRange];
    
//        }
    
        //    [self.contentView addSubview:self.commentLabel];
    
        self.labelSize = [self.commentLabel.text sizeWithFont:[UIFont systemFontOfSize:12] andLineSpacing:3 maxSize:CGSizeMake(ScreenWidth - 70, MAXFLOAT)];
        //65
        self.commentLabel.frame = CGRectMake(65, 40, self.labelSize.width + 10, self.labelSize.height);
        
        self.commentLabelMaxY = CGRectGetMaxY(self.commentLabel.frame) + 10;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //头像
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
        make.width.mas_equalTo(40);
        
        make.height.mas_equalTo(40);
        
    }];
    
    //作者名
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconBtn.mas_right).offset(10);
        
        make.top.equalTo(iconBtn.mas_top).offset(5);
        
        make.height.mas_offset(20);
        
    }];
    
    //日期
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
        make.top.equalTo(self.authorNameLabel.mas_top);
        
    }];
    
}
- (void)iconBtnClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(commentTableViewCell:)]) {
        
        [self.delegate commentTableViewCell:self];
    }
}
- (void)replyBtnCilck:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(replyCommentTableViewCell:)]) {
        [self.delegate replyCommentTableViewCell:self];
    }
}

//-(void)setCommentModel:(NSCommentModel *)commentModel
//{
//    _commentModel = commentModel;
//    self.authorNameLabel.text = self.commentModel.nickName;
//    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:iconBtn.frame];
//    [image setDDImageWithURLString:_commentModel.headerURL placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
//    [iconBtn.imageView setDDImageWithURLString:_commentModel.headerURL placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
//    [iconBtn setBackgroundImage:image.image forState:UIControlStateNormal];
//    
//    dateLabel.text = [date datetoStringWithDate:self.commentModel.createDate];
//    
//    [titlePage setDDImageWithURLString:self.commentModel.titleImageURL placeHolderImage:[UIImage imageNamed:@"2.0_placeHolder"]];
//    
//    workNameLabel.text = self.commentModel.title;
//    
//    authorName.text = self.commentModel.authorName;
//    
//    
//    WS(wSelf);
//    
//    if (self.commentModel.commentType == 1) {
//        
//        
//        if (self.commentModel.targetUserID == 0) {
//            self.commentModel.nowTargetName = @"";
//        }
//        self.name = [NSString stringWithFormat:@"%@",self.message == YES ? self.commentModel.targetName : self.commentModel.nowTargetName];
//    } else {
//        
//        self.name = [NSString stringWithFormat:@"回复 %@ :",self.message == YES ? self.commentModel.targetName : self.commentModel.nowTargetName];
//    }
//    self.replyStr = self.commentModel.comment;
//    NSString *text = [NSString stringWithFormat:@"%@ %@",self.name, self.replyStr];
//    
//    
//    [self.commentLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
//     {
//         
//         //设置可点击文字的范围
//         NSRange boldRange = [[mutableAttributedString string] rangeOfString:wSelf.message == YES ? wSelf.commentModel.targetName : wSelf.commentModel.nowTargetName options:NSCaseInsensitiveSearch];
//         
//         //设定可点击文字的的大小
//         UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:12];
//         CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
//         
//         if (font) {
//             
//             //设置可点击文本的大小
//             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
//             
//             //设置可点击文本的颜色
//             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor hexColorFloat:@"539ac2"] CGColor] range:boldRange];
//             
//             CFRelease(font);
//             
//         }
//         //         }
//         return mutableAttributedString;
//     }];
//    
//    if (self.commentModel.commentType != 1) {
//        
//        //正则
//        NSRegularExpression *regexp = NameRegularExpression();
//        
//        NSRange linkRange = [regexp rangeOfFirstMatchInString:text options:0 range:NSMakeRange(3, self.message == YES ? self.commentModel.targetName.length : self.commentModel.nowTargetName.length)];
//        
//        [self.commentLabel addLinkToURL:nil withRange:linkRange];
//        
//    }
//    
//    //    [self.contentView addSubview:self.commentLabel];
//    
//    self.labelSize = [self.commentLabel.text sizeWithFont:[UIFont systemFontOfSize:12] andLineSpacing:3 maxSize:CGSizeMake(ScreenWidth - 70, MAXFLOAT)];
//    //65
//    self.commentLabel.frame = CGRectMake(15, 55, self.labelSize.width + 10, self.labelSize.height);
//    
//    self.commentLabelMaxY = CGRectGetMaxY(self.commentLabel.frame) + 10;
//    
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
