//
//  ViewController.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created on 3/28/14.
//  Authors: Red Prado, Jesus Cruz Perez and Jose Daniel Leal Avila.
//
//	Purpose:
//	This file is for the Home Screen.
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
#import "HomePlatilloCell.h"
#import "Parse/Parse.h"


@interface ViewController : UIViewController{
    NSArray *imageFileArray;
    NSArray *restaurantNameArray;
}

@property (strong, nonatomic) IBOutlet UICollectionView *platillosCollectionView;
@property (strong, nonatomic) IBOutlet UIImageView *userIconHomeImage;
@property (nonatomic, strong) NSMutableData *imageData;

@property (strong, nonatomic) IBOutlet UIView *optionsView;
@property (nonatomic, assign) int index;
@property (strong, nonatomic) NSMutableArray *parseArray;
@property (strong, nonatomic) PFObject* dish;


//Button para menu opciones
- (IBAction)optionsButton:(id)sender;

//Botones de opciones
- (IBAction)randomButton:(id)sender;
- (IBAction)dessertsButton:(id)sender;

- (IBAction)breakfastButton:(id)sender;
- (IBAction)lunchButton:(id)sender;
- (IBAction)dinnerButton:(id)sender;
- (IBAction)aboutButton:(id)sender;

- (NSMutableArray *)randomizeArray: (NSMutableArray *) originalArray;


@end
