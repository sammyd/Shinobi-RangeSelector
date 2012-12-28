//
//  SChartAxis_IntExtTransforms.h
//  RangeSelector
//
//  Created by Sam Davies on 28/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>

@interface SChartAxis (IntExtTransforms)

- (id)transformValueToInternal:(id)value;
- (id)transformValueToExternal:(id)value;

@end
