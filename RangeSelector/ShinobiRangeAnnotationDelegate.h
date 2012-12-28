//
//  ShinobiRangeAnnotationDelegate.h
//  RangeSelector
//
//  Created by Sam Davies on 27/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShinobiRangeAnnotationManager;

@protocol ShinobiRangeAnnotationDelegate <NSObject>

@required
- (void)rangeAnnotation:(ShinobiRangeAnnotationManager*)annotation didMoveToRange:(SChartRange*)range;

@end
