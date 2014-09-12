//
//  LocationViewController.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created on 4/3/14.
//  Authors: Red Prado and Jesus Cruz Perez.
//
//	Purpose:
//	This file is for the Location Screen.
//
//  Modifications:
//
//  File    Patching Date in
//  Version Bug      Production   Author           Modification
//  ======= ======== ============ ================ ===================================
//  1.0     00000000 DD-MMM-YYYY  Author's Name    - created
//
//  ==================================================================================
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
