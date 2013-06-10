//
//  ShinobiLicense.m
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
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
