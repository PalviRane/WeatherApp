//
//  WeatherWrapper.m
//  WeatherApp
//
//  Created by Potter on 10/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "WeatherWrapper.h"

@implementation WeatherWrapper

-(void)getLocationKeyUsingCityName:(NSString *)cityName onSuccess:(void (^) (NSString *))onSuccess onFailure:(void (^) (void))onFailure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,GET_LOCATION_KEY_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSDictionary *requestParameters = @{@"apikey":ACCU_API_KEY, @"q":cityName};
     __weak typeof(self) weakSelf = self;
    
    [manager GET:urlStr parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id  responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201){
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            
            NSString *locationKey = [strongSelf getLocationKeyFromDictionary:responseDict];
            
            if(locationKey && locationKey.length != 0)
            {
                
                onSuccess(locationKey);
                
            }
            else{
                
                onFailure();
            }
            
        }
        else{
            
            onFailure();
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        onFailure();
    }];

}

-(NSString *)getLocationKeyFromDictionary:(NSDictionary *)responseDictionary
{
    NSString *locattionKeyString;
    
    if([responseDictionary valueForKey:@"Key"])
    {
        locattionKeyString = [responseDictionary valueForKey:@"Key"];
    }
    return locattionKeyString;
}



-(void)getCityWeatherUsingLocationKey:(NSString *)locationKey onSuccess:(void (^) (Weather *))onSuccess onFailure:(void (^) (void))onFailure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL,DAILY_WEATHER_URL,locationKey];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSDictionary *requestParameters = @{@"apikey":ACCU_API_KEY};
    __weak typeof(self) weakSelf = self;
    
    [manager GET:urlStr parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id  responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201){
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            
            Weather *weather = [strongSelf getWeatherObjectFromWeatherDictionary:responseDict];
            
            if(weather)
            {
                
                onSuccess(weather);
                
            }
            else{
                
                onFailure();
            }
            
        }
        else{
            
            onFailure();
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        onFailure();
    }];
    
}

-(Weather *)getWeatherObjectFromWeatherDictionary:(NSDictionary *)responseDictionary
{
    Weather *weather = [[Weather alloc] init];
    
    if ([responseDictionary valueForKey:@"Headline"])
    {
        weather.weatherSummary = [[responseDictionary valueForKey:@"Headline"] valueForKey:@"Text"];
    }
    
    if ([responseDictionary valueForKey:@"DailyForecasts"])
    {
        weather.minTemprature = [[[[responseDictionary valueForKey:@"DailyForecasts"] valueForKey:@"Temperature"] valueForKey:@"Minimum"] valueForKey:@"Value"];
        
        weather.maxTemprature = [[[[responseDictionary valueForKey:@"DailyForecasts"] valueForKey:@"Temperature"] valueForKey:@"Maximum"] valueForKey:@"Value"];
        
        weather.tempratureUnit = [[[[responseDictionary valueForKey:@"DailyForecasts"] valueForKey:@"Temperature"] valueForKey:@"Maximum"] valueForKey:@"Unit"];
    }
    
    if ([responseDictionary valueForKey:@"Day"])
    {
        weather.dayIcon = [[responseDictionary valueForKey:@"Day"] valueForKey:@"Icon"];
        weather.dayText = [[responseDictionary valueForKey:@"Day"] valueForKey:@"IconPhrase"];
    }
    
    if ([responseDictionary valueForKey:@"Night"])
    {
        weather.nightIcon = [[responseDictionary valueForKey:@"Night"] valueForKey:@"Icon"];
        weather.nightText = [[responseDictionary valueForKey:@"Day"] valueForKey:@"IconPhrase"];
    }
    
    return weather;
}

-(void)saveUserImageInDocumentsLibrary:(UIImage *)userImage
{
    NSData *pngData = UIImagePNGRepresentation(userImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"profileImage.png"]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
}

-(UIImage *)getUserImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"profileImage.png"];
    
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    UIImage *userImage = [UIImage imageWithData:pngData];
    
    if (userImage) {
        return userImage;
    }
    else
    {
        return [UIImage imageNamed:@"User"];
    }
    
}

@end
