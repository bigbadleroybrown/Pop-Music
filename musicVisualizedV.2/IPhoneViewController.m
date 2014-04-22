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

@interface IPhoneViewController ()

-(void)playButtonTapped;


@end

@implementation IPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake(50.0, 50.0, 50.0, 50.0);
    [playButton addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    
    [self.view addSubview:playButton];
    
    
    
    // Do any additional setup after loading the view.
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
