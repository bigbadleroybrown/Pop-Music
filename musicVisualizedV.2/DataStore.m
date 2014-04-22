//
//  DataStore.m
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 4/21/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

+ (instancetype)sharedDataStore {
    static DataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[DataStore alloc] init];
    });
    
    return _sharedDataStore;
}


@end
