//
//  ShinobiRangeAnnotationManager.m
//  RangeSelector
//
//  Created by Sam Davies on 26/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "ShinobiRangeAnnotationManager.h"
#import <ShinobiCharts/SChartCanvas.h>
#import "SChartAxis_IntExtTransforms.h"

@interface ShinobiRangeAnnotationManager ()<UIGestureRecognizerDelegate> {
    ShinobiChart *chart;
    SChartAnnotation *leftLine, *leftHandle, *rightHandle, *rightLine;
    SChartAnnotationZooming *leftShading, *rightShading;
}

@end


@implementation ShinobiRangeAnnotationManager

#pragma mark - Constructors
- (id)init
{
    NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please use initWithChart:" userInfo:nil];
    @throw exception;
}

- (id)initWithChart:(ShinobiChart *)_chart
{
    self = [super init];
    if(self) {
        chart = _chart;
        [self createAnnotations];
        [self prepareGestureRecognisers];
    }
    return self;
}

#pragma mark - Manager setup
- (void)createAnnotations
{
    // Lines are pretty simple
    leftLine = [SChartAnnotation verticalLineAtPosition:nil withXAxis:chart.xAxis andYAxis:chart.yAxis withWidth:3.f withColor:[UIColor blackColor]];
    rightLine = [SChartAnnotation verticalLineAtPosition:nil withXAxis:chart.xAxis andYAxis:chart.yAxis withWidth:3.f withColor:[UIColor blackColor]];
    // Shading is either side of the line
    leftShading = [SChartAnnotation verticalBandAtPosition:chart.xAxis.axisRange.minimum andMaxX:nil withXAxis:chart.xAxis andYAxis:chart.yAxis withColor:[UIColor colorWithWhite:0.1f alpha:0.3f]];
    rightShading = [SChartAnnotation verticalBandAtPosition:nil andMaxX:chart.xAxis.axisRange.maximum withXAxis:chart.xAxis andYAxis:chart.yAxis withColor:[UIColor colorWithWhite:0.1f alpha:0.3f]];
    
    // Add the annotations to the chart
    [chart addAnnotation:leftLine];
    [chart addAnnotation:rightLine];
    [chart addAnnotation:leftShading];
    [chart addAnnotation:rightShading];
}

- (void)prepareGestureRecognisers
{
    // We need to stop other subviews of the chart from intercepting touches
    chart.userInteractionEnabled = YES;
    for (UIView *v in chart.subviews) {
        v.userInteractionEnabled = NO;
    }
    chart.canvas.userInteractionEnabled = YES;
    for (UIView *v in chart.canvas.subviews) {
        v.userInteractionEnabled = NO;
    }
    chart.canvas.glView.userInteractionEnabled = YES;
    
    // Create a simple gesture recogniser and add it to the glView
    UIPanGestureRecognizer *gestureRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [chart.canvas.glView addGestureRecognizer:gestureRecogniser];
}

#pragma mark - Gesture events
- (void)handlePan:(UIPanGestureRecognizer*)recogniser
{
    // What's the pixel location of the touch?
    CGPoint currentTouchPoint = [recogniser locationInView:chart.canvas.glView];
    
    // Now need to map this to the new data range required
    double range = [rightLine.xValue doubleValue] - [leftLine.xValue doubleValue];
    double newCentreValue = [[chart.xAxis transformValueToExternal:@([chart.xAxis mapDataValueForPixelValue:currentTouchPoint.x])] doubleValue];
    double newMin = newCentreValue - range/2;
    double newMax = newCentreValue + range/2;
    
    // Create the range
    SChartRange *updatedRange = [[SChartRange alloc] initWithMinimum:@(newMin) andMaximum:@(newMax)];
    // Move the annotation to the correct location
    [self moveRangeSelectorToRange:updatedRange];
    
    // And fire the delegate method
    if (self.delegate && [self.delegate respondsToSelector:@selector(rangeAnnotation:didMoveToRange:)]) {
        [self.delegate rangeAnnotation:self didMoveToRange:updatedRange];
    }
}


#pragma mark - API Methods
- (void)moveRangeSelectorToRange:(SChartRange *)range
{
    leftLine.xValue = range.minimum;
    rightLine.xValue = range.maximum;
    leftShading.xValue = chart.xAxis.axisRange.minimum;
    leftShading.xValueMax = range.minimum;
    rightShading.xValue = range.maximum;
    rightShading.xValueMax = chart.xAxis.axisRange.maximum;
    
    [chart redrawChart];
}

@end
