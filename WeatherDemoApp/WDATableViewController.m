//
//  WDATableViewController.m
//  WeatherDemoApp
//
//  Created by Jennifer A Sipila on 6/15/16.
//  Copyright © 2016 Jennifer A Sipila. All rights reserved.
//

#import "WDATableViewController.h"
#import "WDAAPIClient.h"
#import "WDATableViewCustomCell.h"

@interface WDATableViewController ()

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic, strong) NSArray *forecastData;
@property (nonatomic, strong) NSMutableArray *forecastedTemperatures;
@property (nonatomic, strong) NSMutableArray *forecastedWindSpeeds;
@property (nonatomic, strong) NSMutableArray *forecastedPrecipProbabilities;
@property (nonatomic, strong) NSMutableArray *forecastedHumidities;
@property (nonatomic, strong) NSArray *allDatesOfThisWeek;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation WDATableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getLocation];
    [self getCurrentConditions];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WeatherApp-background-1.jpg"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.allDatesOfThisWeek = [self getWeekDates];
    self.tableView.allowsSelection = NO;
}

- (IBAction)refreshTable:(UIButton *)sender
{
    [self getCurrentConditions];
}

-(void) getCurrentConditions
{
    self.latitude = 43.000;
    self.longitude = -85.0000;
    
    [WDAAPIClient getDailyForecastWithLatitude:(CGFloat)self.latitude Longitude:(CGFloat)self.longitude Completion: ^(NSArray *forecastData) {
        self.forecastData = forecastData;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDATableViewCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleDayCell" forIndexPath:indexPath];
    
    NSArray *data = self.forecastData[indexPath.row];
    
    NSNumber *precipNum = [data valueForKeyPath:@"precipProbability"];
    NSNumber *humidityNum = [data valueForKeyPath:@"humidity"];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [numberFormatter setMinimumFractionDigits:1];
    NSString *precipPercentage = [numberFormatter stringFromNumber:precipNum];
    NSString *humidityPercentage = [numberFormatter stringFromNumber:humidityNum];
    NSString *temperatureString = [self getIntegerString:[data valueForKeyPath:@"temperatureMax"]];
    NSString *windString = [self getIntegerString:[data valueForKeyPath:@"windSpeed"]];

    cell.precipitationLabel.text = precipPercentage;
    cell.humidityLabel.text = humidityPercentage;
    cell.temperatureLabel.text = [NSString stringWithFormat: @"%@°", temperatureString];
    cell.windSpeedLabel.text = [NSString stringWithFormat:@"%@ mph", windString];
    cell.backgroundColor = [UIColor clearColor];
    cell.dateLabel.text = self.allDatesOfThisWeek[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.downArrow.hidden = NO;
        
    } else {
        
        cell.downArrow.hidden = YES;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height;
}

#pragma mark - Calculations for labels

- (NSString *) getPercentage:(NSString *)decimalString
{
    NSString *percentage = [decimalString substringFromIndex:2];
    return percentage;
}

-(NSString *) getIntegerString: (NSString *)string
{
    CGFloat floatValueFromString = [string floatValue];
    NSUInteger integerValue = (NSInteger) (floatValueFromString);
    return [NSString stringWithFormat:@"%lu", integerValue];
}

#pragma mark - Date formatting methods

- (NSString *) formatDate:(NSDate *) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MMMM d y"];
    NSString *formattedDate = [formatter stringFromDate:date];
    NSLog(@"%@", formattedDate);
    return formattedDate;
}

-(NSArray *) getWeekDates
{
    NSMutableArray *weekDates = [[NSMutableArray alloc] init];
    NSDate *now = [NSDate date];
    NSDate *previousDay = now;
    for(NSUInteger i = 0; i <= 7; i++) {
        if (i == 0) {
            
            NSString *formattedDate = [self formatDate: now];
            [weekDates addObject:formattedDate];
            
        } else {
            NSTimeInterval secondsInDay = 24 * 60 * 60;
            NSDate *nextDay = [NSDate dateWithTimeInterval:secondsInDay
                                                 sinceDate:previousDay];
            NSString *formattedDate = [self formatDate: nextDay];
            [weekDates addObject:formattedDate];
            previousDay = nextDay;
        }
    }
    return weekDates;
}

#pragma mark - Location service methods

- (void)getLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 500;
        
        [self.locationManager startUpdatingLocation];
        
    } else {
        [self alertForLocationServices];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

- (void) alertForLocationServices
{
    UIAlertController* locationServicesAlert = [UIAlertController alertControllerWithTitle:@"Location Services Error"
                                                                           message:@"Please enable location services and try again"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    [locationServicesAlert addAction:defaultAction];
    [self presentViewController:locationServicesAlert animated:YES completion:nil];
}

@end
