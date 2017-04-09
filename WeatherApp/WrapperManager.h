//
//  WrapperManager.h
//  WeatherApp
//
//  Created by Potter on 10/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WeatherWrapper.h"

#import "Weather.h"

@class WeatherWrapper;

@interface WrapperManager : NSObject

@property(strong,nonatomic) WeatherWrapper *weatherWrapper;

+(WrapperManager*) sharedInstance;

@end
