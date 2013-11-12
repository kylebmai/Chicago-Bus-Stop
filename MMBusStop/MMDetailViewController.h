//
//  MMDetailViewController.h
//  MMBusStop
//
//  Created by Kyle Mai on 10/8/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MMDetailViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelBusInfo;
@property (weak, nonatomic) IBOutlet MKMapView *busMapView;


@property (strong, nonatomic) NSArray *arrayBusDetailInfo;


@end
