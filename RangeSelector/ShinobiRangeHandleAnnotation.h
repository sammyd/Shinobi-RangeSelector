//
//  ShinobiRangeHandleAnnotation.h
//  RangeSelector
//
//  Created by Sam Davies on 29/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>

@interface ShinobiRangeHandleAnnotation : SChartAnnotation

- (id)initWithFrame:(CGRect)frame colour:(UIColor*)colour xValue:(id)xValue xAxis:(SChartAxis *)xAxis yAxis:(SChartAxis*)yAxis;

@end
