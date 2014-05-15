//
//  ViewController.m
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 3/14/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "ViewController.h"
#import "GVMusicPlayerController.h"
#import "NSString+TimeToString.h"
#import "AirplayViewController.h"
#import "DataStore.h"
#import "UIViewController+AGBlurTransition.h"
#import "FBShimmeringView.h"
#import "FISAppDelegate.h"


@interface ViewController () <GVMusicPlayerControllerDelegate, MPMediaPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UILabel *trackCurrentPlaybackTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *shimmerViewController;
@property (weak, nonatomic) IBOutlet UILabel *trackLengthLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
//@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
//@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *centerView;
@property (weak, nonatomic) IBOutlet UIButton *airplayButton;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *musicControlView;


@property BOOL panningProgress;
@property BOOL panningVolume;
@property BOOL displayingFront;
@end

@implementation ViewController

{
    BOOL _isBarHiding;
    BOOL displayingFront;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:self.chooseView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timedJob) userInfo:nil repeats:YES];
    [self.timer fire];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupShimmerView];
    
    self.displayingFront = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    // NOTE: add and remove the GVMusicPlayerController delegate in
    // the viewWillAppear / viewDidDisappear methods, not in the
    // viewDidLoad / viewDidUnload methods - it will result in dangling
    // objects in memory.
    [super viewWillAppear:animated];
    [[GVMusicPlayerController sharedInstance] addDelegate:self];

}

- (void)viewDidDisappear:(BOOL)animated {
    [[GVMusicPlayerController sharedInstance] removeDelegate:self];
    [super viewDidDisappear:animated];
}

- (void)timedJob {
    if (!self.panningProgress) {
        self.progressSlider.value = [GVMusicPlayerController sharedInstance].currentPlaybackTime;
        self.trackCurrentPlaybackTimeLabel.text = [NSString stringFromTime:[GVMusicPlayerController sharedInstance].currentPlaybackTime];
    }
}

#pragma mark - Catch remote control events, forward to the music player

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.shuffleButton.selected = ([GVMusicPlayerController sharedInstance].shuffleMode != MPMusicShuffleModeOff);
    [self setCorrectRepeatButtomImage];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [self configureBars];

}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    [[GVMusicPlayerController sharedInstance] remoteControlReceivedWithEvent:receivedEvent];
}

#pragma mark - IBActions

-(IBAction)visualizerPressed
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(20, 20, 200, 50)];
    [volumeView setShowsVolumeSlider:NO];
    [volumeView setShowsRouteButton:YES];
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];
}

- (IBAction)playButtonPressed {

    [self checkAirplayStatus];
    
    
    //    if ([GVMusicPlayerController sharedInstance].playbackState == MPMusicPlaybackStatePlaying) {
//        [[GVMusicPlayerController sharedInstance] pause];
//        DataStore *dataStore = [DataStore sharedDataStore];
//        AirplayViewController *airplayVC = dataStore.airplayViewController;
//        [airplayVC playPause];
//    } else {
//        [[GVMusicPlayerController sharedInstance] play];
//        DataStore *dataStore = [DataStore sharedDataStore];
//        AirplayViewController *airplayVC = dataStore.airplayViewController;
//        [airplayVC playPause];
//    }
}

- (IBAction)prevButtonPressed {
    [[GVMusicPlayerController sharedInstance] skipToPreviousItem];
}

- (IBAction)nextButtonPressed {
    [[GVMusicPlayerController sharedInstance] skipToNextItem];
}

- (IBAction)chooseButtonPressed {
    
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    picker.delegate = self;
    picker.allowsPickingMultipleItems = YES;
    picker.transitioningDelegate = self.AG_blurTransitionDelegate;
    [self presentViewController:picker animated:YES completion:NULL];
   

}

- (IBAction)playEverythingButtonPressed {

    MPMediaQuery *query = [MPMediaQuery songsQuery];
    [[GVMusicPlayerController sharedInstance] setQueueWithQuery:query];
//    [[GVMusicPlayerController sharedInstance] play];
    [self checkAirplayStatus];
}

- (IBAction)volumeChanged:(UISlider *)sender {
    self.panningVolume = YES;
    [GVMusicPlayerController sharedInstance].volume = sender.value;
}

- (IBAction)volumeEnd {
    self.panningVolume = NO;
}

- (IBAction)progressChanged:(UISlider *)sender {
    // While dragging the progress slider around, we change the time label,
    // but we're not actually changing the playback time yet.
    self.panningProgress = YES;
    self.trackCurrentPlaybackTimeLabel.text = [NSString stringFromTime:sender.value];
}

- (IBAction)progressEnd {
    // Only when dragging is done, we change the playback time.
    [GVMusicPlayerController sharedInstance].currentPlaybackTime = self.progressSlider.value;
    self.panningProgress = NO;
}

//- (IBAction)shuffleButtonPressed {
//    self.shuffleButton.selected = !self.shuffleButton.selected;
//
//    if (self.shuffleButton.selected) {
//        [GVMusicPlayerController sharedInstance].shuffleMode = MPMusicShuffleModeSongs;
//    } else {
//        [GVMusicPlayerController sharedInstance].shuffleMode = MPMusicShuffleModeOff;
//    }
//}
//
//- (IBAction)repeatButtonPressed {
//    switch ([GVMusicPlayerController sharedInstance].repeatMode) {
//        case MPMusicRepeatModeAll:
//            // From all to one
//            [GVMusicPlayerController sharedInstance].repeatMode = MPMusicRepeatModeOne;
//            break;
//
//        case MPMusicRepeatModeOne:
//            // From one to none
//            [GVMusicPlayerController sharedInstance].repeatMode = MPMusicRepeatModeNone;
//            break;
//
//        case MPMusicRepeatModeNone:
//            // From none to all
//            [GVMusicPlayerController sharedInstance].repeatMode = MPMusicRepeatModeAll;
//            break;
//
//        default:
//            [GVMusicPlayerController sharedInstance].repeatMode = MPMusicRepeatModeAll;
//            break;
//    }
//
//    [self setCorrectRepeatButtomImage];
//}

- (void)setCorrectRepeatButtomImage {
    NSString *imageName;

    switch ([GVMusicPlayerController sharedInstance].repeatMode) {
        case MPMusicRepeatModeAll:
            imageName = @"Track_Repeat_On";
            break;

        case MPMusicRepeatModeOne:
            imageName = @"Track_Repeat_On_Track";
            break;

        case MPMusicRepeatModeNone:
            imageName = @"Track_Repeat_Off";
            break;

        default:
            imageName = @"Track_Repeat_Off";
            break;
    }

  //  [self.repeatButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}


-(IBAction)homeTapped
{
    [UIView transitionWithView:self.chooseView
                      duration:1.0
                       options:(self.displayingFront ? UIViewAnimationOptionTransitionFlipFromRight :
                                UIViewAnimationOptionTransitionFlipFromLeft)
                    animations: ^{
                        if(self.displayingFront)
                        {
                            self.bottomView.hidden = false;
                            self.topView.hidden = false;
                            self.chooseView.hidden = false;
                        }
//                        else
//                        {
//                            self.chooseView.hidden = false;
//                            self.topView.hidden = false;
//                            self.bottomView.hidden = false;
//                        }
                    }
     
                    completion:^(BOOL finished) {
                        if (finished) {
                            displayingFront = !displayingFront;
                        }
                    }];
}

#pragma mark - Toggle Bars

-(void)configureBars

{
    _isBarHiding = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tapGR];

}

- (void)toggleBars {
  
    
    CGFloat topBarDis = 150;
    CGFloat bottomBarDis = -150;
    
    if(_isBarHiding ) {
        topBarDis = -topBarDis;
        bottomBarDis = -bottomBarDis;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGPoint topBarCenter = self.topView.center;
        topBarCenter.y += topBarDis;
        [self.topView setCenter:topBarCenter];
        
        
        CGPoint bottomBarCenter = self.bottomView.center;
        bottomBarCenter.y +=bottomBarDis;
        [self.bottomView setCenter:bottomBarCenter];
    }];
    
    _isBarHiding = !_isBarHiding;

    
}
- (void)tapGestureHandler:(UITapGestureRecognizer *)tapGR {
    [self toggleBars];
    
    NSLog(@"I was tapped");
}


#pragma mark - AVMusicPlayerControllerDelegate

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer playbackStateChanged:(MPMusicPlaybackState)playbackState previousPlaybackState:(MPMusicPlaybackState)previousPlaybackState {
    self.playPauseButton.selected = (playbackState == MPMusicPlaybackStatePlaying);
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer trackDidChange:(MPMediaItem *)nowPlayingItem previousTrack:(MPMediaItem *)previousTrack {
    if (!nowPlayingItem) {
        self.chooseView.hidden = NO;
        return;
    }

    self.chooseView.hidden = YES;

    // Time labels
    NSTimeInterval trackLength = [[nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    self.trackLengthLabel.text = [NSString stringFromTime:trackLength];
    self.progressSlider.value = 0;
    self.progressSlider.maximumValue = trackLength;

    // Labels
    self.songLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    self.artistLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];

    // Artwork
    MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        self.imageView.image = [artwork imageWithSize:self.imageView.frame.size];
    }

    NSLog(@"Proof that this code is being called, even in the background!");
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer endOfQueueReached:(MPMediaItem *)lastTrack {
    NSLog(@"End of queue, but last track was %@", [lastTrack valueForProperty:MPMediaItemPropertyTitle]);
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer volumeChanged:(float)volume {
    if (!self.panningVolume) {
        self.volumeSlider.value = volume;
    }
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)collection {
    [[GVMusicPlayerController sharedInstance] setQueueWithItemCollection:collection];
    [[GVMusicPlayerController sharedInstance] play];
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    MPMediaItem *item = [[collection items] objectAtIndex:0];
    
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    DataStore *dataStore = [DataStore sharedDataStore];
    
    AirplayViewController *airplayVC = dataStore.airplayViewController;
    
    [airplayVC playURL:url];
    
}

-(void)setupShimmerView

{
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.view.bounds];
    shimmeringView.shimmeringOpacity = 0.2;
    
    [self.shimmerViewController addSubview:shimmeringView];
    self.shimmerViewController.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"Pop Music", nil);
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:60.0];
    titleLabel.textColor = [UIColor blackColor];
    shimmeringView.contentView = titleLabel;
    
    shimmeringView.shimmering = YES;
}


-(void)checkAirplayStatus
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if ([delegate isAirplayActive]) {
        DataStore *dataStore = [DataStore sharedDataStore];
        AirplayViewController *airplayVC = dataStore.airplayViewController;
        [airplayVC playPause];
        [[GVMusicPlayerController sharedInstance] stop];
    }
    else
    {
        if ([GVMusicPlayerController sharedInstance].playbackState == MPMusicPlaybackStatePlaying) {
            
            [[GVMusicPlayerController sharedInstance] pause];
        } 
        
        else
            
        {
            [[GVMusicPlayerController sharedInstance] play];
        }
        
    }
    
}

@end
