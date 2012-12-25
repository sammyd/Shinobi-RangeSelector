//
//  ChartConfigUtilities.h
//  RangeSelector
//
//  Created by Sam Davies on 26/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>

@interface ChartConfigUtilities : NSObject

+ (void)setInteractionOnChart:(ShinobiChart*)chart toEnabled:(BOOL)enabled;

+ (void)removeAllAxisMarkingsFromChart:(ShinobiChart*)chart;
+ (void)removeMarkingsFromAxis:(SChartAxis*)axis;
+ (void)removeLinesOnStripesFromAxis:(SChartAxis*)axis;
+ (void)removeTitleFromAxis:(SChartAxis*)axis;

@end
