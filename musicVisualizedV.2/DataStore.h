//
//  DataStore.h
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 4/21/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AirplayViewController.h"
#import "ViewController.h"

@interface DataStore : NSObject

@property (strong, nonatomic) AirplayViewController *airplayViewController;
@property (strong, nonatomic) ViewController *viewController;

+ (instancetype)sharedDataStore;

@end
