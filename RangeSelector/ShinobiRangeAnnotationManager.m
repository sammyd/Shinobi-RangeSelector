//
//  ShinobiRangeAnnotationManager.m
//  RangeSelector
//
//  Created by Sam Davies on 26/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "ShinobiRangeAnnotationManager.h"
#import <ShinobiCharts/SChartCanvas.h>
#import "ShinobiRangeHandleAnnotation.h"
#import "ShinobiRangeSelectionAnnotation.h"
#import "MomentumAnimation.h"

@interface ShinobiRangeAnnotationManager ()<UIGestureRecognizerDelegate> {
    ShinobiChart *chart;
    SChartAnnotation *leftLine, *leftGripper, *rightGripper, *rightLine;
    SChartAnnotationZooming *leftShading, *rightShading, *rangeSelection;
    MomentumAnimation *momentumAnimation;
    CGFloat minimumSpan;
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
    return [self initWithChart:_chart minimumSpan:3600*24];
}

- (id)initWithChart:(ShinobiChart *)_chart minimumSpan:(CGFloat)minSpan
{
    self = [super init];
    if(self) {
        chart = _chart;
        minimumSpan = minSpan;
        [self createAnnotations];
        [self prepareGestureRecognisers];
        // Let's make an animation instance here. We'll use this whenever we need momentum
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
    leftGripper = [[ShinobiRangeHandleAnnotation alloc] initWithFrame:CGRectMake(0, 0, 30, 80) colour:[UIColor colorWithWhite:0.2 alpha:1.f] xValue:chart.xAxis.axisRange.minimum xAxis:chart.xAxis yAxis:chart.yAxis];
    rightGripper = [[ShinobiRangeHandleAnnotation alloc] initWithFrame:CGRectMake(0, 0, 30, 80) colour:[UIColor colorWithWhite:0.2 alpha:1.f] xValue:chart.xAxis.axisRange.maximum xAxis:chart.xAxis yAxis:chart.yAxis];
    
    
    // Add the annotations to the chart
    [chart addAnnotation:leftLine];
    [chart addAnnotation:rightLine];
    [chart addAnnotation:leftShading];
    [chart addAnnotation:rightShading];
    [chart addAnnotation:rangeSelection];
    // Add the handles on top so they take gesture priority.
    [chart addAnnotation:leftGripper];
    [chart addAnnotation:rightGripper];
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
    
    // Add a pan gesture recogniser for dragging the range selector
    UIPanGestureRecognizer *gestureRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [rangeSelection addGestureRecognizer:gestureRecogniser];
    
    // And pan gesture recognisers for the 2 handles on the range selector
    UIPanGestureRecognizer *leftGripperRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGripperPan:)];
    [leftGripper addGestureRecognizer:leftGripperRecogniser];
    UIPanGestureRecognizer *rightGripperRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGripperPan:)];
    [rightGripper addGestureRecognizer:rightGripperRecogniser];
}

#pragma mark - Gesture events
- (void)handlePan:(UIPanGestureRecognizer*)recogniser
{    
    // What's the pixel location of the touch?
    CGPoint currentTouchPoint = [recogniser locationInView:chart.canvas.glView];
    
    if (recogniser.state == UIGestureRecognizerStateEnded) {
        // Work out some values required for the animation
        // startPosition is normalised so in range [0,1]
        CGFloat startPosition = currentTouchPoint.x / chart.canvas.glView.bounds.size.width;
        // startVelocity should be normalised as well
        CGFloat startVelocity = [recogniser velocityInView:chart.canvas.glView].x / chart.canvas.glView.bounds.size.width;

        // Use the momentum animator instance we have to start animating the annotation
        [momentumAnimation animateWithStartPosition:startPosition
                                      startVelocity:startVelocity
                                           duration:1.f
                                        updateBlock:^(CGFloat position) {
            // This is the code which will get called to update the position
            CGFloat centrePixelLocation = position * chart.canvas.bounds.size.width;
            
            // Create the range
            SChartRange *updatedRange = [self rangeCentredOnPixelValue:centrePixelLocation];
                                            
            // Ensure that this newly created range is within the bounds of the chart
            updatedRange = [self ensureWithinChartBounds:updatedRange maintainingSpan:YES];
            
            // Move the annotation to the correct location
            // We use the internal method so we don't kill the momentum animator
            [self moveRangeSelectorToRange:updatedRange cancelAnimation:NO];
            
            // And fire the delegate method
            [self callRangeDidMoveDelegateWithRange:updatedRange];
        }];
        
    } else {                
        // Create the range
        SChartRange *updatedRange = [self rangeCentredOnPixelValue:currentTouchPoint.x];
        
        // Ensure that this newly created range is within the bounds of the chart
        updatedRange = [self ensureWithinChartBounds:updatedRange maintainingSpan:YES];
        
        // Move the annotation to the correct location
        [self moveRangeSelectorToRange:updatedRange];
        
        // And fire the delegate method
        [self callRangeDidMoveDelegateWithRange:updatedRange];
    }
}

- (void)handleGripperPan:(UIPanGestureRecognizer*)recogniser
{    
    CGPoint currentTouchPoint = [recogniser locationInView:chart.canvas.glView];
    
    // What's the new location we've dragged the handle to?
    double newValue = [[self estimateDataValueForPixelValue:currentTouchPoint.x onAxis:chart.xAxis] doubleValue];
    
    SChartRange *newRange;
    // Update the range with the new value according to which handle we dragged
    if(recogniser.view == leftGripper) {
        // Left handle => change the range minimum
        // Check bounds
        if([rightGripper.xValue floatValue] - newValue < minimumSpan) {
            newValue = [rightGripper.xValue floatValue] - minimumSpan;
        }
        newRange = [[SChartRange alloc] initWithMinimum:@(newValue) andMaximum:rightGripper.xValue];
    } else {
        // Right handle => change the range maximum
        // Check bounds
        if(newValue - [leftGripper.xValue floatValue] < minimumSpan) {
            newValue = [leftGripper.xValue floatValue] + minimumSpan;
        }
        newRange = [[SChartRange alloc] initWithMinimum:leftGripper.xValue andMaximum:@(newValue)];
    }
    
    // Ensure that this newly created range is within the bounds of the chart
    newRange = [self ensureWithinChartBounds:newRange maintainingSpan:NO];
    
    // Move the selector
    [self moveRangeSelectorToRange:newRange];
    
    // And fire the delegate method
    [self callRangeDidMoveDelegateWithRange:newRange];
}


#pragma mark - Utility Methods
- (void)callRangeDidMoveDelegateWithRange:(SChartRange*)range
{
    // We call the delegate a few times, so have wrapped it up in a utility method
    if (self.delegate && [self.delegate respondsToSelector:@selector(rangeAnnotation:didMoveToRange:)]) {
        [self.delegate rangeAnnotation:self didMoveToRange:range];
    }
}

- (SChartRange*)rangeCentredOnPixelValue:(CGFloat)pixelValue
{
    // Find the extent of the current range
    double range = [rightLine.xValue doubleValue] - [leftLine.xValue doubleValue];
    // Find the new centre location
    double newCentreValue = [[self estimateDataValueForPixelValue:pixelValue onAxis:chart.xAxis] doubleValue];
    // Calculate the new limits
    double newMin = newCentreValue - range/2;
    double newMax = newCentreValue + range/2;
    
    // Create the range and return it
    return [[SChartRange alloc] initWithMinimum:@(newMin) andMaximum:@(newMax)];
}

- (SChartRange*)ensureWithinChartBounds:(SChartRange*)range maintainingSpan:(BOOL)maintainSpan
{
    // If the requested range is bigger than the available, then reset to min/max
    if([range.span compare:chart.xAxis.axisRange.span] == NSOrderedDescending) {
        return [SChartRange rangeWithRange:chart.xAxis.axisRange];
    }
    
    if([range.minimum compare:chart.xAxis.axisRange.minimum] == NSOrderedAscending) {
        // Min is below axis range
        if(maintainSpan) {
            CGFloat difference = [chart.xAxis.axisRange.minimum doubleValue] - [range.minimum doubleValue];
            return [[SChartRange alloc] initWithMinimum:chart.xAxis.axisRange.minimum andMaximum:@([range.maximum doubleValue] + difference)];
        } else {
            return [[SChartRange alloc] initWithMinimum:chart.xAxis.axisRange.minimum andMaximum:range.maximum];
        }
    }
    
    if([range.maximum compare:chart.xAxis.axisRange.maximum] == NSOrderedDescending) {
        // Max is above axis range
        if(maintainSpan) {
            CGFloat difference = [range.maximum doubleValue] - [chart.xAxis.axisRange.maximum doubleValue];
            return [[SChartRange alloc] initWithMinimum:@([range.minimum doubleValue] - difference) andMaximum:chart.xAxis.axisRange.maximum];
        } else {
            return [[SChartRange alloc] initWithMinimum:range.minimum andMaximum:chart.xAxis.axisRange.maximum];
        }
    }
    
    return range;
}

- (id)estimateDataValueForPixelValue:(CGFloat)pixelValue onAxis:(SChartAxis*)axis
{
    // What is the axis range?
    SChartRange *range = axis.axisRange;
    
    // What's the frame of the plot area
    CGRect glFrame = chart.canvas.glView.bounds;
    
    //
    CGFloat pixelSpan;
    if(axis.axisOrientation == SChartOrientationHorizontal) {
        pixelSpan = glFrame.size.width;
    } else {
        pixelSpan = glFrame.size.height;
    }
    
    // Assuming that there is a linear map
    // NOTE :: This won't work for discontinuous or logarithmic axes
    return @( [range.span doubleValue] / pixelSpan * pixelValue + [range.minimum doubleValue] );
}


#pragma mark - API Methods
- (void)moveRangeSelectorToRange:(SChartRange *)range
{
    // By default we'll cancel animations
    [self moveRangeSelectorToRange:range cancelAnimation:YES];
}

- (void)setInitialMin:(id)min andMax:(id)max
{
    leftShading.xValue = min;
    rightShading.xValueMax = max;
}

- (void)moveRangeSelectorToRange:(SChartRange *)range cancelAnimation:(BOOL)cancelAnimation
{
    if (cancelAnimation) {
        // In many cases we want to prevent the animation fighting with the UI
        [momentumAnimation stopAnimation];
    }
    
    // Update the positions of all the individual components which make up the
    // range annotation
    leftLine.xValue = range.minimum;
    rightLine.xValue = range.maximum;
    leftShading.xValue = chart.xAxis.axisRange.minimum;
    leftShading.xValueMax = range.minimum;
    rightShading.xValue = range.maximum;
    rightShading.xValueMax = chart.xAxis.axisRange.maximum;
    leftGripper.xValue = range.minimum;
    rightGripper.xValue = range.maximum;
    rangeSelection.xValue = range.minimum;
    rangeSelection.xValueMax = range.maximum;
    
    // And finally redraw the chart
    [chart redrawChart];
}

@end
