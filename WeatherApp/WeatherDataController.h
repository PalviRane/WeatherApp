//
//  WeatherDataController.h
//  WeatherApp
//
//  Created by Potter on 10/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"
#import "WrapperManager.h"

@interface WeatherDataController : NSObject

@property(nonatomic,retain) Weather *weather;

-(void)getLocationKeyWithSuccess:(void(^)(void)) onSuccess onFailure:(void (^)(void)) onFailure;

@end
