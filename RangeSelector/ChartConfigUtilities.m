//
//  ChartConfigUtilities.m
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
