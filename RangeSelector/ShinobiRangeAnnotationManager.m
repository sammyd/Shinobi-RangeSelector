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
#import "ShinobiRangeHandleAnnotation.h"
#import "ShinobiRangeSelectionAnnotation.h"
#import "MomentumAnimation.h"

@interface ShinobiRangeAnnotationManager ()<UIGestureRecognizerDelegate> {
    ShinobiChart *chart;
    SChartAnnotation *leftLine, *leftHandle, *rightHandle, *rightLine;
    SChartAnnotationZooming *leftShading, *rightShading, *rangeSelection;
    MomentumAnimation *momentumAnimation;
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
        momentumAnimation = [MomentumAnimation new];
    }
    return self;
}

#pragma mark - Manager setup
- (void)createAnnotations
{
    // Lines are pretty simple
    leftLine = [SChartAnnotation verticalLineAtPosition:nil withXAxis:chart.xAxis andYAxis:chart.yAxis withWidth:3.f withColor:[UIColor colorWithWhite:0.2 alpha:1.f]];
    rightLine = [SChartAnnotation verticalLineAtPosition:nil withXAxis:chart.xAxis andYAxis:chart.yAxis withWidth:3.f withColor:[UIColor colorWithWhite:0.2 alpha:1.f]];
    // Shading is either side of the line
    leftShading = [SChartAnnotation verticalBandAtPosition:chart.xAxis.axisRange.minimum andMaxX:nil withXAxis:chart.xAxis andYAxis:chart.yAxis withColor:[UIColor colorWithWhite:0.1f alpha:0.3f]];
    rightShading = [SChartAnnotation verticalBandAtPosition:nil andMaxX:chart.xAxis.axisRange.maximum withXAxis:chart.xAxis andYAxis:chart.yAxis withColor:[UIColor colorWithWhite:0.1f alpha:0.3f]];
    // The invisible range selection
    rangeSelection = [[ShinobiRangeSelectionAnnotation alloc] initWithFrame:CGRectMake(0, 0, 1, 1) xValue:chart.xAxis.axisRange.minimum xValueMax:chart.xAxis.axisRange.maximum xAxis:chart.xAxis yAxis:chart.yAxis];
    // Create the handles
    leftHandle = [[ShinobiRangeHandleAnnotation alloc] initWithFrame:CGRectMake(0, 0, 30, 80) colour:[UIColor colorWithWhite:0.2 alpha:1.f] xValue:chart.xAxis.axisRange.minimum xAxis:chart.xAxis yAxis:chart.yAxis];
    rightHandle = [[ShinobiRangeHandleAnnotation alloc] initWithFrame:CGRectMake(0, 0, 30, 80) colour:[UIColor colorWithWhite:0.2 alpha:1.f] xValue:chart.xAxis.axisRange.maximum xAxis:chart.xAxis yAxis:chart.yAxis];
    
    
    // Add the annotations to the chart
    [chart addAnnotation:leftLine];
    [chart addAnnotation:rightLine];
    [chart addAnnotation:leftShading];
    [chart addAnnotation:rightShading];
    [chart addAnnotation:rangeSelection];
    // Add the handles on top so they take gesture priority.
    [chart addAnnotation:leftHandle];
    [chart addAnnotation:rightHandle];
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
    
    // Create a simple gesture recogniser and add it to the range selection
    UIPanGestureRecognizer *gestureRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [rangeSelection addGestureRecognizer:gestureRecogniser];
    
    UIPanGestureRecognizer *leftHandleRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHandlePan:)];
    [leftHandle addGestureRecognizer:leftHandleRecogniser];
    UIPanGestureRecognizer *rightHandleRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHandlePan:)];
    [rightHandle addGestureRecognizer:rightHandleRecogniser];
}

#pragma mark - Gesture events
- (void)handlePan:(UIPanGestureRecognizer*)recogniser
{    
    // What's the pixel location of the touch?
    CGPoint currentTouchPoint = [recogniser locationInView:chart.canvas];
    
    if (recogniser.state == UIGestureRecognizerStateEnded) {
        // Work out some values required for the animation
        // startPosition is in the range [0,1]
        CGFloat startPosition = currentTouchPoint.x / chart.canvas.bounds.size.width;
        // startVelocity should be between [-1,1]
        CGFloat startVelocity = [recogniser velocityInView:chart.canvas].x / chart.canvas.bounds.size.width;

        [momentumAnimation animateWithStartPosition:startPosition startVelocity:startVelocity updateBlock:^(CGFloat position) {
            // This is the code which will get called to update the position
            double range = [rightLine.xValue doubleValue] - [leftLine.xValue doubleValue];
            CGFloat centrePixelLocation = position * chart.canvas.bounds.size.width;
            double newCentreValue = [[chart.xAxis transformValueToExternal:@([chart.xAxis mapDataValueForPixelValue:centrePixelLocation])] doubleValue];
            double newMin = newCentreValue - range/2;
            double newMax = newCentreValue + range/2;
            
            // Create the range
            SChartRange *updatedRange = [[SChartRange alloc] initWithMinimum:@(newMin) andMaximum:@(newMax)];
            // Move the annotation to the correct location
            // We use the internal method so we don't kill the momentum animator
            [self internalMoveRangeSelectorToRange:updatedRange];
            
            // And fire the delegate method
            if (self.delegate && [self.delegate respondsToSelector:@selector(rangeAnnotation:didMoveToRange:)]) {
                [self.delegate rangeAnnotation:self didMoveToRange:updatedRange];
            }
        } duration:0.6f];
        
    } else {        
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
}

- (void)handleHandlePan:(UIPanGestureRecognizer*)recogniser
{    
    CGPoint currentTouchPoint = [recogniser locationInView:chart.canvas];
    
    double newValue = [[chart.xAxis transformValueToExternal:@([chart.xAxis mapDataValueForPixelValue:currentTouchPoint.x])] doubleValue];
    
    SChartRange *newRange;
    if(recogniser.view == leftHandle) {
        newRange = [[SChartRange alloc] initWithMinimum:@(newValue) andMaximum:rightHandle.xValue];
    } else {
        newRange = [[SChartRange alloc] initWithMinimum:leftHandle.xValue andMaximum:@(newValue)];
    }
    
    // Move
    [self moveRangeSelectorToRange:newRange];
    
    // And fire the delegate method
    if (self.delegate && [self.delegate respondsToSelector:@selector(rangeAnnotation:didMoveToRange:)]) {
        [self.delegate rangeAnnotation:self didMoveToRange:newRange];
    }
}


#pragma mark - API Methods
- (void)moveRangeSelectorToRange:(SChartRange *)range
{
    // If called externally then we want to kill momentum
    [momentumAnimation stopAnimation];
    
    // Now perform the move
    [self internalMoveRangeSelectorToRange:range];
}

- (void)internalMoveRangeSelectorToRange:(SChartRange *)range
{
    leftLine.xValue = range.minimum;
    rightLine.xValue = range.maximum;
    leftShading.xValue = chart.xAxis.axisRange.minimum;
    leftShading.xValueMax = range.minimum;
    rightShading.xValue = range.maximum;
    rightShading.xValueMax = chart.xAxis.axisRange.maximum;
    leftHandle.xValue = range.minimum;
    rightHandle.xValue = range.maximum;
    rangeSelection.xValue = range.minimum;
    rangeSelection.xValueMax = range.maximum;
    
    [chart redrawChart];
}

@end
