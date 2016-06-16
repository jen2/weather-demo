//
//  WDAAPIClient.m
//  WeatherDemoApp
//
//  Created by Jennifer A Sipila on 6/16/16.
//  Copyright © 2016 Jennifer A Sipila. All rights reserved.
//

#import "WDAAPIClient.h"

@implementation WDAAPIClient

//https://api.forecast.io/forecast/APIKEY/LATITUDE,LONGITUDE


//TO DO: Complete api class method to get forecast data, run url through postman to see what JSON is returned and parse this JSON.  Check on how to get a users current location and try to implement this at startup.


+ (void) getForecastWithLatitude:(NSString *)latitude Longitude:(NSString *)longitude Completion: (void (^)(NSArray *marsImages))completionBlock
{
    NSString *apiKey = @"";
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%@,%@", apiKey, latitude, longitude];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET: urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if(responseObject) {
            
            NSDictionary *imageDictionaries = responseObject;
            
            NSArray *picURLArray = [imageDictionaries valueForKeyPath:@"photos.img_src"];
            
            completionBlock(picURLArray);
            
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
