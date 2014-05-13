//
//  FISVisualizerView.h
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 3/14/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "GVMusicPlayerController.h"

@interface FISVisualizerView : UIView

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property CGPoint currentLocation;
@property (strong, nonatomic) CAEmitterCell *cell;




@end
