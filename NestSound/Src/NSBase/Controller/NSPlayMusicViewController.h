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
<<<<<<< HEAD
@property (nonatomic, weak) AVAudioPlayer *player;

=======
@property (nonatomic,assign) long itemId;
>>>>>>> 8ff0d3ed362e127638692d1da38fcefd04c4fc5d
=======
@property (nonatomic,assign) long itemId;

@property (nonatomic, weak) AVAudioPlayer *player;

>>>>>>> d872db4b56cf2f2addb592107ed92f74ea0db553
@end
