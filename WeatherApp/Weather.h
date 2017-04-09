//
//  Weather.h
//  WeatherApp
//
//  Created by Potter on 10/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property(nonatomic,retain) NSString *weatherSummary;
@property(nonatomic,retain) NSNumber *minTemprature;
@property(nonatomic,retain) NSNumber *maxTemprature;
@property(nonatomic,retain) NSString *tempratureUnit;
@property(nonatomic,retain) NSString *dayText;
@property(nonatomic,retain) NSNumber *dayIcon;
@property(nonatomic,retain) NSString *nightText;
@property(nonatomic,retain) NSNumber *nightIcon;


@end
