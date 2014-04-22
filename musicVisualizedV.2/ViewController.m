//
//  FISViewController.m
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 3/14/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "ViewController.h"
#import "FISVisualizerView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) NSArray *playItems;
@property (strong, nonatomic) NSArray *pauseItems;
@property (strong, nonatomic) UIBarButtonItem *playBBI;
@property (strong, nonatomic) UIBarButtonItem *pauseBBI;
@property (strong, nonatomic) UIBarButtonItem *nextBBI;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) FISVisualizerView *visualizer;
@property (strong, nonatomic)   UISlider *colorSlider;

@end

@implementation ViewController

{
    BOOL _isBarHide;
    BOOL _isPlaying;
    BOOL _canInsertItem;
}

- (void)viewDidLoad

{

    [super viewDidLoad];
    [self configureBars];
    
    [self configureAudioSession];
    
    self.visualizer = [[FISVisualizerView alloc] initWithFrame:self.view.frame]; //creates the visualizer instance (view) that will fill parent view and adds it to the background view 
    [_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView addSubview:_visualizer];
    
    [self configureAudioPlayer];
}


- (void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    [self toggleBars];
}


- (void)configureBars

{
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    CGRect frame = self.view.frame;

    self.backgroundView = [[UIView alloc] initWithFrame:frame]; //defines the background view
    [_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:_backgroundView];
    
    // NavBar
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, -44, frame.size.width, 44)];
    [_navBar setBarStyle:UIBarStyleBlackTranslucent];
    [_navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    UINavigationItem *navTitleItem = [[UINavigationItem alloc] initWithTitle:@"Pop Music"];
    [_navBar pushNavigationItem:navTitleItem animated:NO];
    
    [self.view addSubview:_navBar];
    
    
    //Slider
//    
//    self.colorSlider = [[UISlider alloc] initWithFrame:frame2];
//    self.colorSlider.minimumValue = 0.0;
//    self.colorSlider.maximumValue = 10.0;
//    self.colorSlider.continuous = YES;
//    self.colorSlider.value = 25.0;
//    [self.colorSlider addTarget:self action:@selector(changeColors) forControlEvents:UIControlEventValueChanged];
//    //[_toolBar addSubview:_colorSlider];
    
    
    //[self.colorSlider setValue:0.5 animated:NO];
    
    // ToolBar
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 320, frame.size.width, 44)];
    [_toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [_toolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    
    UIBarButtonItem *pickBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pickSong)];
    
    self.playBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playPause)];
    
    self.pauseBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playPause)];
    
    UIBarButtonItem *leftFlexBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightFlexBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.playItems = [NSArray arrayWithObjects:pickBBI, leftFlexBBI, _playBBI, rightFlexBBI,nil];
    self.pauseItems = [NSArray arrayWithObjects:pickBBI, leftFlexBBI, _pauseBBI, rightFlexBBI, nil];
    
    [_toolBar setItems:_playItems];
    
    [self.view addSubview:_toolBar];
    //[self.view addSubview:_colorSlider];
    
    
    _isBarHide = YES;
    _isPlaying = NO;
    _canInsertItem = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [_backgroundView addGestureRecognizer:tapGR];
}


- (void)toggleBars

{
    CGFloat navBarDis = -44;
    CGFloat toolBarDis = 44;
    if (_isBarHide ) {
        navBarDis = -navBarDis;
        toolBarDis = -toolBarDis;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint navBarCenter = _navBar.center;
        navBarCenter.y += navBarDis;
        [_navBar setCenter:navBarCenter];
        
        CGPoint toolBarCenter = _toolBar.center;
        toolBarCenter.y += toolBarDis;
        [_toolBar setCenter:toolBarCenter];
    }];
    
    _isBarHide = !_isBarHide;
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tapGR

{
    [self toggleBars];
}

#pragma mark - Music control

- (void)playPause
{
    if (_isPlaying)
    {
        // Pause audio here
        [_audioPlayer pause];
        [_toolBar setItems:_playItems];  // toggle play/pause button
    }
    else
    {
        // Play audio here
        [_audioPlayer play];
        [_toolBar setItems:_pauseItems]; // toggle play/pause button
    }
    _isPlaying = !_isPlaying;
}

- (void)playURL:(NSURL *)url

{
    if (_isPlaying) {
        
    [self playPause]; // Pause previous audio player
    
    }
    
    // Add audioPlayer configurations here
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [_audioPlayer setNumberOfLoops:-1];
    [_audioPlayer setMeteringEnabled:YES];
    [_visualizer setAudioPlayer:_audioPlayer];
    
    [self playPause];   // Play
}

#pragma mark - Media (song) Picker

- (void)pickSong
{
    
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [picker setDelegate:self];
    [picker setAllowsPickingMultipleItems: NO];
    [self presentViewController:picker animated:YES completion:NULL];
    
}

#pragma mark - Media Picker Delegate

- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *) collection
{
    
   
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // grab the first selection (media picker is capable of returning more than one selected item,
    // but this app only deals with one song at a time)
    MPMediaItem *item = [[collection items] objectAtIndex:0];
    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
    [_navBar.topItem setTitle:title];
    
    // get a URL reference to the selected item
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    // pass the URL to playURL
    [self playURL:url];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Configure AV Audio Player

-(void)configureAudioPlayer
{
    NSURL *audioFile = [[NSBundle mainBundle] URLForResource:@"Dreams - Fleetwood Mac (Psychemagik Remix)" withExtension:@"mp3"];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFile error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    [_audioPlayer setNumberOfLoops:-1];
    [_audioPlayer setMeteringEnabled:YES];
    [_visualizer setAudioPlayer:_audioPlayer];
}

-(void)configureAudioSession
{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    if (error) {
        NSLog(@"Error setting Category: %@", [error description]);
    }
}

-(void)changeColors
{
    //self.visualizer.cell.color = [[UIColor redColor] CGColor];
    
    //    CGFloat hue = ( arc4random() % 256 / 256.0 );
    //    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    //    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    //    self.visualizer.cell.color = [[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1] CGColor];
    //    NSLog(@"%f",self.colorSlider.value);
    
}


@end
