//
//  WeatherWrapper.h
//  WeatherApp
//
//  Created by Potter on 10/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"
#import "HeaderConstants.h"
#import <AFNetworking.h>

@interface WeatherWrapper : NSObject

-(void)getLocationKeyUsingCityName:(NSString *)cityName onSuccess:(void (^) (NSString *))onSuccess onFailure:(void (^) (void))onFailure;

-(void)getCityWeatherUsingLocationKey:(NSString *)locationKey onSuccess:(void (^) (Weather *))onSuccess onFailure:(void (^) (void))onFailure;

@end
