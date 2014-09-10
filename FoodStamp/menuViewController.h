//
//  menuViewController.h
//  FoodStamp
//
//  Created by Tracer on 6/12/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "menuCollectionViewCell.h"
#import <Parse/Parse.h>
@interface menuViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
}

@property (strong, nonatomic) IBOutlet UICollectionView *platillosCollectionView;



@property (strong,nonatomic) PFObject *dish;
@property (strong, nonatomic) NSMutableArray *parseArray;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) short preIndex;
@property (strong, nonatomic) NSMutableArray *preParseArray;
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (nonatomic, assign) BOOL firstTimeInMenu;

- (IBAction)backRestButton:(id)sender;

@end
