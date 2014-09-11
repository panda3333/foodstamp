//
//  LocationViewController.m
//  FoodStamp
//
//  Created by Red Prado on 4/3/14.
//  Copyright (c) 2014 Foodstamp. All rights reserved.
//

#import "LocationViewController.h"
#import "ViewController.h"
#import "RestaurantViewController.h"
#import "Parse/Parse.h"

#define METROS_POR_MILLA 1609.344

@interface LocationViewController ()

@end

@implementation LocationViewController
@synthesize minMapView;

@synthesize userLocationImage,restHeaderNameLabel,rateImageView,dish;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    PFObject *restaurant = self.dish[@"Restaurant"];
    NSLog(@"EL restaurante--------------->%@",restaurant);
    PFGeoPoint *restaurantLocation = [restaurant objectForKey:@"GeoLocation"];
    
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(restaurantLocation.latitude, restaurantLocation.longitude) addressDictionary:nil];
    _destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    [_destination setName:[restaurant objectForKey:@"Name"]];
    [_destination openInMapsWithLaunchOptions:nil];
    
    //show user location at the map only works in devices and not in the simulator.
    minMapView.showsUserLocation = YES;
    
    MKUserLocation *userLocation = minMapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate,
                                       20000, 20000);
    
    [minMapView setRegion:region animated:NO];
    
    userLocationImage.layer.cornerRadius= userLocationImage.frame.size.height/2;
    userLocationImage.layer.borderWidth=0; //border width
    userLocationImage.clipsToBounds =YES;
    
    minMapView.delegate = self;
    
    [self getDirections];
    
    restHeaderNameLabel.text = [restaurant objectForKey:@"Name"];
}



- (void)getDirections
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = _destination;
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [_routeMap
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}


- (void)viewWillAppear:(BOOL)animated {

    PFObject *restaurant = self.dish[@"Restaurant"];
     NSLog(@"EL restaurante--------------->%@",restaurant);
    PFGeoPoint *restaurantLocation = [restaurant objectForKey:@"GeoLocation"];
    
    // Round User Image
    // 1 Fix coordinates. These will be called by a Query to Parse, then received and stored in a Double variable and then subsitituted by latitude and longitude
    
    zoomLocation.latitude = restaurantLocation.latitude;
    zoomLocation.longitude = restaurantLocation.longitude;
    // e.g. some house coordinates    20.610650, -103.454611
    
    // 2 Fix distance to be seen on the map (Zoom)
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METROS_POR_MILLA, 0.5*METROS_POR_MILLA);
    
    // 3 Adjust region and animate zoom
    [minMapView setRegion:viewRegion animated:YES];
    
    // 4 Put pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:zoomLocation];
    [annotation setTitle:@"RestaurantLocation"];
    [minMapView addAnnotation:annotation];
    
//  Initiate current location
//    locationManager = [[CLLocationManager alloc] init];
//   locationManager.delegate = self;
//   locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
    
}
#pragma mark - MapView Methods
-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    
    MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
//    CLLocationCoordinate2D myCoordinate;
//    myCoordinate.latitude=13.04016;
//    myCoordinate.longitude=80.243044;
//    MKCoordinateRegionMakeWithDistance(myCoordinate, 13.04016, 80.243044);
//    annotation.coordinate = myCoordinate;

    if (!minMapView.showsUserLocation)
    {
        minMapView.showsUserLocation = YES;
            [minMapView addAnnotation:annotation];
        
    }
    
}
- (void)appReturnsActive{
    [minMapView setShowsUserLocation:YES];
}

- (void)appToBackground{
    [minMapView setShowsUserLocation:NO];
}



- (IBAction)backButton:(id)sender {
    
    NSLog(@"ET phone Home ");
    
    RestaurantViewController *preViewInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantView"];
    preViewInstance.parseArray = self.parseArray;
        preViewInstance.dish = self.dish;
    [self presentViewController:preViewInstance animated:YES completion:nil];

}
@end
