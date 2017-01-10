#import <UIKit/UIKit.h>

@protocol AyMovieGLViewProtocol <NSObject>
- (void) startRender;
- (void) renderVideoData:(unsigned char **)data stride:(int *)stride widthWidth:(uint)width widthHeight:(uint)height;
- (void) player:(id)player didScreenshotImage:(UIImage *)image;
@end

@interface AyMovieGLView : UIView

@property (nonatomic, assign, readwrite) NSInteger playMode;//0--满窗口(默认)；1--按比例
@property (nonatomic, assign) BOOL needRestartRender;//解决播放前小时间段（3-5s）黑屏问题, 播放前置为TURE
@property (nonatomic, assign) BOOL isAppEnterBackground;//app iOS 后台运行不允许发出任何OpenGL ES绘画命令, 进入后台置为TRUE

/**
 * 初始化播放器
 *
 */
- (id) initWithFrame:(CGRect)frame;

- (void) getScreenshot;

@property(nonatomic,weak)id<AyMovieGLViewProtocol> delegate;
@end