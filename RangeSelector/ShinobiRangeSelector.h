//
//  ShinobiRangeSelector.h
//  RangeSelector
//
//  Created by Sam Davies on 26/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiCharts/ShinobiChart.h>
#import "SChartDatasourceLookup.h"

@interface ShinobiRangeSelector : UIView <SChartDelegate>

- (id)initWithFrame:(CGRect)frame datasource:(id<SChartDatasource, SChartDatasourceLookup>)datasource splitProportion:(CGFloat)proportion;

@end
