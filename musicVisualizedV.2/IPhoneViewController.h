//
//  IPhoneViewController.h
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 4/18/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface IphoneViewController : UIViewController <MPMediaPickerControllerDelegate>

- (void)pickSong;
- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *) collection;

@end
