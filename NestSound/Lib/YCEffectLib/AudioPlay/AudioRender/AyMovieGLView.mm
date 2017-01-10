#ifdef __APPLE__

#import "AyMovieGLView.h"

//opgn gl
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

//log
#include "AyLogger.h"
#if OPEN_LOG
#import "UAnYanLog.h"
extern NSString *g_logFilePath;
#endif

//audio
#define AUDIO_PLAY 1
#if AUDIO_PLAY
extern "C" {
#include "receive_ff_data_callbacks.h"
#include "AyUtil.h"
}
#import "ReceiveStreamingData.h"
#endif

//tread lock
#include <pthread.h>

//protocol
#import "AyMovieGLViewProtocol.h"

#include "AYPlayer_common.h"

BOOL g_appEnterBackground = FALSE;

//////////////////////////////////////////////////////////

#pragma mark - shaders

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

NSString *const vertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec2 texcoord;
 uniform mat4 modelViewProjectionMatrix;
 varying vec2 v_texcoord;
 
 void main()
 {
     gl_Position = modelViewProjectionMatrix * position;
     v_texcoord = texcoord.xy;
 }
);

NSString *const rgbFragmentShaderString = SHADER_STRING
(
 varying highp vec2 v_texcoord;
 uniform sampler2D s_texture;
 
 void main()
 {
     gl_FragColor = texture2D(s_texture, v_texcoord);
 }
);

NSString *const yuvFragmentShaderString = SHADER_STRING
(
 varying highp vec2 v_texcoord;
 uniform sampler2D s_texture_y;
 uniform sampler2D s_texture_u;
 uniform sampler2D s_texture_v;
 
 void main()
 {
     highp float y = texture2D(s_texture_y, v_texcoord).r;
     highp float u = texture2D(s_texture_u, v_texcoord).r - 0.5;
     highp float v = texture2D(s_texture_v, v_texcoord).r - 0.5;
     
     highp float r = y +             1.402 * v;
     highp float g = y - 0.344 * u - 0.714 * v;
     highp float b = y + 1.772 * u;
     
     gl_FragColor = vec4(r,g,b,1.0);     
 }
);

static BOOL validateProgram(GLuint prog)
{
	GLint status;
	
    glValidateProgram(prog);
    
#ifdef DEBUG
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        LoggerVideo(1, @"Program validate log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == GL_FALSE) {
		LoggerVideo(0, @"Failed to validate program %d", prog);
        return NO;
    }
	
	return YES;
}

static GLuint compileShader(GLenum type, NSString *shaderString)
{
	GLint status;
	const GLchar *sources = (GLchar *)shaderString.UTF8String;
	
    GLuint shader = glCreateShader(type);
    if (shader == 0 || shader == GL_INVALID_ENUM) {
        LoggerVideo(0, @"Failed to create shader %d", type);
        return 0;
    }
    
    glShaderSource(shader, 1, &sources, NULL);
    glCompileShader(shader);
	
#ifdef DEBUG
	GLint logLength;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(shader, logLength, &logLength, log);
        LoggerVideo(1, @"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE) {
        glDeleteShader(shader);
		LoggerVideo(0, @"Failed to compile shader:\n");
        return 0;
    }
    
	return shader;
}

static void mat4f_LoadOrtho(float left, float right, float bottom, float top, float near, float far, float* mout)
{
	float r_l = right - left;
	float t_b = top - bottom;
	float f_n = far - near;
	float tx = - (right + left) / (right - left);
	float ty = - (top + bottom) / (top - bottom);
	float tz = - (far + near) / (far - near);
    
	mout[0] = 2.0f / r_l;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = 2.0f / t_b;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = -2.0f / f_n;
	mout[11] = 0.0f;
	
	mout[12] = tx;
	mout[13] = ty;
	mout[14] = tz;
	mout[15] = 1.0f;
}

//////////////////////////////////////////////////////////

#pragma mark - AyMovieGLRenderer

@protocol AyMovieGLRenderer
- (BOOL) isValid;
- (NSString *) fragmentShader;
- (void) resolveUniforms: (GLuint) program;
- (int) setFrame: (S_VIDEO_BUFFER *) frame withFormat:(S_VIDEO_FORMAT*)format;
- (BOOL) prepareRender;
@end

@interface AyMovieGLRenderer_YUV : NSObject<AyMovieGLRenderer> {
    
    GLint _uniformSamplers[3];
    GLuint _textures[3];
}
@end

@implementation AyMovieGLRenderer_YUV

- (BOOL) isValid
{
    return (_textures[0] != 0);
}

- (NSString *) fragmentShader
{
    return yuvFragmentShaderString;
}

- (void) resolveUniforms: (GLuint) program
{
    _uniformSamplers[0] = glGetUniformLocation(program, "s_texture_y");
    _uniformSamplers[1] = glGetUniformLocation(program, "s_texture_u");
    _uniformSamplers[2] = glGetUniformLocation(program, "s_texture_v");
}

- (int) setFrame: (S_VIDEO_BUFFER *) frame withFormat:(S_VIDEO_FORMAT*)format
{
    int set_frame_status = 0;
    
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    
    if (0 == _textures[0])
        glGenTextures(3, _textures);
    
    UInt8 *pixels[3] = { frame->Buffer[0], frame->Buffer[1], frame->Buffer[2] };
    const signed int widths[3]  = { format->iVideoWidth, format->iVideoWidth / 2, format->iVideoWidth / 2 };
    const signed int heights[3] = { format->iVideoHeight, format->iVideoHeight / 2, format->iVideoHeight / 2 };
    if (frame->Stride[0] != format->iVideoWidth) {
        U_Player_Log(@"frame->Stride[0] != format->iVideoWidth");
        for (int i = 0; i < 3; ++i) {
            pixels[i] = new UInt8[widths[i] * heights[i]];
            for (int j = 0; j<heights[i]; ++j) {
                memcpy(pixels[i]+j*widths[i], frame->Buffer[i]+j*frame->Stride[i], widths[i]);
            }
        }
        /*
        pixels[0] = new UInt8[widths[0] * heights[0]];
        pixels[1] = new UInt8[widths[1] * heights[1]];
        pixels[2] = new UInt8[widths[2] * heights[2]];
        
        for(int i=0; i<heights[0]; i++)
        {
            memcpy(pixels[0]+i*widths[0], frame->Buffer[0]+i*frame->Stride[0], widths[0]);
        }
        
        for(int i=0; i<format->iVideoHeight/2; i++)
        {
            memcpy(pixels[1]+i*widths[1], frame->Buffer[1]+i*frame->Stride[1], widths[1]);
            memcpy(pixels[2]+i*widths[2], frame->Buffer[2]+i*frame->Stride[2], widths[2]);
        }
         */
    }
    
    for (int i = 0; i < 3; ++i) {
        
        glBindTexture(GL_TEXTURE_2D, _textures[i]);
        
        glTexImage2D(GL_TEXTURE_2D,
                     0,
                     GL_LUMINANCE,
                     widths[i],
                     heights[i],
                     0,
                     GL_LUMINANCE,
                     GL_UNSIGNED_BYTE,
                     pixels[i]);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }
    
    if (frame->Stride[0] != format->iVideoWidth) {
        delete [] pixels[0];
        delete [] pixels[1];
        delete [] pixels[2];
        set_frame_status = -1;
    }
    
    return set_frame_status;
}

- (BOOL) prepareRender
{
    if (_textures[0] == 0)
        return NO;
    
    for (int i = 0; i < 3; ++i) {
        glActiveTexture(GL_TEXTURE0 + i);
        glBindTexture(GL_TEXTURE_2D, _textures[i]);
        glUniform1i(_uniformSamplers[i], i);
    }
    
    return YES;
}

- (void) dealloc
{
    U_Player_Log(@"AyMovieGLRenderer_YUV dealloc ... ");
    if (_textures[0])
        glDeleteTextures(3, _textures);
}

@end

//////////////////////////////////////////////////////////

#pragma mark - AyMovieGLView

enum {
	ATTRIBUTE_VERTEX,
   	ATTRIBUTE_TEXCOORD,
};

@implementation AyMovieGLView {
    EAGLContext     *_context;
    GLuint          _framebuffer;
    GLuint          _renderbuffer;
    GLint           _backingWidth;
    GLint           _backingHeight;
    GLuint          _program;
    GLint           _uniformMatrix;
    GLfloat         _vertices[8];
    
    S_VIDEO_FORMAT  _format;
    
    id<AyMovieGLRenderer> _renderer;
    
    pthread_mutex_t             video_data_render_mutex;
    
    NSInteger       lastPlayMode;
    GLint          lastBgWidth;
    GLint          lastBgHeight;
    
    //fix render slur
    int             m_viewScale;
    
    //get screenshot
    BOOL            isGetScreenshot;
    
}

@synthesize playMode = _playMode;
@synthesize needRestartRender = _needRestartRender;
@synthesize isAppEnterBackground = _isAppEnterBackground;

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastPlayMode = 0;
        _playMode = 0;//默认充满播放窗口
        _needRestartRender = FALSE;
        _isAppEnterBackground = FALSE;//进入后台不再进行video render
        isGetScreenshot = FALSE;
        
        lastBgWidth = frame.size.width;
        lastBgWidth = frame.size.height;
        U_Player_Log(@"initWithFrame width = %d, height = %d", lastBgWidth, lastBgHeight);
        
        pthread_mutex_init(&video_data_render_mutex, NULL);
        [self CreateMovieContext];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        lastPlayMode = 0;
        _playMode = 0;//默认充满播放窗口
        _needRestartRender = FALSE;
        _isAppEnterBackground = FALSE;//进入后台不再进行video render
        isGetScreenshot = FALSE;
        
        lastBgWidth = self.frame.size.width;
        lastBgWidth = self.frame.size.height;
        NSLog(@"initWithCoder width = %d, height = %d", lastBgWidth, lastBgHeight);
        
        pthread_mutex_init(&video_data_render_mutex, NULL);
        [self CreateMovieContext];
    }
    
    return self;
}

-(void)getScreenshot{
    isGetScreenshot = TRUE;
}

-(BOOL)CreateMovieContext
{
    if (_renderer) {
        return YES;
    }
    
    _renderer = [[AyMovieGLRenderer_YUV alloc] init];
    LoggerVideo(1, @"OK use YUV GL renderer");
#if OPEN_LOG
    if (nil == g_logFilePath) {
        g_logFilePath = [NSString stringWithFormat:@"%@/%@", [[UAnYanLog sharedInstance] getLogFilePath], @"play_log.txt"];
    }
    [[UAnYanLog sharedInstance] writeLog:@"OK use YUV GL renderer ..." toFile:g_logFilePath];
#endif
    
    CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                    nil];
    
    self.contentScaleFactor = [UIScreen mainScreen].scale;
    m_viewScale = [UIScreen mainScreen].scale;
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_context ||
        ![EAGLContext setCurrentContext:_context]) {
        
        LoggerVideo(0, @"failed to setup EAGLContext");
        //self = nil;
        return NO;
    }
    
    //记住最近一次渲染buffer所用的宽高
    lastBgWidth = self.frame.size.width;
    lastBgHeight = self.frame.size.height;
    _backingWidth = self.frame.size.width;
    _backingHeight = self.frame.size.height;
    
    glGenFramebuffers(1, &_framebuffer);
    glGenRenderbuffers(1, &_renderbuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderbuffer);
    
    U_Player_Log(@"After bind frame buffer _backingWidth = %d, _backingHeight = %d", _backingWidth, _backingHeight);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        
        LoggerVideo(0, @"failed to make complete framebuffer object %x", status);
        //self = nil;
        return NO;
    }
    
    GLenum glError = glGetError();
    if (GL_NO_ERROR != glError) {
        
        LoggerVideo(0, @"failed to setup GL %x", glError);
        //self = nil;
        return NO;
    }
    
    if (![self loadShaders]) {
        
        //self = nil;
        return NO;
    }
    
    _vertices[0] = -1.0f;  // x0
    _vertices[1] = -1.0f;  // y0
    _vertices[2] =  1.0f;  // ..
    _vertices[3] = -1.0f;
    _vertices[4] = -1.0f;
    _vertices[5] =  1.0f;
    _vertices[6] =  1.0f;  // x3
    _vertices[7] =  1.0f;  // y3
    
    LoggerVideo(1, @"OK setup GL");
#if OPEN_LOG
    if (nil == g_logFilePath) {
        g_logFilePath = [NSString stringWithFormat:@"%@/%@", [[UAnYanLog sharedInstance] getLogFilePath], @"play_log.txt"];
    }
    [[UAnYanLog sharedInstance] writeLog:@"OK setup GL ..." toFile:g_logFilePath];
#endif
    return YES;
}

- (void)destroyMovieContext{
    _renderer = nil;
    
    if (_framebuffer) {
        glDeleteFramebuffers(1, &_framebuffer);
        _framebuffer = 0;
    }
    
    if (_renderbuffer) {
        glDeleteRenderbuffers(1, &_renderbuffer);
        _renderbuffer = 0;
    }
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
    
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    _context = nil;
}

- (void)dealloc
{
    U_Player_Log(@"AyMovieGLView dealloc....");
    [self destroyMovieContext];
    
    pthread_mutex_destroy(&video_data_render_mutex);
    
}


- (void)layoutSubviews
{
    pthread_mutex_lock(&video_data_render_mutex);
    
    if(nil == _renderer){
        [self CreateMovieContext];
    }else{
        //记住最近一次渲染buffer所用的宽高
        _backingWidth = self.frame.size.width;
        _backingHeight = self.frame.size.height;
        lastBgWidth = self.frame.size.width;
        lastBgHeight = self.frame.size.height;
        U_Player_Log(@"lay out before  self = %p, _backingWidth = %d, _backingHeight = %d", self, _backingWidth, _backingHeight);
        
        glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
//        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
//        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
        
        GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if (status != GL_FRAMEBUFFER_COMPLETE) {
            
            LoggerVideo(0, @"failed to make complete framebuffer object %x", status);
            
        } else {
            
            LoggerVideo(1, @"OK setup GL framebuffer %d:%d", _backingWidth, _backingHeight);
        }
    }
    
    [self updateVertices];
    
    pthread_mutex_unlock(&video_data_render_mutex);
}

- (BOOL)loadShaders
{
    BOOL result = NO;
    GLuint vertShader = 0, fragShader = 0;
    
	_program = glCreateProgram();
	
    vertShader = compileShader(GL_VERTEX_SHADER, vertexShaderString);
	if (!vertShader)
        goto exit;
    
	fragShader = compileShader(GL_FRAGMENT_SHADER, _renderer.fragmentShader);
    if (!fragShader)
        goto exit;
    
	glAttachShader(_program, vertShader);
	glAttachShader(_program, fragShader);
	glBindAttribLocation(_program, ATTRIBUTE_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIBUTE_TEXCOORD, "texcoord");
	
	glLinkProgram(_program);
    
    GLint status;
    glGetProgramiv(_program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE) {
		LoggerVideo(0, @"Failed to link program %d", _program);
        goto exit;
    }
    
    result = validateProgram(_program);
        
    _uniformMatrix = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    [_renderer resolveUniforms:_program];
	
exit:
    
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    if (result) {
        
        LoggerVideo(1, @"OK setup GL programm");
        
    } else {
        
        glDeleteProgram(_program);
        _program = 0;
    }
    
    return result;
}

- (void)updateVertices
{
//    const BOOL fit      = (self.contentMode == UIViewContentModeScaleAspectFit);
    //const float width   = _decoder.frameWidth;
    //const float height  = _decoder.frameHeight;
    
    switch (lastPlayMode) {
        case 0:{//满view
            const float h = 1.000;
            const float w = 1.000;
        
            _vertices[0] = - w;
            _vertices[1] = - h;
            _vertices[2] =   w;
            _vertices[3] = - h;
            _vertices[4] = - w;
            _vertices[5] =   h;
            _vertices[6] =   w;
            _vertices[7] =   h;
            
            break;
        }
            
        case 1:{//按比例
            const float width   = _format.iVideoWidth;
            const float height  = _format.iVideoHeight;
            const float dH      = (float)_backingHeight / height;
            const float dW      = (float)_backingWidth	  / width;
            const float dd      = MIN(dH, dW);
            const float h       = (height * dd / (float)_backingHeight);
            const float w       = (width  * dd / (float)_backingWidth );
            
            _vertices[0] = - w;
            _vertices[1] = - h;
            _vertices[2] =   w;
            _vertices[3] = - h;
            _vertices[4] = - w;
            _vertices[5] =   h;
            _vertices[6] =   w;
            _vertices[7] =   h;
            
            break;
        }
            
        default:{//满view
            const float h = 1.000;
            const float w = 1.000;
            
            _vertices[0] = - w;
            _vertices[1] = - h;
            _vertices[2] =   w;
            _vertices[3] = - h;
            _vertices[4] = - w;
            _vertices[5] =   h;
            _vertices[6] =   w;
            _vertices[7] =   h;
            
            break;
        }
            
            
    }
}

#pragma mark  *** AyVideoProtocol ***

- (void) setVideoFormat:(S_VIDEO_FORMAT*)foamat
{
    _format = *foamat;
}

- (void)renderVideo: (S_VIDEO_BUFFER *)frame
{
//    U_Player_Log(@"render Video");
    
    if (g_appEnterBackground || _isAppEnterBackground) {
        return;
    }
    
    if (_needRestartRender) {
        if([self.delegate respondsToSelector:@selector(startRender)]){
            [self.delegate startRender];
        }
        _needRestartRender = FALSE;
    }
    
#if OPEN_LOG
    static unsigned int render_count = 20;
    render_count ++;
    if (render_count > 20) {
        if (nil == g_logFilePath) {
            g_logFilePath = [NSString stringWithFormat:@"%@/%@", [[UAnYanLog sharedInstance] getLogFilePath], @"play_log.txt"];
        }
        [[UAnYanLog sharedInstance] writeLog:@"render video..." toFile:g_logFilePath];
        render_count = 0;
    }
#endif
    
    if (lastBgWidth != _backingWidth || lastBgHeight != _backingHeight) {
        [self layoutSubviews];
    }
    
    pthread_mutex_lock(&video_data_render_mutex);
    
    //get screenshot image
    if (isGetScreenshot) {
        //yuv420p to rgb32
        uint8_t *rgb_data = (uint8_t *)malloc(_format.iVideoWidth * _format.iVideoHeight * 3);
//        yuv420_2_rgb8888(rgb_data, frame->Buffer[0], frame->Buffer[1], frame->Buffer[2], _format.iVideoWidth, _format.iVideoHeight);
        yuv420p_to_rgb24_2(frame->Buffer, rgb_data, _format.iVideoWidth, _format.iVideoHeight);
//        YUV420p_to_RGB24(frame->Buffer, rgb_data, _format.iVideoWidth, _format.iVideoHeight);
        
        //rgb32 to uiimage
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
        CFDataRef cf_data_ref = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, rgb_data, _format.iVideoWidth * _format.iVideoHeight * 3, kCFAllocatorNull);//pict.linesize[0]*height
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(cf_data_ref);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGImageRef cgImage = CGImageCreate(_format.iVideoWidth,
                                           _format.iVideoHeight,
                                           8,
                                           24,
                                           _format.iVideoWidth * 3,
                                           colorSpace,
                                           bitmapInfo,
                                           provider,
                                           NULL,
                                           NO,
                                           kCGRenderingIntentDefault);
        CGColorSpaceRelease(colorSpace);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        CGDataProviderRelease(provider);
        CFRelease(cf_data_ref);
        if ([self.delegate respondsToSelector:@selector(player:didScreenshotImage:)]) {
            NSData *shotImageData = UIImageJPEGRepresentation(image, 0.5);
            UIImage *screenshotImage = [UIImage imageWithData:shotImageData];
            [self.delegate player:self didScreenshotImage:screenshotImage];
        }
        
        isGetScreenshot = FALSE;
        
        //free
        free(rgb_data);
    }
    
    if (lastPlayMode != _playMode) {
        lastPlayMode = _playMode;
        [self updateVertices];
    }
    
    static const GLfloat texCoords[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 0.0f,
    };
    
//    if (islayouting) {
//        return;
//    }
    
    [EAGLContext setCurrentContext:_context];
    
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glViewport(0, 0, _backingWidth * m_viewScale, _backingHeight * m_viewScale);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(_program);
    
    if (frame) {
#if 1
        [_renderer setFrame:frame withFormat:&_format];
#else
        int frame_status = [_renderer setFrame:frame withFormat:&_format];
        if (-1 == frame_status) {//fix green screen when start play
            pthread_mutex_unlock(&video_data_render_mutex);
            return;
        }
#endif
    }
    
    if ([_renderer prepareRender]) {
        
        GLfloat modelviewProj[16];
        mat4f_LoadOrtho(-1.0f, 1.0f, -1.0f, 1.0f, -1.0f, 1.0f, modelviewProj);
        glUniformMatrix4fv(_uniformMatrix, 1, GL_FALSE, modelviewProj);
        
        glVertexAttribPointer(ATTRIBUTE_VERTEX, 2, GL_FLOAT, 0, 0, _vertices);
        glEnableVertexAttribArray(ATTRIBUTE_VERTEX);
        glVertexAttribPointer(ATTRIBUTE_TEXCOORD, 2, GL_FLOAT, 0, 0, texCoords);
        glEnableVertexAttribArray(ATTRIBUTE_TEXCOORD);
        
        GLenum frame_buffer_status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if (frame_buffer_status != GL_FRAMEBUFFER_COMPLETE) {
            U_Player_Log(@"frame_buffers_status = %X", frame_buffer_status);
#if OPEN_LOG
            if (nil == g_logFilePath) {
                g_logFilePath = [NSString stringWithFormat:@"%@/%@", [[UAnYanLog sharedInstance] getLogFilePath], @"play_log.txt"];
            }
            [[UAnYanLog sharedInstance] writeLog:[NSString stringWithFormat:@"Frame buffer status = %X, self = %p", frame_buffer_status, self] toFile:g_logFilePath];
#endif
            
            if (frame_buffer_status == GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT || frame_buffer_status == GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT) { //当多个实例对像（AyMovieGLView）存在，其中一个对像被释放会造成其它实例对像无法渲染，需重新创建
                [self destroyMovieContext];
                [self CreateMovieContext];
            }
        }
        
        
#if 0
        if (!validateProgram(_program))
        {
            LoggerVideo(0, @"Failed to validate program");
            return;
        }
#endif
        
        if (frame) {
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        }
        
        glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
        [_context presentRenderbuffer:GL_RENDERBUFFER];
    }
    
    pthread_mutex_unlock(&video_data_render_mutex);
    
}

#pragma mark  *** AyAudioProtocol ***
#if AUDIO_PLAY
static AudioFormat audio_format;
#endif
-(void)SetAudioFormat:(AYMediaAudioFormat *)frame
{
    //    id<AyAudioManager> audioManager = [AyAudioManager audioManager];
    //    [audioManager activateAudioSession:frame->Channels with_samepleRate:frame->SampleRate with_SampleBits:frame->SampleBits];
    //init audio and video buffer
    
#if AUDIO_PLAY
    U_Player_Log(@"set audio format...");
    U_Player_Log(@"sample rate = %i, channel = %i, sample bites = %i", frame->nSamplesPerSec, frame->nChannels, frame->wBitsPerSample);
    audio_format.mSampleRate = frame->nSamplesPerSec;
    audio_format.mChannelsPerFrame = frame->nChannels;
    audio_format.mBitsPerChannel = frame->wBitsPerSample;
#endif
}
-(void)PlayAudio
{
    //    id<AyAudioManager> audioManager = [AyAudioManager audioManager];
    //
    //    audioManager.outputBlock = ^(float *outData, UInt32 numFrames, UInt32 numChannels) {
    //        [self audioCallbackFillData:outData with_numFrame:numFrames with_numChannel:numChannels];
    //    };
    //
    //    [audioManager play];
    
#if AUDIO_PLAY
    U_Player_Log(@"play audio....");
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [[ReceiveStreamingData   getInstance] setSampleRate:lastSampleRate];
        [[ReceiveStreamingData   getInstance] setAudioFormat:audio_format];
        [[ReceiveStreamingData   getInstance] startPlay];
        [[ReceiveStreamingData   getInstance] setAudioVolume:20];
    });
    
#endif
}

-(void)PauseAudio{

}

-(int)RenderAudio:(unsigned char*)pData with_len:( unsigned int)ulDataSize
{
    //缓存数据
    
#if AUDIO_PLAY
//    U_Player_Log(@"curent audio queue packet size = %i", [[ReceiveStreamingData getInstance] getAudioQueueSize]);
//    U_Player_Log(@"add pData len:%i", ulDataSize);
    if ([[ReceiveStreamingData getInstance] getAudioQueueSize] > 3) {
        return 1;//tell player sdk to retry
    }
//    U_Log(@"audio data size = %i", ulDataSize);
    //    printf("\n");
    //    for (int i = 0; i < ulDataSize / 4; i++) {
    //        printf("%X ", (unsigned int)pData[i]);
    //    }
    //    printf("\n");
    //    receive_audio_streaming_data(pData, ulDataSize);
    //    NSLog(@"render audio, data len = %d", ulDataSize);
    NSMutableData *one_fame_video_data = [[NSMutableData alloc] initWithBytes:pData length:ulDataSize];
    [[ReceiveStreamingData getInstance] addAudioPacketToQueue:one_fame_video_data];
#endif
    return 0;
    
}

-(void)Stop{
#if AUDIO_PLAY
    U_Player_Log(@"stop audio.....");
    dispatch_async(dispatch_get_main_queue(), ^{
        [ReceiveStreamingData freeInstance];
    });
#endif
}


@end

#endif
