//
//  WelcomeDataController.m
//  WeatherApp
//
//  Created by Potter on 10/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "WelcomeDataController.h"
#import "WrapperManager.h"
#import "HeaderConstants.h"

@implementation WelcomeDataController

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

-(void)createCityArrayToSavHistoryWithCityName:(NSString *)cityName
{
    NSMutableArray *historyArray = [[NSMutableArray alloc] init];
    
    [historyArray addObject:cityName];
    
    [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:CITY_HISTORY_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
