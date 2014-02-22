//
//  ChartDatasource.m
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
//  
//  Copyright 2013 Scott Logic
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "ChartDatasource.h"
#import "TemperatureData.h"
#import "TemperatureDataPoint.h"
#import "NSArray+BinarySearch.h"

@interface ChartDatasource () {
    TemperatureData *temperatureData;
}
@end

@implementation ChartDatasource

- (id)init
{
    self = [super init];
    if (self) {
        temperatureData = [TemperatureData sharedInstance];
    }
    return self;
}

#pragma mark - SChartDatasource methods
- (int)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 1;
}

- (SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index
{
    return [[SChartLineSeries alloc] init];
}

- (int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex
{
    return temperatureData.data.count;
}

- (NSArray *)sChart:(ShinobiChart *)chart dataPointsForSeriesAtIndex:(int)seriesIndex
{
    NSMutableArray *datapointArray = [NSMutableArray array];
    for (TemperatureDataPoint *tdp in temperatureData.data) {
        SChartDataPoint *dp = [SChartDataPoint new];
        dp.xValue = tdp.timestamp;
        dp.yValue = tdp.temperature;
        [datapointArray addObject:dp];
    }
    return [NSArray arrayWithArray:datapointArray];
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex
{
    // Find the underlying temperature data point
    TemperatureDataPoint *tdp = temperatureData.data[dataIndex];
    // Turn this into a chart data point
    SChartDataPoint *dp = [SChartDataPoint new];
    dp.xValue = tdp.timestamp;
    dp.yValue = tdp.temperature;
    return dp;
}

#pragma mark - SChartDatasourceLookup methods
- (id)estimateYValueForXValue:(id)xValue forSeriesAtIndex:(NSUInteger)idx
{
    if([xValue isKindOfClass:[NSNumber class]]) {
        // Need it to be a date since we are comparing timestamp
        xValue = [NSDate dateWithTimeIntervalSince1970:[xValue doubleValue]];
    }
    NSArray *xValues = [temperatureData.data valueForKeyPath:@"@unionOfObjects.timestamp"];
    NSUInteger index;
    @try {
        index = [xValues indexOfBiggestObjectSmallerThan:xValue inSortedRange:NSMakeRange(0, xValues.count)];
    }
    @catch (NSException *exception) {
        index = 0;
    }
    return ((TemperatureDataPoint*)temperatureData.data[index]).temperature;
}

@end
