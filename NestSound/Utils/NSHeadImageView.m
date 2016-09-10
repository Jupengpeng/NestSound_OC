//
//  NSHeadImageView.m
//  NestSound
//
//  Created by yintao on 16/9/10.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSHeadImageView.h"
#import "GPUImage.h"

@interface NSHeadImageView ()

@property (nonatomic,strong) UIImageView *shelterImageView;

@end


@implementation NSHeadImageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        
        self.userInteractionEnabled = YES;
        //设置图片的模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        //解决设置UIViewContentModeScaleAspectFill图片超出边框的问题
        self.clipsToBounds = YES;
        
        self.shelterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.shelterImageView.image = [UIImage imageWithRenderColor:[[UIColor hexColorFloat:@"181818"] colorWithAlphaComponent:0.3]renderSize:CGSizeMake(1, 0.5)];
        [self addSubview:self.shelterImageView];
        
    }
    return self;
    
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.shelterImageView.size = frame.size;
}

- (void)setupBlurImageWithBlurRadius:(CGFloat)blurRadius image:(UIImage *)image{
    
    //    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    //    UIImage *inputImage = [UIImage imageWithData:data];
    UIImage *inputImage = image;
    GPUImageGaussianBlurFilter *passthroughFilter = [[GPUImageGaussianBlurFilter alloc]init];
    passthroughFilter.blurRadiusInPixels = 20 * blurRadius;;
    [passthroughFilter forceProcessingAtSize:inputImage.size];
    [passthroughFilter useNextFrameForImageCapture];
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    [stillImageSource addTarget:passthroughFilter];
    [stillImageSource processImage];
    UIImage *nearestNeightImage = [passthroughFilter imageFromCurrentFramebuffer];

    self.image = nearestNeightImage;
}




@end
