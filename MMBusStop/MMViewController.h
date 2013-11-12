//
//  MMViewController.h
//  MMBusStop
//
//  Created by Kyle Mai on 10/8/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MMViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *busMapView;
@property (weak, nonatomic) IBOutlet UIView *swipeView;



@property (strong, nonatomic) NSMutableArray *arrayBusStopLocations;
@property (strong, nonatomic) NSArray *arrayBusInfo;

- (IBAction)actionChangeWeather:(id)sender;

@end
