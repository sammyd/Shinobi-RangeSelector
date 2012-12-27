//
//  ShinobiRangeAnnotationManager.h
//  RangeSelector
//
//  Created by Sam Davies on 26/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>

@interface ShinobiRangeAnnotationManager : NSObject

- (id)initWithChart:(ShinobiChart*)chart;
- (void)moveRangeSelectorToRange:(SChartRange*)range;

@end
