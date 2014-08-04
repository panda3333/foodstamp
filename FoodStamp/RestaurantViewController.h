//
//  RestaurantViewController.h
//  FoodStamp
//
//  Created by Red Prado on 4/2/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "infoTableViewCell.h"
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

@property (strong, nonatomic) PFObject* dish;

@property (nonatomic, assign) int index;
@property (strong, nonatomic) NSMutableArray *parseArray;

@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;



//Buttons


    //Navigation Buttons

- (IBAction)backButton:(id)sender;


@end
