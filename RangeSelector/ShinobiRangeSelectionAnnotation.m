//
//  ShinobiRangeSelectionAnnotation.m
//  RangeSelector
//
//  Created by Sam Davies on 30/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "ShinobiRangeSelectionAnnotation.h"

@implementation ShinobiRangeSelectionAnnotation

- (id)initWithFrame:(CGRect)frame xValue:(id)xValue xValueMax:(id)xValueMax xAxis:(SChartAxis *)xAxis yAxis:(SChartAxis *)yAxis
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.xAxis = xAxis;
        self.yAxis = yAxis;
        self.yValue = nil;
        self.yValueMax = nil;
        self.xValue = xValue;
        self.xValueMax = xValueMax;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    // We force the height to be that of the y-axis itself
    CGRect bds = self.bounds;
    bds.size.height = self.yAxis.axisFrame.size.height;
    self.bounds = bds;
}

- (void)setTransform:(CGAffineTransform)transform
{
    // Zooming annotations usually use an affine transform to set their shape.
    //  We're going to change the frame of the annotation so that we have a
    //  suitable area to which to recognise dragging gestures.
    CGRect bds = self.bounds;
    bds.size.width *= transform.a;
    bds.size.height *= transform.d;
    self.bounds = bds;
}

@end
