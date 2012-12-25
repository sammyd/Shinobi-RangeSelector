//
//  ViewController.m
//  RangeSelector
//
//  Created by Sam Davies on 25/12/2012.
//  Copyright (c) 2012 Shinobi Controls. All rights reserved.
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
