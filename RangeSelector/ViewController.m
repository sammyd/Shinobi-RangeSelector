//
//  ViewController.m
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

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "ChartDatasource.h"
#import "ShinobiRangeSelector.h"

@interface ViewController () {
    ChartDatasource *datasource;
    ShinobiRangeSelector *rangeSelector;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    datasource = [[ChartDatasource alloc] init];
    rangeSelector = [[ShinobiRangeSelector alloc] initWithFrame:self.view.bounds datasource:datasource splitProportion:0.75f];
    
    [self.view addSubview:rangeSelector];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
