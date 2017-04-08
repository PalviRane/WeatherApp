//
//  SignInDataController.m
//  WeatherApp
//
//  Created by Potter on 07/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "SignInDataController.h"

@implementation SignInDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _weatherArray = [[NSMutableArray alloc] initWithObjects:@"WLP_Rain", @"WLP_Cloud", @"WLP_Clear", @"WLP_Snow", @"WLP_Storm", @"WLP_Sun", nil];
    }
    return self;
}


@end
