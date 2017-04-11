//
//  HistoryDataController.m
//  WeatherApp
//
//  Created by Potter on 11/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "HistoryDataController.h"
#import "HeaderConstants.h"

@implementation HistoryDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _historyArray = [[[NSUserDefaults standardUserDefaults] objectForKey:CITY_HISTORY_ARRAY] mutableCopy];
    }
    return self;
}

@end
