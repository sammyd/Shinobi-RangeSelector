//
//  ShinobiRangeSelector.m
//  RangeSelector
//
//  Created by Sam Davies on 26/12/2012.
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

#import "ShinobiRangeSelector.h"
#import "ShinobiLicense.h"
#import "ChartConfigUtilities.h"
#import "ShinobiRangeAnnotationManager.h"
#import "ShinobiValueAnnotationManager.h"

@interface ShinobiRangeSelector () <ShinobiRangeAnnotationDelegate> {
    id<SChartDatasource, SChartDatasourceLookup> chartDatasource;
    ShinobiChart *mainChart;
    ShinobiChart *rangeChart;
    ShinobiRangeAnnotationManager *rangeAnnotationManager;
    ShinobiValueAnnotationManager *valueAnnotationManager;
    CGFloat minimumSpan;
}

@end

@implementation ShinobiRangeSelector

- (id)initWithFrame:(CGRect)frame datasource:(id<SChartDatasource, SChartDatasourceLookup>)datasource splitProportion:(CGFloat)proportion
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        chartDatasource = datasource;
        
        // Calculate the frame sizes of the 2 charts we want to create
        CGRect mainFrame = self.bounds;
        mainFrame.size.height *= proportion;
        CGRect rangeFrame = self.bounds;
        rangeFrame.size.height -= mainFrame.size.height;
        rangeFrame.origin.y = mainFrame.size.height;
        
        // Set a minimum span of 4 days
        minimumSpan = 3600 * 24 * 4;
        
        // Create the 2 charts
        [self createMainChartWithFrame:mainFrame];
        [self createRangeChartWithFrame:rangeFrame];
        
        // And now prepare the default range
        [self configureTheDefaultRange];
    }
    return self;
}


- (void)createMainChartWithFrame:(CGRect)frame
{
    mainChart = [[ShinobiChart alloc] initWithFrame:frame withPrimaryXAxisType:SChartAxisTypeDateTime withPrimaryYAxisType:SChartAxisTypeNumber];
    mainChart.licenseKey = [ShinobiLicense getShinobiLicenseKey];
    mainChart.datasource = chartDatasource;
    
    // Prepare the axes
    [ChartConfigUtilities setInteractionOnChart:mainChart toEnabled:YES];
    
    // We use ourself as the chart delegate to get zoom/pan details
    mainChart.delegate = self;
    
    // Add some annotations
    valueAnnotationManager = [[ShinobiValueAnnotationManager alloc] initWithChart:mainChart datasource:chartDatasource seriesIndex:0];

    [self addSubview:mainChart];
}

- (void)createRangeChartWithFrame:(CGRect)frame
{
    rangeChart = [[ShinobiChart alloc] initWithFrame:frame withPrimaryXAxisType:SChartAxisTypeDateTime withPrimaryYAxisType:SChartAxisTypeNumber];
    rangeChart.licenseKey = [ShinobiLicense getShinobiLicenseKey];
    rangeChart.datasource = chartDatasource;
    
    // Prepare the axes
    [ChartConfigUtilities setInteractionOnChart:rangeChart toEnabled:NO];
    // Remove the axis markings
    [ChartConfigUtilities removeAllAxisMarkingsFromChart:rangeChart];
    
    // Add some annotations
    rangeAnnotationManager = [[ShinobiRangeAnnotationManager alloc] initWithChart:rangeChart minimumSpan:minimumSpan];
    rangeAnnotationManager.delegate = self;
    
    [self addSubview:rangeChart];
}

- (void)configureTheDefaultRange
{
    NSInteger numberPoints = [chartDatasource sChart:mainChart numberOfDataPointsForSeriesAtIndex:0];
    // Let's make the default range the 4th 20% of data points
    // NB: we're assuming here that the datapoints are in ascending order of x. This isn't
    //  always true, but it is for our data set, so we'll live with it.
    NSInteger startIndex = floor(numberPoints * 0.6);
    NSInteger endIndex = floor(numberPoints * 0.8);
    
    // Find the correct points
    SChartDataPoint *startPoint = [chartDatasource sChart:mainChart dataPointAtIndex:startIndex forSeriesAtIndex:0];
    SChartDataPoint *endPoint = [chartDatasource sChart:mainChart dataPointAtIndex:endIndex forSeriesAtIndex:0];
    
    // Need to convert the datapoints to their internal representation - i.e. time interval floats
    NSTimeInterval startTS = [((NSDate *)startPoint.xValue) timeIntervalSince1970];
    NSTimeInterval endTS = [((NSDate *)endPoint.xValue) timeIntervalSince1970];
    
    SChartRange *defaultRange = [[SChartRange alloc] initWithMinimum:@(startTS) andMaximum:@(endTS)];
    
    // And now set the default range to this range
    [mainChart.xAxis setDefaultRange:defaultRange];
    [mainChart.xAxis resetZoomLevel];
    
    // And update the annotation appropriately
    [rangeAnnotationManager moveRangeSelectorToRange:defaultRange];
    [valueAnnotationManager updateValueAnnotationForXAxisRange:defaultRange];
    
    // We also want to set the min/max since it's not available from the axis yet
    SChartDataPoint *minDP = [chartDatasource sChart:mainChart dataPointAtIndex:0 forSeriesAtIndex:0];
    SChartDataPoint *maxDP = [chartDatasource sChart:mainChart dataPointAtIndex:(numberPoints-1) forSeriesAtIndex:0];
    [rangeAnnotationManager setInitialMin:minDP.xValue andMax:maxDP.xValue];
}

#pragma mark - ShinobiRangeSelectorDelegate methods
- (void)rangeAnnotation:(ShinobiRangeAnnotationManager *)annotation didMoveToRange:(SChartRange *)range
{
    [mainChart.xAxis setRangeWithMinimum:range.minimum andMaximum:range.maximum];
    // Update the location of the annotation line
    [valueAnnotationManager updateValueAnnotationForXAxisRange:range];
    [mainChart redrawChart];
}


#pragma mark - SChartDelegate methods
- (void)sChartIsPanning:(ShinobiChart *)chart withChartMovementInformation:(const SChartMovementInformation *)information
{
    [rangeAnnotationManager moveRangeSelectorToRange:chart.xAxis.axisRange];
    [valueAnnotationManager updateValueAnnotationForXAxisRange:chart.xAxis.axisRange];
}

- (void)sChartIsZooming:(ShinobiChart *)chart withChartMovementInformation:(const SChartMovementInformation *)information
{
    // We need to check that we haven't gone outside of our allowed span
    if ([chart.xAxis.axisRange.span floatValue] < minimumSpan) {
        // Re-zoom it
        CGFloat midValue = [chart.xAxis.axisRange.span floatValue] / 2 + [chart.xAxis.axisRange.minimum floatValue];
        CGFloat newMin = midValue - minimumSpan / 2;
        CGFloat newMax = midValue + minimumSpan / 2;
        [chart.xAxis setRangeWithMinimum:@(newMin) andMaximum:@(newMax)];
    }
    [rangeAnnotationManager moveRangeSelectorToRange:chart.xAxis.axisRange];
    [valueAnnotationManager updateValueAnnotationForXAxisRange:chart.xAxis.axisRange];
}

@end
