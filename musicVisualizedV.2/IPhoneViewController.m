//
//  IPhoneViewController.m
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 4/18/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "IPhoneViewController.h"
#import "AirplayViewController.h"
#import "DataStore.h"

@interface IphoneViewController ()

-(void)playButtonTapped;


@end

@implementation IphoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake(50.0, 50.0, 50.0, 50.0);
    [playButton addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    
    UIButton *pickSong = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pickSong.frame = CGRectMake(50.0, 100.0, 100.0, 100.0);
    [pickSong addTarget:self action:@selector(pickSong) forControlEvents:UIControlEventTouchUpInside];
    [pickSong setTitle:@"Pick Song" forState:UIControlStateNormal];
    
    
    [self.view addSubview:pickSong];
    [self.view addSubview:playButton];
    
    
    
    // Do any additional setup after loading the view.
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
    
    // grab the first selection
    MPMediaItem *item = [[collection items] objectAtIndex:0];
    //    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
    //    [_navBar.topItem setTitle:title];
    
    // get a URL reference to the selected item
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    // pass the URL to playURL
    
    DataStore *dataStore = [DataStore sharedDataStore];
    
    AirplayViewController *airplayVC = dataStore.airplayViewController;
 
    [airplayVC playURL:url];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *) mediaPicker

{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)playButtonTapped
{
    
    DataStore *dataStore =[DataStore sharedDataStore];
    
    AirplayViewController *airplayVC = dataStore.airplayViewController;
    
    [airplayVC playPause];
    
}

//-(void)pickSongTapped
//{
//    
//    DataStore *dataStore = [DataStore sharedDataStore];
//    
//    AirplayViewController *airplayVC = dataStore.airplayViewController;
//    
//    [airplayVC pickSong];
//    
//}




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

//big ass play button
//
