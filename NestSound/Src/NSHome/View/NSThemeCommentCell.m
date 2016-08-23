//
//  NSThemeCommentCell.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSThemeCommentCell.h"
#import "NSJoinedWorkListModel.h"

static inline NSRegularExpression * NameRegularExpression() {
    static NSRegularExpression *_nameRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _nameRegularExpression;
}
@interface NSThemeCommentCell ()<TTTAttributedLabelDelegate>

@property (nonatomic, assign) CGSize labelSize;

//回复内容
@property (nonatomic, copy)  NSString *replyStr;

//回复了谁
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL message;

@end

@implementation NSThemeCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //    //评论内容
    self.commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.commentLabel.font = [UIFont systemFontOfSize:12];
    self.commentLabel.delegate = self;

    self.commentLabel.textColor = [UIColor hexColorFloat:@"878787"];
    self.commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.commentLabel.numberOfLines = 0;
    //    //设置高亮颜色
    //        self.commentLabel.highlightedTextColor = [UIColor greenColor];
    //
    //    //对齐方式
    self.commentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    //    //行间距
    self.commentLabel.lineSpacing = 3;
    //
    //    //NO 不显示下划线
    self.commentLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    [self.contentView addSubview:self.commentLabel];
    

}

- (void)setCommentModel:(NSJoinWorkCommentModel *)commentModel{
    _commentModel = commentModel;
    
    /**
     *  可点击文本
     */
    NSInteger clickTextCount = 1;

    
    WS(wSelf);
    /**
     *  type为1 单人评论  type为2  评论别人
     */
    if (self.commentModel.comment_type == 1) {
        
        self.name = [NSString stringWithFormat:@"%@:",commentModel.nickname];
//                     self.message == YES ? self.commentModel.target_nickname : self.commentModel.target_nickname];
    } else {
        
        self.name = [NSString stringWithFormat:@"%@ 回复 %@:",commentModel.nickname,commentModel.target_nickname];
        clickTextCount ++ ;
//                     self.message == YES ? self.commentModel.target_nickname : self.commentModel.target_nickname];
    }
    self.replyStr = self.commentModel.comment;
    NSString *text = [NSString stringWithFormat:@"%@ %@",self.name, self.replyStr];
    
    [self.commentLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
     {
         
         //设置可点击文字的范围 评论人
         NSRange nickRange = [[mutableAttributedString string] rangeOfString:wSelf.commentModel.nickname  options:NSCaseInsensitiveSearch];
         
         //设定可点击文字的的大小
         UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:12];
         CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
         
         if (font) {
             
             //设置可点击文本的大小
             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:nickRange];
             
             //设置可点击文本的颜色
             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor hexColorFloat:@"539ac2"] CGColor] range:nickRange];
             
//             被评论人
             if (clickTextCount == 2) {
                 NSRange targetRange = [[mutableAttributedString string] rangeOfString:wSelf.commentModel.target_nickname  options:NSCaseInsensitiveSearch];

                 
                 [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:targetRange];
                 [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor hexColorFloat:@"539ac2"] CGColor] range:targetRange];

                 

             }
             
             CFRelease(font);
             
         }
         //         }
         return mutableAttributedString;
     }];
    
    /**
     *  nick
     */
        //正则
        NSRegularExpression *regexp = NameRegularExpression();
        
        NSRange nickRange = [regexp rangeOfFirstMatchInString:text options:0 range:NSMakeRange(0, self.commentModel.nickname.length)];
        
        [self.commentLabel addLinkToURL:[NSURL URLWithString:@"nickName"] withRange:nickRange];
    
    
    NSRange targetRange = [self.commentLabel.text rangeOfString:wSelf.commentModel.target_nickname  options:NSCaseInsensitiveSearch];
    
    [self.commentLabel addLinkToURL:[NSURL URLWithString:@"targetName"] withRange:targetRange];
    
    
    
    //    [self.contentView addSubview:self.commentLabel];
    
    self.labelSize = [self.commentLabel.text sizeWithFont:[UIFont systemFontOfSize:12] andLineSpacing:0 maxSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT)];
    //65
    self.commentLabel.frame = CGRectMake(10, 5, self.labelSize.width, self.labelSize.height);
    
    self.commentLabelMaxY = CGRectGetMaxY(self.commentLabel.frame) + 10;
    
    self.commentLabel.delegate = self;

}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{

    
    /**
     *  评论者
     */
    if ([url.absoluteString isEqualToString:@"nickName"]) {
        if (self.commetorClickBlock) {
            self.commetorClickBlock(self.commentModel.uid);
        }
    }
    
    if ([url.absoluteString isEqualToString:@"targetName"]) {
        if (self.commetorClickBlock) {
            self.commetorClickBlock(self.commentModel.target_uid);
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
