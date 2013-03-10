//
//  SChartDatasourceLookup.h
//  RangeSelector
//
//  Created by Sam Davies on 10/03/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SChartDatasourceLookup <NSObject>

@required
- (id)estimateYValueForXValue:(id)xValue forSeriesAtIndex:(NSUInteger)idx;

@end
