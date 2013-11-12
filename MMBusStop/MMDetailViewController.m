//
//  MMDetailViewController.m
//  MMBusStop
//
//  Created by Kyle Mai on 10/8/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import "MMDetailViewController.h"

@interface MMDetailViewController ()

@end

@implementation MMDetailViewController
@synthesize arrayBusDetailInfo, labelBusInfo, busMapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *busStopName = [arrayBusDetailInfo objectAtIndex:0];
    NSString *busRoutes = [arrayBusDetailInfo objectAtIndex:1];
    float busLatitude = [[arrayBusDetailInfo objectAtIndex:2] floatValue];
    float busLongitude = [[arrayBusDetailInfo objectAtIndex:3] floatValue];
    NSString *busDirection = [arrayBusDetailInfo objectAtIndex:4];
    NSString *busInterModal = [arrayBusDetailInfo objectAtIndex:5];
    
    labelBusInfo.text = [NSString stringWithFormat:@"Stop at: %@\nRoutes: %@\nDirection: %@\nTransfers: %@", busStopName, busRoutes, busDirection, busInterModal];
    
    CLLocationCoordinate2D busCoordinate = {busLatitude, busLongitude};
    MKCoordinateSpan zoomLevel = {0.01, 0.01};
    [busMapView setRegion:MKCoordinateRegionMake(busCoordinate, zoomLevel)];
    
    MKPointAnnotation *busPin = [[MKPointAnnotation alloc] init];
    busPin.coordinate = busCoordinate;
    busPin.title = busStopName;
    busPin.subtitle = busRoutes;
    
    [busMapView addAnnotation:busPin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


@end
