//
//  LocationViewController.h
//  FoodStamp
//
//  Created by Red Prado on 4/3/14.
//  Copyright (c) 2014 Foodstamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationViewController : UIViewController <MKMapViewDelegate>{
    
    CLLocationCoordinate2D zoomLocation;
      CLLocationManager *locationManager;
}

//headerView
@property (strong, nonatomic) IBOutlet UIView *userLocationImage;
@property (strong, nonatomic) IBOutlet UILabel *restHeaderNameLabel;
- (IBAction)backButton:(id)sender;
//MapView
@property (strong, nonatomic) IBOutlet MKMapView *minMapView;

@property (strong, nonatomic) MKMapView *routeMap;
@property (strong, nonatomic) MKMapItem *destination;

@property (strong, nonatomic) IBOutlet UIImageView *rateImageView;

//Table View
@property (strong, nonatomic) IBOutlet UITableView *locationTableView;

@property (strong, nonatomic) PFObject* dish;
@property (strong, nonatomic) NSMutableArray *parseArray;


@end
