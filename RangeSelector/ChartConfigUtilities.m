//
//  ChartConfigUtilities.m
//  RangeSelector
//
//  Created by Sam Davies on 26/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "ChartConfigUtilities.h"

@implementation ChartConfigUtilities

#pragma mark - User interaction
+ (void)setInteractionOnChart:(ShinobiChart *)chart toEnabled:(BOOL)enabled
{
    for (SChartAxis *axis in chart.allAxes) {
        axis.enableGesturePanning  = enabled;
        axis.enableGestureZooming  = enabled;
        axis.enableMomentumPanning = enabled;
        axis.enableMomentumZooming = enabled;
    }
}


#pragma mark - Axis Markings
+ (void)removeAllAxisMarkingsFromChart:(ShinobiChart *)chart
{
    for (SChartAxis *axis in chart.allAxes) {
        [self removeLinesOnStripesFromAxis:axis];
        [self removeMarkingsFromAxis:axis];
        [self removeTitleFromAxis:axis];
    }
}

+ (void)removeMarkingsFromAxis:(SChartAxis *)axis
{
    axis.style.majorTickStyle.showLabels = NO;
    axis.style.majorTickStyle.showTicks  = NO;
    axis.style.minorTickStyle.showLabels = NO;
    axis.style.minorTickStyle.showTicks  = NO;
}

+ (void)removeLinesOnStripesFromAxis:(SChartAxis *)axis
{
    axis.style.majorGridLineStyle.showMajorGridLines = NO;
    axis.style.gridStripeStyle.showGridStripes = NO;
}

+ (void)removeTitleFromAxis:(SChartAxis *)axis
{
    axis.title = @"";
}


@end
