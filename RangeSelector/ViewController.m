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
#import "ShinobiLicense.h"

@interface ViewController () {
    ChartDatasource *datasource;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ShinobiChart *chart = [[ShinobiChart alloc] initWithFrame:self.view.bounds withPrimaryXAxisType:SChartAxisTypeDateTime withPrimaryYAxisType:SChartAxisTypeNumber];
    chart.licenseKey = [ShinobiLicense getShinobiLicenseKey];
    
    datasource = [[ChartDatasource alloc] init];
    chart.datasource = datasource;
    
    for (SChartAxis *axis in chart.allAxes) {
        axis.enableGestureZooming = YES;
        axis.enableGesturePanning = YES;
        axis.enableMomentumPanning = YES;
        axis.enableMomentumZooming = YES;
    }
    
    [self.view addSubview:chart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
