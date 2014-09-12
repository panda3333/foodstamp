//
//  RestaurantViewController.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created on 4/2/14.
//  Authors: Red Prado, Jesus Cruz Perez and Jose Daniel Leal Avila.
//
//	Purpose:
//	This file is for the Restaurant Screen.
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
#import "infoTableViewCell.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface RestaurantViewController : UIViewController <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
    
}
//collectionview
@property (strong, nonatomic) IBOutlet UICollectionView *miniMenuCollectionView;
//termina collection view

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property  (strong,nonatomic) IBOutlet  UIPageControl *pageControl;


@property (strong, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (strong, nonatomic) RestaurantViewController *restaurantTableController;

@property (strong, nonatomic) IBOutlet UIImageView *mapIconImage;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) MKMapView *minMapView;
@property (strong, nonatomic) MKMapView *routeMap;
@property (strong, nonatomic) MKMapItem *destination;

@property (strong, nonatomic) PFObject* dish;
@property (nonatomic, assign) int index;
@property (strong, nonatomic) NSMutableArray *parseArray;

@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;



//Buttons


    //Navigation Buttons

- (IBAction)backButton:(id)sender;


@end
