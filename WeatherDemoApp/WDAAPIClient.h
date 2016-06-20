//
//  WDAAPIClient.h
//  WeatherDemoApp
//
//  Created by Jennifer A Sipila on 6/16/16.
//  Copyright © 2016 Jennifer A Sipila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WDAAPIClient : NSObject

//+ (void) getCurrentForecastWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude Completion: (void (^)(NSArray *forecastData))completionBlock;

+ (void) getDailyForecastWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude Completion: (void (^)(NSArray *forecastData))completionBlock;

@end
