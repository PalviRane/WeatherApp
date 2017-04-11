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

-(void)modifyHistoryArrayWithCityName:(NSString *)cityName
{
    NSMutableArray *historyArray;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:CITY_HISTORY_ARRAY])
    {
         historyArray = [[[NSUserDefaults standardUserDefaults] objectForKey:CITY_HISTORY_ARRAY] mutableCopy];
        
        BOOL isCityNamePresent = [historyArray containsObject: cityName];
        
        if (!isCityNamePresent)
        {
            [historyArray addObject:cityName];
        }
    }
   else
   {
       historyArray = [[NSMutableArray alloc] init];
       [historyArray addObject:cityName];
   }
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:CITY_HISTORY_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
