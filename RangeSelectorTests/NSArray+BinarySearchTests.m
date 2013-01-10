//
//  NSArray+BinarySearchTests.m
//  RangeSelector
//
//  Created by Sam Davies on 10/01/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "NSArray+BinarySearchTests.h"
#import "NSArray+BinarySearch.h"

@implementation NSArray_BinarySearchTests

- (void)setUp
{
    searchArray = @[@1, @3, @12, @14.2, @17.65, @20, @25, @40];
    defaultRange = NSMakeRange(0, searchArray.count);
}

- (void)tearDown
{
    searchArray = nil;
}

- (void)testSimpleCases
{
    STAssertEquals((NSUInteger)3, [searchArray indexOfSmallestObjectBiggerThan:@13 inSortedRange:defaultRange], @"Smallest object bigger than should work");
    STAssertEquals((NSUInteger)2, [searchArray indexOfBiggestObjectSmallerThan:@13 inSortedRange:defaultRange], @"Biggest object smaller than should work");
}

- (void)testEquality
{
    STAssertEquals((NSUInteger)2, [searchArray indexOfSmallestObjectBiggerThan:@12 inSortedRange:defaultRange], @"Equality should return the correct index");
    STAssertEquals((NSUInteger)2, [searchArray indexOfBiggestObjectSmallerThan:@12 inSortedRange:defaultRange], @"Equality should return the correct index");
}

- (void)testNonPowerOfTwoArray
{
    searchArray = @[@1, @2, @3, @4, @5, @6, @7];
    defaultRange = NSMakeRange(0, searchArray.count);
    
    STAssertEquals((NSUInteger)4, [searchArray indexOfSmallestObjectBiggerThan:@4.3 inSortedRange:defaultRange], @"Smallest object bigger than should work with non-power of 2 array");
    STAssertEquals((NSUInteger)3, [searchArray indexOfBiggestObjectSmallerThan:@4.3 inSortedRange:defaultRange], @"Biggest object smaller than should work with non-power of 2 array");
}

- (void)testLowerThanArray
{
    STAssertEquals((NSUInteger)0, [searchArray indexOfSmallestObjectBiggerThan:@0.5 inSortedRange:defaultRange], @"Smallest object bigger than should work when value below array values");
    STAssertThrows([searchArray indexOfBiggestObjectSmallerThan:@0.5 inSortedRange:defaultRange], @"Biggest object smaller than should throw exception when out of range");
}

- (void)testHigherThanArray
{
    STAssertEquals((NSUInteger)7, [searchArray indexOfBiggestObjectSmallerThan:@45 inSortedRange:defaultRange], @"Biggest object smaller than should work when value above array values");
    STAssertThrows([searchArray indexOfSmallestObjectBiggerThan:@45 inSortedRange:defaultRange], @"Smallest object bigger than should throw exception when out of range");
}

- (void)testDateArray
{
    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSNumber *i in searchArray) {
        [dateArray addObject:[NSDate dateWithTimeIntervalSinceNow:[i doubleValue]]];
    }
    NSDate *searchDate = [NSDate dateWithTimeIntervalSinceNow:32];
    STAssertEquals((NSUInteger)7, [dateArray indexOfSmallestObjectBiggerThan:searchDate inSortedRange:defaultRange], @"Methods should work for date arrays");
    STAssertEquals((NSUInteger)6, [dateArray indexOfBiggestObjectSmallerThan:searchDate inSortedRange:defaultRange], @"Methods should work for date arrays");
}


@end
