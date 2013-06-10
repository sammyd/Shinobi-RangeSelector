//
//  ShinobiRangeHandleAnnotation.m
//  RangeSelector
//
//  Created by Sam Davies on 29/12/2012.
//  
//  Copyright 2013 Scott Logic
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
