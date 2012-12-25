//
//  TemperatureData.h
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemperatureData : NSObject

@property (nonatomic, retain) NSArray *data;

+ (TemperatureData*)sharedInstance;

@end
