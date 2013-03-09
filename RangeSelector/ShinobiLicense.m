//
//  ShinobiLicense.m
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
//

#import "ShinobiLicense.h"

@implementation ShinobiLicense

+ (NSString *)getShinobiLicenseKey
{
    /* We've used a plist file to keep a hold of the Shinobi License key,
     which is required when you run a demo. You can either create yourself
     your own plist file and put the key you have been provided in there,
     at the root level, with the key "ShinobiChartsLicenseKey", or alternatively
     you can just make this method return it.
     */
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RangeSelectorSettings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *key = settings[@"ShinobiChartsLicenseKey"];
    if(key && ![key isEqualToString:@""]) {
        return key;
    }
    
    // If you don't want to use the sample plist provided, pop your code below
    return @"YOUR CODE HERE";
}

@end
