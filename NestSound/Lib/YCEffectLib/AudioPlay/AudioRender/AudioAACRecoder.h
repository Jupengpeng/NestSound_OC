
#import <Foundation/Foundation.h>

@class AudioAACRecoder;
@protocol AudioAACRecoderProtocol <NSObject>
-(void)onRecoderComplete:(AudioAACRecoder*)recoder aacData:(NSData*)data;
@end

@interface AudioAACRecoder : NSObject
@property (nonatomic,readonly) BOOL   isStop;
@property (nonatomic,weak)     id     delegate;
//声波渲染协议
@property(nonatomic,weak) id audioWaveProtocol;
-(BOOL)start;
-(BOOL)stop;
-(BOOL)cancel;
-(short)getInstantaneousAmplitude;
@end
