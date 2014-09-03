//
//  LocationViewController.m
//  FoodStamp
//
//  Created by Red Prado on 4/3/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
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
    
    //mostrar locación de usuario en el mapa solo funciona en dispositivos no simulador.
    minMapView.showsUserLocation = YES;
    
    userLocationImage.layer.cornerRadius= userLocationImage.frame.size.height/2;
    userLocationImage.layer.borderWidth=0; //hancho del borde.
    userLocationImage.clipsToBounds =YES;
    
    
    restHeaderNameLabel.text = [restaurant objectForKey:@"Name"];
    
    

    
}

- (void)viewWillAppear:(BOOL)animated {

    PFObject *restaurant = self.dish[@"Restaurant"];
     NSLog(@"EL restaurante--------------->%@",restaurant);
    PFGeoPoint *restaurantLocation = [restaurant objectForKey:@"GeoLocation"];
    
    

    //Imagen de Usuario Redonda

    // 1 Fijar coordenadas estas deberán ser llamadas por un Query hacia parse recibidas, almacenadas en una variable Double y reemplazadas en latitutde y longitud.
    
    zoomLocation.latitude = restaurantLocation.latitude;
    zoomLocation.longitude = restaurantLocation.longitude;
    // coordenas de mi casa    20.610650, -103.454611
    
    // 2 Fijar la distancia que se verá en el mápa (Zoom)
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METROS_POR_MILLA, 0.5*METROS_POR_MILLA);
    
    // 3 Ajusta region y animar zoom
    [minMapView setRegion:viewRegion animated:YES];
    
    // 4 Poner pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:zoomLocation];
    [annotation setTitle:@"RestaurantLocation"];
    [minMapView addAnnotation:annotation];
    
    
//    //Inicilizar ubicación actual
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
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
