//
//  ChartDatasource.h
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>
#import "SChartDatasourceLookup.h"

@interface ChartDatasource : NSObject <SChartDatasource, SChartDatasourceLookup>

@end
