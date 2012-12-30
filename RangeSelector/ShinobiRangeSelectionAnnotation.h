//
//  ShinobiRangeSelectionAnnotation.h
//  RangeSelector
//
//  Created by Sam Davies on 30/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>

@interface ShinobiRangeSelectionAnnotation : SChartAnnotationZooming

- (id)initWithFrame:(CGRect)frame xValue:(id)xValue xValueMax:(id)xValueMax xAxis:(SChartAxis*)xAxis yAxis:(SChartAxis*)yAxis;

@end
