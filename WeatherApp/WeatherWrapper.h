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
#import <AFNetworking/AFNetworking.h>

@interface WeatherWrapper : NSObject

-(void)getLocationKeyUsingCityName:(NSString *)cityName onSuccess:(void (^) (NSString *locationKey))onSuccess onFailure:(void (^) (void))onFailure;

-(void)getCityWeatherUsingLocationKey:(NSString *)locationKey onSuccess:(void (^) (Weather *weather))onSuccess onFailure:(void (^) (void))onFailure;

-(void)saveUserImageInDocumentsLibrary:(UIImage *)userImage;

-(UIImage *)getUserImage;

@end
