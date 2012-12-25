//
//  ChartDatasource.m
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "ChartDatasource.h"
#import "TemperatureData.h"
#import "TemperatureDataPoint.h"

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

@end
