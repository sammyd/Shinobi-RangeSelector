//
//  ShinobiRangeHandleAnnotation.m
//  RangeSelector
//
//  Created by Sam Davies on 29/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "ShinobiRangeHandleAnnotation.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShinobiRangeHandleAnnotation

- (id)initWithFrame:(CGRect)frame colour:(UIColor *)colour xValue:(id)xValue xAxis:(SChartAxis *)xAxis yAxis:(SChartAxis *)yAxis
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.xAxis = xAxis;
        self.yAxis = yAxis;
        self.xValue = xValue;
        // Setting this to nil will ensure that the handle appears in the centre
        self.yValue = nil;
        
        [self drawHandleWithColour:colour];
    }
    return self;
}

- (void)drawHandleWithColour:(UIColor *)colour
{
    self.layer.cornerRadius = 5;
    self.backgroundColor = colour;
    
    // Add 3 lines
    int numberLines = 3;
    CGFloat lineWidth = 2;
    CGFloat lineSpacing = (self.frame.size.width - lineWidth * numberLines) / (numberLines + 1);
    CGFloat heightProportion = 0.6;
    CGFloat lineHeight = heightProportion * self.frame.size.height;
    CGFloat lineY = (1-heightProportion) / 2 * self.frame.size.height;
    CGFloat currentOffset = lineSpacing;
    for(int i=0; i<numberLines; i++) {
        UIView *newLine = [[UIView alloc] initWithFrame:CGRectMake(currentOffset, lineY, lineWidth, lineHeight)];
        newLine.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.7f];
        [self addSubview:newLine];
        currentOffset += (lineWidth + lineSpacing);
    }
    
}

@end
