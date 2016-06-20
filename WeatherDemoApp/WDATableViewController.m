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

@end

// TO DO: Get users location, Make a down arrow to show users to scroll, Get decimal places out of all label Strings, Get date label working, get forecast for all 7 days, get refresh button working.

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

- (NSString *) getPercentage:(NSString *)string
{
    NSNumber *floatValueFromString = @([string floatValue] * 100);
    NSUInteger numValue = (NSInteger) (floatValueFromString);
    return [NSString stringWithFormat:@"%lu", (unsigned long)numValue];
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
    
    NSString *temperatureString = [self getIntegerString:[data valueForKeyPath:@"temperatureMax"]];
    NSString *windString = [self getIntegerString:[data valueForKeyPath:@"windSpeed"]];
    NSString *precipString = [self getPercentage:[data valueForKeyPath:@"precipProbability"]];
    NSString *humiditypString = [self getPercentage:[data valueForKeyPath:@"humidity"]];
    
    cell.temperatureLabel.text = [NSString stringWithFormat: @"%@°", temperatureString];
    cell.precipitationLabel.text = [NSString stringWithFormat: @"%@%%", precipString];
    cell.humidityLabel.text = [NSString stringWithFormat: @"%@%%", humiditypString];
    cell.windSpeedLabel.text = [NSString stringWithFormat:@"%@ mph", windString];
    
    
    
    
//    cell.temperatureLabel.text = [NSString stringWithFormat: @"%@%%", [data valueForKeyPath:@"temperatureMax"]];
//    cell.precipitationLabel.text = [NSString stringWithFormat: @"%@%%", [data valueForKeyPath:@"precipProbability"]];
//    cell.humidityLabel.text = [NSString stringWithFormat: @"%@%%", [data valueForKeyPath:@"humidity"]];
//    cell.windSpeedLabel.text = [NSString stringWithFormat:@"%@ mph", [data valueForKeyPath:@"widnSpeed"]];
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
