//
//  ShinobiValueAnnotationManager.m
//  RangeSelector
//
//  Created by Sam Davies on 09/01/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "ShinobiValueAnnotationManager.h"
#import "ShinobiAnchoredTextAnnotation.h"
#import "NSArray+BinarySearch.h"

@interface ShinobiValueAnnotationManager () {
    ShinobiChart *chart;
    id<SChartDatasourceLookup> datasource;
    NSInteger seriesIndex;
    SChartAnnotation *lineAnnotation;
    SChartAnnotation *textAnnotation;
}

@end

@implementation ShinobiValueAnnotationManager

- (id)init
{
    NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please use initWithChart:seriesIndex:" userInfo:nil];
    @throw exception;
}

- (id)initWithChart:(ShinobiChart *)_chart datasource:(id<SChartDatasourceLookup>)_datasource seriesIndex:(NSInteger)_seriesIndex
{
    self = [super init];
    if (self) {
        chart = _chart;
        seriesIndex = _seriesIndex;
        datasource = _datasource;
        [self createLine];
        [self createText];
    }
    return self;
}

- (void)createLine
{
    // Really simple line
    lineAnnotation = [SChartAnnotation horizontalLineAtPosition:nil
                                                      withXAxis:chart.xAxis
                                                       andYAxis:chart.yAxis
                                                      withWidth:1.f
                                                      withColor:[UIColor blackColor]];
    [chart addAnnotation:lineAnnotation];
}

- (void)createText
{
    // Create the font
    UIFont *labelFont = [UIFont fontWithName:@"Nunito-Bold" size:18.f];
    if(labelFont == nil) {
        labelFont = [UIFont systemFontOfSize:18.f];
    }
    
    // Create our text annotation subclass. We set the text to be the widest of our possible values
    //  since we only size the annotation at construction time.
    textAnnotation = [[ShinobiAnchoredTextAnnotation alloc] initWithText:@"MM.MM"
                                                                 andFont:labelFont
                                                               withXAxis:chart.xAxis
                                                                andYAxis:chart.yAxis
                                                             atXPosition:nil
                                                            andYPosition:nil
                                                           withTextColor:[UIColor whiteColor]
                                                     withBackgroundColor:[UIColor blackColor]];
    [chart addAnnotation:textAnnotation];
}

#pragma mark - API Methods
- (void)updateValueAnnotationForXAxisRange:(SChartRange *)range
{
    // The new x-value we need the y-value for. We need to transform to the internal
    //  scaling because we are going to use the interal datapoint array for lookups
    id newXValue = range.maximum;

    // Need to find the y-value at this point
    id lastVisibleDPValue = [datasource estimateYValueForXValue:newXValue forSeriesAtIndex:seriesIndex];
    
    // Update the annotations yValue and redraw the chart
    lineAnnotation.yValue = lastVisibleDPValue;
    textAnnotation.yValue = lastVisibleDPValue;
    textAnnotation.xValue = newXValue;
    textAnnotation.label.text = [NSString stringWithFormat:@"%0.2f", [lastVisibleDPValue doubleValue]];
    
    [chart redrawChart];
}

@end
