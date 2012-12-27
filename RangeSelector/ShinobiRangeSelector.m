//
//  ShinobiRangeSelector.m
//  RangeSelector
//
//  Created by Sam Davies on 26/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "ShinobiRangeSelector.h"
#import "ShinobiLicense.h"
#import "ChartConfigUtilities.h"
#import "ShinobiRangeAnnotationManager.h"

@interface ShinobiRangeSelector () {
    id<SChartDatasource> chartDatasource;
    ShinobiChart *mainChart;
    ShinobiChart *rangeChart;
    ShinobiRangeAnnotationManager *annotationManager;
}

@end

@implementation ShinobiRangeSelector

- (id)initWithFrame:(CGRect)frame datasource:(id<SChartDatasource>)datasource splitProportion:(CGFloat)proportion
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
        
        // Create the 2 charts
        [self createMainChartWithFrame:mainFrame];
        [self createRangeChartWithFrame:rangeFrame];
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
    annotationManager = [[ShinobiRangeAnnotationManager alloc] initWithChart:rangeChart];
    
    [self addSubview:rangeChart];
}


#pragma mark - SChartDelegate methods
- (void)sChartIsPanning:(ShinobiChart *)chart withChartMovementInformation:(const SChartMovementInformation *)information
{
    [annotationManager moveRangeSelectorToRange:chart.xAxis.axisRange];
}

- (void)sChartIsZooming:(ShinobiChart *)chart withChartMovementInformation:(const SChartMovementInformation *)information
{
    [annotationManager moveRangeSelectorToRange:chart.xAxis.axisRange];
}

@end
