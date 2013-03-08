//
//  SChartAxis+CoordinateSpaceConversion.m
//  RangeSelector
//
//  Created by Sam Davies on 08/03/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SChartAxis+CoordinateSpaceConversion.h"
#import <ShinobiCharts/SChartCanvas.h>

@implementation SChartAxis (CoordinateSpaceConversion)

- (id)estimateDataValueForPixelValue:(CGFloat)pixelValue
{
    // What is the axis range?
    SChartRange *range = self.axisRange;
    
    // What's the frame of the plot area
    CGRect glFrame = self.chart.canvas.glView.bounds;
    
    // 
    CGFloat pixelSpan;
    if(self.axisOrientation == SChartOrientationHorizontal) {
        pixelSpan = glFrame.size.width;
    } else {
        pixelSpan = glFrame.size.height;
    }
    
    // Assuming that there is a linear map
    // NOTE :: This won't work for discontinuous or logarithmic axes
    return @( [range.span doubleValue] / pixelSpan * pixelValue + [range.minimum doubleValue] );
}

@end
