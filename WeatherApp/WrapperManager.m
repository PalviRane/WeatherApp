//
//  WrapperManager.m
//  WeatherApp
//
//  Created by Potter on 10/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "WrapperManager.h"

@implementation WrapperManager

//custom init
-(instancetype) init
{
    self = [super init];
    
    if (self) {
        
        // initialize wrappers
        [self initWrappers];
        
        return self;
    }
    
    return nil;
}

-(void) initWrappers
{
    _weatherWrapper = [[WeatherWrapper alloc] init];
}

+(WrapperManager*) sharedInstance
{
    static WrapperManager* sharedInstance = nil;
    
    // recommended style for singleTon by apple
    static dispatch_once_t onceToken;
    
    // executes only once
    dispatch_once(&onceToken,
                  ^{
                      sharedInstance = [[WrapperManager alloc] init];
                  });
    //return the instance
    return sharedInstance;
    
}

@end
