//
//  TemperatureData.m
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "TemperatureData.h"
#import "TemperatureDataPoint.h"

@interface TemperatureData ()
@end


@implementation TemperatureData

#pragma mark - Singleton initialisation
+ (TemperatureData *)sharedInstance
{
    static TemperatureData *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[self alloc] init];
    });
    return sharedData;
}

#pragma mark - Initialisation
- (id)init
{
    self = [super init];
    if (self) {
        [self importData];
    }
    return self;
}

#pragma mark - Data utility methods
- (void)importData
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*100];
    NSDate *endDate   = [NSDate date];
    
    // Some fixed properties for data generation
    double mean = 23;
    double dailyDelta = 4;
    double randomVariance = 2;
    
    NSMutableArray *data = [NSMutableArray array];
    
    NSDate *currentDate = startDate;
    while ([currentDate compare:endDate] == NSOrderedAscending) {
        // Sine wave based on time of date
        NSDateComponents *cmpts = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:currentDate];
        double dayProportion = cmpts.hour / 24.f;
        double newValue = mean + dailyDelta * sin((dayProportion - 0.25) * 2 * M_PI);
        
        // And now add some randomness
        newValue += (arc4random() % 4096  / 2048.f - 1.f) * randomVariance;
        
        // Create a data point wih these values
        TemperatureDataPoint *dp = [[TemperatureDataPoint alloc] initWithDate:currentDate temperature:@(newValue)];
        [data addObject:dp];
        
        // Move the current date on by an hour
        currentDate = [NSDate dateWithTimeInterval:3600 sinceDate:currentDate];
    }
    
    // Save this off into our ivar
    self.data = [NSArray arrayWithArray:data];
}


@end
