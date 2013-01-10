//
//  NSArray+BinarySearch.h
//  RangeSelector
//
//  Created by Sam Davies on 10/01/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BinarySearch)

- (NSUInteger)indexOfSmallestObjectBiggerThan:(id)searchKey inSortedRange:(NSRange)range;
- (NSUInteger)indexOfBiggestObjectSmallerThan:(id)searchKey inSortedRange:(NSRange)range;

@end
