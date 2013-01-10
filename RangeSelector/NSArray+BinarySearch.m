//
//  NSArray+BinarySearch.m
//  RangeSelector
//
//  Created by Sam Davies on 10/01/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "NSArray+BinarySearch.h"

@implementation NSArray (BinarySearch)

- (NSUInteger)indexOfSmallestObjectBiggerThan:(id)searchKey inSortedRange:(NSRange)range
{
    if (range.length == 0) {
        return range.location;
    }
    // Check the boundary condition
    if ([searchKey compare:[self objectAtIndex:NSMaxRange(range)-1]] == NSOrderedDescending) {
        NSException *exception = [NSException exceptionWithName:NSRangeException reason:@"All array elements in range are smaller than the search object" userInfo:nil];
        @throw exception;
    }
    
    return [self indexOfClosestObjectToSearchKey:searchKey inRange:range withOrdering:NSOrderedAscending];
}


- (NSUInteger)indexOfBiggestObjectSmallerThan:(id)searchKey inSortedRange:(NSRange)range
{
    if ([searchKey compare:[self objectAtIndex:range.location]] == NSOrderedAscending) {
        NSException *exception = [NSException exceptionWithName:NSRangeException reason:@"All array elements in range are bigger than the search object." userInfo:nil];
        @throw exception;
    }
    return [self indexOfClosestObjectToSearchKey:searchKey inRange:range withOrdering:NSOrderedDescending];
}

- (NSUInteger)indexOfClosestObjectToSearchKey:(id)searchKey inRange:(NSRange)range withOrdering:(NSComparisonResult)ordering
{

    if (range.length == 0) {
        // We have got it down to one result. Now to work out which index we
        //  should return.
        // Descending => biggest one which is smaller
        // Ascending  => Smallest one which is bigger
        return ordering == NSOrderedAscending ? range.location : range.location - 1;
    }
    
    // We need to continue searching. Find the midpoint
    NSInteger mid = range.location + range.length / 2;
    id midVal = [self objectAtIndex:mid];
    
    switch ([midVal compare:searchKey]) {
        case NSOrderedDescending:
            // This means the value we want is in the first half
            return [self indexOfClosestObjectToSearchKey:searchKey inRange:NSMakeRange(range.location, mid - range.location) withOrdering:ordering];
            break;
            
        case NSOrderedAscending:
            // This means the value we want must be in the 2nd half
            return [self indexOfClosestObjectToSearchKey:searchKey inRange:NSMakeRange(mid + 1, NSMaxRange(range) - (mid+1)) withOrdering:ordering];
            break;
        default:
            return mid;
    }
}


@end
