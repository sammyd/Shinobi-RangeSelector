//
//  ShinobiValueAnnotationManager.m
//  RangeSelector
//
//  Created by Sam Davies on 09/01/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "ShinobiValueAnnotationManager.h"
#import "NSArray+BinarySearch.h"
#import "SChartAxis_IntExtTransforms.h"

@interface ShinobiValueAnnotationManager () {
    ShinobiChart *chart;
    NSInteger seriesIndex;
    SChartAnnotation *lineAnnotation;
}

@end

@implementation ShinobiValueAnnotationManager

- (id)init
{
    NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please use initWithChart:seriesIndex:" userInfo:nil];
    @throw exception;
}

- (id)initWithChart:(ShinobiChart *)_chart seriesIndex:(NSInteger)_seriesIndex
{
    self = [super init];
    if (self) {
        chart = _chart;
        seriesIndex = _seriesIndex;
        [self createLine];
    }
    return self;
}

- (void)createLine
{
    // Really simple line
    lineAnnotation = [SChartAnnotation horizontalLineAtPosition:nil withXAxis:chart.xAxis andYAxis:chart.yAxis withWidth:1.f withColor:[UIColor blackColor]];
    [chart addAnnotation:lineAnnotation];
}

#pragma mark - API Methods
- (void)updateValueAnnotationForXAxisRange:(SChartRange *)range
{
    // The new x-value we need the y-value for. We need to transform to the internal
    //  scaling because we are going to use the interal datapoint array for lookups
    id newXValue = [chart.xAxis transformValueToInternal:range.maximum];
    
    if (chart.allChartSeries.count > seriesIndex) {
        // Need to find the y-value at this point
        NSArray *datapoints = ((SChartSeries*)chart.allChartSeries[seriesIndex]).dataSeries.dataPoints;
        // Get an array of just the xValues
        NSArray *xValueArray = [datapoints valueForKey:@"xValue"];
        
        // We assume that the datapoint array is sorted. This is true for our data. Not necessarily true though
        //  in which case we would need to sort it here to use the NSArray binary search
        //  extension methods. Or update them.
        NSUInteger lastVisibleDPIndex = [xValueArray indexOfBiggestObjectSmallerThan:newXValue inSortedRange:NSMakeRange(0, datapoints.count)];
        id lastVisibleDPValue = ((SChartDataPoint *)datapoints[lastVisibleDPIndex]).yValue;
        
        // Update the annotations yValue and redraw the chart
        lineAnnotation.yValue = lastVisibleDPValue;
        [chart redrawChart];
    }
}

@end
