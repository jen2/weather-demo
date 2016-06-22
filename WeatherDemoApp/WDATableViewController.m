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

@end

// TO DO: Get users location,  get refresh button working.

@implementation WDATableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCurrentConditions];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WDABackground.v1-1.jpg"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.allDatesOfThisWeek = [self getWeekDates];
    self.tableView.allowsSelection = NO;
    
}
- (IBAction)refreshTableView:(UIBarButtonItem *)sender
{
    [self getCurrentConditions];
}

-(void) getCurrentConditions
{
    self.latitude = 40.8073550;
    self.longitude = -73.9428640;
    
    [WDAAPIClient getDailyForecastWithLatitude:(CGFloat)self.latitude Longitude:(CGFloat)self.longitude Completion: ^(NSArray *forecastData) {
        self.forecastData = forecastData;
        [self.tableView reloadData];
    }];
}

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

#pragma mark - Table view data source

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
    
    if (indexPath.row == 0) {
        cell.downArrow.hidden = NO;
    } else {
        cell.downArrow.hidden = YES;
    }
    
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

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height;
}

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

@end
