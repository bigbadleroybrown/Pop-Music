//
//  FISAppDelegate.m
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 3/14/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "FISAppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@property (strong, nonatomic) ViewController *vc;
@property (strong, nonatomic) UIWindow *secondWindow;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:) name:UIScreenDidConnectNotification object:nil];
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.vc = [[ViewController alloc] init];
    
    [self.window setRootViewController:_vc];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)checkForExistingScreenAndInitializeIfPresent
{
    if ([[UIScreen screens] count] > 1)
    {
        // Get the screen object that represents the external display.
        UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
        // Get the screen's bounds so that you can create a window of the correct size.
        CGRect screenBounds = secondScreen.bounds;
        
        self.secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        self.secondWindow.screen = secondScreen;
        
        // Set up initial content to display...
        // Show the window.
        self.secondWindow.hidden = NO;
        

    }

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)handleScreenDidConnectNotification:(NSNotification *)aNotification
{
    
    UIScreen *newScreen = [aNotification object];
    CGRect screenBounds = newScreen.bounds;
    
    if (!self.secondWindow)
    {
        self.secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        self.secondWindow.screen = newScreen;
        
        ViewController *visualizer = [[ViewController alloc]init];
        
        // self.dataStore.airplayVC = [[airPlayViewController alloc] init];
        
        self.secondWindow.rootViewController = visualizer; //self.dataStore.airplayVC
        
        self.secondWindow.hidden = NO;
        
    }
    
}
// in IBAction for big ass play button
//[self.dataStore.airplayVC playpause]
@end
