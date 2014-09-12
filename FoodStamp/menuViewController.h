//
//  menuViewController.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created on 6/12/14.
//  Authors: Red Prado, Jesus Cruz Perez and Jose Daniel Leal Avila.
//
//	Purpose:
//	This file is for the Menu Screen.
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
