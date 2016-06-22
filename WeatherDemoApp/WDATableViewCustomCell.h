//
//  WDATableViewCustomCell.h
//  WeatherDemoApp
//
//  Created by Jennifer A Sipila on 6/16/16.
//  Copyright © 2016 Jennifer A Sipila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDATableViewCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *precipitationLabel;
@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (strong, nonatomic) IBOutlet UIImageView *downArrow;

@end
