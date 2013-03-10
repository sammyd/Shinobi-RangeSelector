//
//  ShinobiValueAnnotationManager.h
//  RangeSelector
//
//  Created by Sam Davies on 09/01/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>
#import "SChartDatasourceLookup.h"

@interface ShinobiValueAnnotationManager : NSObject

- (id)initWithChart:(ShinobiChart *)chart datasource:(id<SChartDatasourceLookup>)datasource seriesIndex:(NSInteger)seriesIndex;

- (void)updateValueAnnotationForXAxisRange:(SChartRange *)range;

@end
