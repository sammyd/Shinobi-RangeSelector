//
//  SChartAxis+CoordinateSpaceConversion.h
//  RangeSelector
//
//  Created by Sam Davies on 08/03/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>

@interface SChartAxis (CoordinateSpaceConversion)

- (id)estimateDataValueForPixelValue:(CGFloat)pixelValue;

@end
