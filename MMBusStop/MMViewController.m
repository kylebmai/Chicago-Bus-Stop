//
//  MMViewController.m
//  MMBusStop
//
//  Created by Kyle Mai on 10/8/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import "MMViewController.h"
#import "MMDetailViewController.h"
#import "MMCustomPointAnnotation.h"
#import "UIImage+WeatherIcon.h"

@interface MMViewController ()
{
    int pic;
    UISwipeGestureRecognizer *swipeGestureDown;
    UISwipeGestureRecognizer *swipeGestureUp;
    UISwipeGestureRecognizer *swipeGestureLeft;
    UISwipeGestureRecognizer *swipeGestureRight;
    UIImageView *cloud;
}

@end

@implementation MMViewController
@synthesize busMapView, arrayBusStopLocations, arrayBusInfo, swipeView;

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWeatherIcon) name:@"ChangeIcon" object:nil];
    
    [self loadFourGestures];
    
    
    //Initialize stuff
    arrayBusStopLocations = [[NSMutableArray alloc] init];
    arrayBusInfo = [[NSArray alloc] init];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self getBusStopLocationData];
    
    //********* Overley on map *****************
    CLLocationCoordinate2D  points[5];
    points[0] = CLLocationCoordinate2DMake(41.885665, -87.633905);
    points[1] = CLLocationCoordinate2DMake(41.876943, -87.633691);
    points[2] = CLLocationCoordinate2DMake(41.876831, -87.628241);
    points[3] = CLLocationCoordinate2DMake(41.879467, -87.626073);
    points[4] = CLLocationCoordinate2DMake(41.885633, -87.626245);
    
    MKPolygon* poly = [MKPolygon polygonWithCoordinates:points count:5];
    poly.title = @"The Loop";
    [busMapView addOverlay:poly];
    //******************************************
    
    pic = 0;
    
}

- (void)addMovingCloud
{
    cloud = [[UIImageView alloc] initWithFrame:CGRectMake(320, 100, 500, 200)];
    cloud.image = [UIImage imageNamed:@"cloud1"];
    [self.view addSubview:cloud];
}

- (void)loadFourGestures
{
    swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMapUp)];
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [swipeView addGestureRecognizer:swipeGestureUp];
    
    swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMapDown)];
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [swipeView addGestureRecognizer:swipeGestureDown];
    
    swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMapLeft)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [swipeView addGestureRecognizer:swipeGestureLeft];
    
    swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMapRight)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [swipeView addGestureRecognizer:swipeGestureRight];
}

- (void)swipeMapUp
{
    NSLog(@"Swiped up");
    for (id annotation in busMapView.annotations)
    {
        MKAnnotationView *pinView = [busMapView viewForAnnotation:annotation];
        pinView.image = [UIImage sunnyWeatherIcon];
    }
}

- (void)swipeMapDown
{
    NSLog(@"Swiped down");
    for (id annotation in busMapView.annotations)
    {
        MKAnnotationView *pinView = [busMapView viewForAnnotation:annotation];
        pinView.image = [UIImage rainyWeatherIcon];
    }
}

- (void)swipeMapLeft
{
    [self addMovingCloud];
    
    NSLog(@"Swiped left");
    for (id annotation in busMapView.annotations)
    {
        MKAnnotationView *pinView = [busMapView viewForAnnotation:annotation];
        pinView.image = [UIImage cloudyWeatherIcon];
    }
    
    [UIView animateWithDuration:30.0 animations:^{
        cloud.frame = CGRectOffset(cloud.frame, -640, cloud.frame.origin.y);
    }];
    
}

- (void)swipeMapRight
{
    NSLog(@"Swiped right");
    for (id annotation in busMapView.annotations)
    {
        MKAnnotationView *pinView = [busMapView viewForAnnotation:annotation];
        pinView.image = [UIImage windyWeatherIcon];
    }
    
}

- (void)changeWeatherIcon
{
    for (id annotation in busMapView.annotations)
    {
        MKAnnotationView *pinView = [busMapView viewForAnnotation:annotation];
        switch (pic) {
            case 0:
                pinView.image = [UIImage cloudyWeatherIcon];
                break;
            case 1:
                pinView.image = [UIImage rainyWeatherIcon];
                break;
            case 2:
                pinView.image = [UIImage sunnyWeatherIcon];
                break;
            case 3:
                pinView.image = [UIImage windyWeatherIcon];
                break;
                
            default:
                break;
        }
    }
    
    pic++;
    
    if (pic == 4) {
        pic = 0;
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView* aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay];
        
        aView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        aView.lineWidth = 3;
        
        return aView;
    }
    return nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)getBusStopLocationData
{
    NSURL *url = [NSURL URLWithString:@"http://mobilemakers.co/lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSDictionary *dictionaryBusStopTop = [[NSDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError]];
        NSArray *arrayOfKeyRow = [[NSArray alloc] initWithArray:[dictionaryBusStopTop objectForKey:@"row"]];
        
        for (NSDictionary *dictionaryEachRowObject in arrayOfKeyRow)
        {
            NSMutableArray *arrayEachBusStop = [[NSMutableArray alloc] init];
            
            [arrayEachBusStop addObject:[dictionaryEachRowObject objectForKey:@"cta_stop_name"]];
            [arrayEachBusStop addObject:[dictionaryEachRowObject objectForKey:@"routes"]];
            [arrayEachBusStop addObject:[dictionaryEachRowObject objectForKey:@"latitude"]];
            [arrayEachBusStop addObject:[dictionaryEachRowObject objectForKey:@"longitude"]];
            [arrayEachBusStop addObject:[dictionaryEachRowObject objectForKey:@"direction"]];
            
            if ([dictionaryEachRowObject objectForKey:@"inter_modal"] == nil)
            {
                [arrayEachBusStop addObject:@"none"];
            }
            else
            {
                [arrayEachBusStop addObject:[dictionaryEachRowObject objectForKey:@"inter_modal"]];
            }
            
            [arrayBusStopLocations addObject:arrayEachBusStop];
        }
        
        [self drawBusStopsOnMap];
    }];
}

- (void)drawBusStopsOnMap
{
    for (int i = 0; i < [arrayBusStopLocations count]; i++)
    {
        NSString *busStopName = [[arrayBusStopLocations objectAtIndex:i] objectAtIndex:0];
        NSString *busRoutes = [[arrayBusStopLocations objectAtIndex:i] objectAtIndex:1];
        float busLatitude = [[[arrayBusStopLocations objectAtIndex:i] objectAtIndex:2] floatValue];
        float busLongitude = [[[arrayBusStopLocations objectAtIndex:i] objectAtIndex:3] floatValue];
                
        CLLocationCoordinate2D busCoordinate = {busLatitude, busLongitude};
        MKCoordinateSpan zoomLevel = {0.5, 0.5};
        [busMapView setRegion:MKCoordinateRegionMake(busCoordinate, zoomLevel)];
        
        MMCustomPointAnnotation *busPin = [[MMCustomPointAnnotation alloc] init];
        busPin.coordinate = busCoordinate;
        busPin.title = busStopName;
        busPin.subtitle = busRoutes;
        busPin.arrayBusInfo = [arrayBusStopLocations objectAtIndex:i];

        [busMapView addAnnotation:busPin];
    }
    
    [self mapCenterRegion];
}

- (void)mapCenterRegion
{
    float maxLatitude;
    float maxLongitude;
    
    for (int x = 0; x < [arrayBusStopLocations count] - 1; x++)
    {
        float firstLatitude = [[[arrayBusStopLocations objectAtIndex:x] objectAtIndex:2] floatValue];
        float secondLatitude = [[[arrayBusStopLocations objectAtIndex:x + 1] objectAtIndex:2] floatValue];
        
        if (firstLatitude < secondLatitude) {
            maxLatitude = secondLatitude;
        }
        
        float firstLongitude = [[[arrayBusStopLocations objectAtIndex:x] objectAtIndex:3] floatValue];
        float secondLongitude = [[[arrayBusStopLocations objectAtIndex:x + 1] objectAtIndex:3] floatValue];
        
        if (firstLongitude < secondLongitude) {
            maxLongitude = secondLongitude;
        }
    }
    
    CLLocationCoordinate2D maxCoordinate = {maxLatitude, maxLongitude};
    MKCoordinateSpan zoomLevel = {0.5, 0.5};
    [busMapView setRegion:MKCoordinateRegionMake(maxCoordinate, zoomLevel)];
    
/*  ********* Test Pin for the center of all locations ***************
    MKPointAnnotation *maxPin = [[MKPointAnnotation alloc] init];
    maxPin.coordinate = maxCoordinate;
    maxPin.title = @"Center Coordinate";
    [busMapView addAnnotation:maxPin];
*///******************************************************************
 
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MMCustomPointAnnotation *)annotation
{    
    NSString *transfer = [annotation.arrayBusInfo objectAtIndex:5];
    
    NSString *pinID = @"pinID";
    MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
    
    if (!pinView)
    {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else
    {
        pinView.annotation = annotation;
    }
    
    if ([transfer isEqualToString:@"Metra"])
    {
        pinView.image = [UIImage imageNamed:@"cta25x25"];
    }
    else if ([transfer isEqualToString:@"Pace"])
    {
        pinView.image = [UIImage imageNamed:@"cta25x25Green"];
    }
    else
    {
        pinView.image = [UIImage imageNamed:@"cta25x25BW"];
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"segueToDetailVC" sender:pin];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)pin
{
    if ([segue.identifier isEqualToString:@"segueToDetailVC"])
    {
        MMCustomPointAnnotation *annotation = pin.annotation;
        
        MMDetailViewController *detailVC = segue.destinationViewController;
        detailVC.arrayBusDetailInfo = annotation.arrayBusInfo;
    }
}

- (IBAction)actionChangeWeather:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeIcon" object:nil];
}







@end
