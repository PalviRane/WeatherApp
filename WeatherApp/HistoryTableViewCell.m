//
//  HistoryTableViewCell.m
//  WeatherApp
//
//  Created by Potter on 11/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupHistoryCellWithCityName:(NSString *)cityName
{
    _seperatorView.backgroundColor = [self setRandomBackgroundColor];
    _cityNameLabel.text = cityName;
}

-(UIColor *)setRandomBackgroundColor
{
    int min = 0;
    int max = 10;
    
    UIColor *randomColor;
    
    int randNum = min + arc4random_uniform(max - min + 1);
    
    switch (randNum)
    {
        case 0:
            randomColor = PINK_COLOR;
            break;
            
        case 1:
            randomColor = ORANGE_COLOR;
            break;
            
            
        case 2:
            randomColor = GREEN_COLOR;
            break;
            
        case 3:
            randomColor = BEIGE_COLOR;
            break;
            
        case 4:
            randomColor = LIGHT_GRAY_COLOR;
            break;
            
        case 5:
            randomColor = DARK_BLUE_COLOR;
            break;
            
        case 6:
            randomColor = LIGHT_BLUE_COLOR;
            break;
            
        case 7:
            randomColor = SKY_BLUE_COLOR;
            break;
            
        case 8:
            randomColor = DARK_GRAY_COLOR;
            break;
            
        case 9:
            randomColor = PURPLE_COLOR;
            break;
            
        case 10:
            randomColor = BROWN_COLOR;
            break;
            
        default: randomColor = DARK_BLUE_COLOR;
            break;
    }
    
    return randomColor;
    
}


@end
