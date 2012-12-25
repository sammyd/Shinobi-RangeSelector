//
//  TemperatureDataPoint.h
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemperatureDataPoint : NSObject

@property (nonatomic, retain) NSDate   *timestamp;
@property (nonatomic, retain) NSNumber *temperature;

- (id)initWithDate:(NSDate*)date temperature:(NSNumber*)temperature;

@end
