//
//  ShinobiAnchoredTextAnnotation.m
//  RangeSelector
//
//  Created by Sam Davies on 09/03/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "ShinobiAnchoredTextAnnotation.h"

@implementation ShinobiAnchoredTextAnnotation

- (id)initWithText:(NSString *)text andFont:(UIFont *)font withXAxis:(SChartAxis *)xAxis andYAxis:(SChartAxis *)yAxis atXPosition:(id)xPosition andYPosition:(id)yPosition withTextColor:(UIColor *)textColor withBackgroundColor:(UIColor *)bgColor
{
    self = [super init];
    if(self) {
        // Set all the required properties
        self.xAxis = xAxis;
        self.yAxis = yAxis;
        self.xValue = xPosition;
        self.yValue = yPosition;
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.backgroundColor = bgColor;
        self.label.font = font;
        self.label.textColor = textColor;
        self.label.text = text;
        self.label.textAlignment = NSTextAlignmentCenter;
        // Now we can resize the label and ourself to fit the text provided
        [self.label sizeToFit];
        [self addSubview:self.label];
        [self sizeToFit];
    }
    return self;
}

- (void)updateViewWithCanvas:(SChartCanvas *)canvas
{
    [super updateViewWithCanvas:canvas];
    // Let's move us so we are anchored in the bottom right hand corner
    self.center = CGPointMake(self.center.x - self.bounds.size.width / 2, self.center.y - self.bounds.size.height / 2);
}


@end
