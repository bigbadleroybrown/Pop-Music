//
//  AirplayViewController.m
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 4/18/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "AirplayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FISVisualizerView.h"
#import "ViewController.h"


@interface AirplayViewController ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) FISVisualizerView *visualizer;
@property (strong, nonatomic) GVMusicPlayerController *musicPlayer;


@end

@implementation AirplayViewController

{

    BOOL _isPlaying;
    
}

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    [self configureAudioSession];
    [self configureAirplayView];
    
    self.visualizer = [[FISVisualizerView alloc] initWithFrame:self.view.frame];
    [_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView addSubview:_visualizer];

    
}

-(void)configureAirplayView

{
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    CGRect frame = self.view.frame;
    
    self.backgroundView = [[UIView alloc] initWithFrame:frame]; //defines the background view
    [_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:_backgroundView];
}

#pragma mark - Music control

- (void)playPause

{
    if (_isPlaying)
    
    {
        
        [_audioPlayer pause];
        
    }
    
    else
    
    {
    
        [_audioPlayer play];
    
    }

    _isPlaying = !_isPlaying;
}

-(void)skipToNextItem

{
    
    
    
}

- (void)playURL:(NSURL *)url

{
    if (_isPlaying) {
        
        [self playPause];
    }
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [_audioPlayer setNumberOfLoops:-1];
    [_audioPlayer setMeteringEnabled:YES];
    [_visualizer setAudioPlayer:_audioPlayer];
    
    [self playPause];
}


#pragma mark - Configure AV Audio Player

-(void)configureAudioSession

{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    if (error) {
        NSLog(@"Error setting Category: %@", [error description]);
    }
}


- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


