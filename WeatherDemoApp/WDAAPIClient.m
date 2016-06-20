//
//  WDAAPIClient.m
//  WeatherDemoApp
//
//  Created by Jennifer A Sipila on 6/16/16.
//  Copyright © 2016 Jennifer A Sipila. All rights reserved.
//

#import "WDAAPIClient.h"
#import <AFNetworking/AFNetworking.h>

@implementation WDAAPIClient

//+ (void) getCurrentForecastWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude Completion: (void (^)(NSArray *forecastData))completionBlock
//{
//    NSString *apiKey = @"d3bd6abb0f3415a7a5e67adc462ff3b4";
//    
//    NSString *urlString = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%f,%f", apiKey, latitude, longitude];
//    
//    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
//    [sessionManager GET: urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        if(responseObject) {
//            NSDictionary *conditionsDictionaries = responseObject;
//            NSArray *currentForecastData = [conditionsDictionaries valueForKeyPath:@"currently"];
//            completionBlock(currentForecastData);
//            
//        } else {
//            NSLog(@"There was an error getting a response object from the API");
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        NSLog(@"\n\nError: %@ \n\n With code: %ld", error, error.code);
//        
//        if (error.code == -1009) {
//            //Handle internet connection issue
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"InternetConnectionError" object:nil userInfo:nil];
//        }
//        if (error.code == - 1011) {
//            //Handle lack of images issue
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageFetchingError" object:nil userInfo:nil];
//        }
//    }];
//}

+ (void) getDailyForecastWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude Completion: (void (^)(NSArray *forecastData))completionBlock
{
    NSString *apiKey = @"d3bd6abb0f3415a7a5e67adc462ff3b4";
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%f,%f", apiKey, latitude, longitude];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET: urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if(responseObject) {
            NSDictionary *conditionsDictionaries = responseObject;
            NSArray *dailyForecastData = [conditionsDictionaries valueForKeyPath:@"daily.data"];
            completionBlock(dailyForecastData);
            
        } else {
            NSLog(@"There was an error getting a response object from the API");
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"\n\nError: %@ \n\n With code: %ld", error, error.code);
        
        if (error.code == -1009) {
            //Handle internet connection issue
            [[NSNotificationCenter defaultCenter] postNotificationName:@"InternetConnectionError" object:nil userInfo:nil];
        }
        if (error.code == - 1011) {
            //Handle lack of images issue
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageFetchingError" object:nil userInfo:nil];
        }
    }];
}

@end
