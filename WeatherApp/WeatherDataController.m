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

-(void)getCurrentLocationWeatherWithSuccess:(void(^)(void)) onSuccess onFailure:(void (^)(void)) onFailure
{
    [[WrapperManager sharedInstance].weatherWrapper getCityWeatherUsingLocationKey:[[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_LOCATION_KEY] onSuccess:^(Weather *weather) {
        
        _weather = weather;
        onSuccess();
        
    } onFailure:^{
        
        onFailure();
    }];
}

-(void)getLocationKeyWithSuccess:(void(^)(void)) onSuccess onFailure:(void (^)(void)) onFailure
{
    [[WrapperManager sharedInstance].weatherWrapper getLocationKeyUsingCityName:[[NSUserDefaults standardUserDefaults] valueForKey:CITY_NAME] onSuccess:^(NSString *locationKey) {
        
        [[NSUserDefaults standardUserDefaults] setValue:locationKey forKey:CURRENT_LOCATION_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        onSuccess();
    } onFailure:^{
        
        onFailure();
    }];
}


@end
