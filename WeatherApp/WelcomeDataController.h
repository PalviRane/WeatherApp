//
//  WelcomeDataController.h
//  WeatherApp
//
//  Created by Potter on 10/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WelcomeDataController : NSObject

-(void)getLocationKeyWithSuccess:(void(^)(void)) onSuccess onFailure:(void (^)(void)) onFailure;

-(void)createCityArrayToSavHistoryWithCityName:(NSString *)cityName;


@end
