//
//  ShinobiAnchoredTextAnnotation.h
//  RangeSelector
//
//  Created by Sam Davies on 09/03/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>

@interface ShinobiAnchoredTextAnnotation : SChartAnnotation

- (id)initWithText:(NSString*)text andFont:(UIFont*)font withXAxis:(SChartAxis*)xAxis andYAxis:(SChartAxis*)yAxis atXPosition:(id)xPosition andYPosition:(id)yPosition withTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor;

@end
