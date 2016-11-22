//
//  NSHeadImageView.m
//  NestSound
//
//  Created by yintao on 16/9/10.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#define kDefaultImage [UIImage imageNamed:@"2.0_backgroundImage"]

#import "NSHeadImageView.h"
#import "GPUImage.h"
#import "FXBlurView.h"
@interface NSHeadImageView ()

@property (nonatomic,strong) UIImageView *shelterImageView;

@property (nonatomic,strong) FXBlurView *blurView;
@end


@implementation NSHeadImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = kDefaultImage;
        
        self.userInteractionEnabled = YES;
        //设置图片的模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        //解决设置UIViewContentModeScaleAspectFill图片超出边框的问题
        self.clipsToBounds = YES;

        /**
         滤镜
        */
        self.blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        self.blurView.alpha = 0;
        self.blurView.tintColor = [UIColor whiteColor];
//        self.blurView.iterations = 2;
        [self addSubview:self.blurView ];
        
        self.shelterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        /**
         *  深色遮挡
         */
        UIImage *shelterImage = [UIImage createImageWithColor:[[UIColor hexColorFloat:@"181818"] colorWithAlphaComponent:0.3]];
        self.shelterImageView.image = [self setupBlurImageWithBlurRadius:1 image:shelterImage];
        [self addSubview:self.shelterImageView];
    }
    return self;
    
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.shelterImageView.size = frame.size;
    self.blurView.size = frame.size;
}

- (void)setImage:(UIImage *)image{
    
    [super setImage:image];
    
    if (!image) {
        self.image = kDefaultImage;
    }
    
}

- (void)setBlurAlpha:(CGFloat)blurAlpha{
//    self.blurView.blurRadius =40 * alpha;
    self.blurView.alpha = blurAlpha;
}


- (UIImage *)setupBlurImageWithBlurRadius:(CGFloat)blurRadius image:(UIImage *)image{
    
    //    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    //    UIImage *inputImage = [UIImage imageWithData:data];
    UIImage *inputImage = image;
    GPUImageGaussianBlurFilter *passthroughFilter = [[GPUImageGaussianBlurFilter alloc]init];
    passthroughFilter.blurRadiusInPixels = 20 ;;
    [passthroughFilter forceProcessingAtSize:inputImage.size];
    [passthroughFilter useNextFrameForImageCapture];
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    [stillImageSource addTarget:passthroughFilter];
    [stillImageSource processImage];
    UIImage *nearestNeightImage = [passthroughFilter imageFromCurrentFramebuffer];

//    self.image = nearestNeightImage;
    return nearestNeightImage;
}




@end
