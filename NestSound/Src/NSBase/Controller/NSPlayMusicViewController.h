//
//  NSPlayMusicViewController.h
//  NestSound
//
//  Created by Apple on 16/5/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface NSPlayMusicViewController : NSBaseViewController

+ (instancetype)sharedPlayMusic;

<<<<<<< HEAD
@property (nonatomic, weak) AVAudioPlayer *player;

=======
@property (nonatomic,assign) long itemId;
>>>>>>> 8ff0d3ed362e127638692d1da38fcefd04c4fc5d
@end
