//
//  ShinobiRangeSelectionAnnotation.m
//  RangeSelector
//
//  Created by Sam Davies on 30/12/2012.
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
