//
//  TemperatureDataPoint.m
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "TemperatureDataPoint.h"

@implementation TemperatureDataPoint

- (id)initWithDate:(NSDate *)date temperature:(NSNumber *)temperature
{
    self = [self init];
    if(self)
    {
        self.timestamp = date;
        self.temperature = temperature;
    }
    return self;
}

@end
