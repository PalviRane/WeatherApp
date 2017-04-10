//
//  WeatherDataController.m
//  WeatherApp
//
//  Created by Potter on 10/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "WeatherDataController.h"
#import "HeaderConstants.h"

@implementation WeatherDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)getLocationKeyWithSuccess:(void(^)(void)) onSuccess onFailure:(void (^)(void)) onFailure
{
    [[WrapperManager sharedInstance].weatherWrapper getCityWeatherUsingLocationKey:[[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_LOCATION_KEY] onSuccess:^(Weather *weather) {
        
        _weather = weather;
        onSuccess();
        
    } onFailure:^{
        
        onFailure();
    }];
}

@end
