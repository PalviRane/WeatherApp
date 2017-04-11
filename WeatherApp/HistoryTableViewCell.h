//
//  HistoryTableViewCell.h
//  WeatherApp
//
//  Created by Potter on 11/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"
#import "HeaderConstants.h"

@interface HistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;


-(void)setupHistoryCellWithCityName:(NSString *)cityName;

@end
