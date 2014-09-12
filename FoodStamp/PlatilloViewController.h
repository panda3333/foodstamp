//
//  PlatilloViewController.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created on 3/28/14.
//  Authors: Red Prado, Jesus Cruz Perez and Jose Daniel Leal Avila.
//
//	Purpose:
//	This file is for the Dish Screen.
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
#import "FotoPlatilloCell.h"
#import "PlatilloTableViewController.h"

@interface PlatilloViewController : UIViewController 
{
    //IBOutlet UITableView *platilloTableView;
}
@property (strong, nonatomic) IBOutlet UITableView *platilloTableView;
@property (strong, nonatomic) PlatilloTableViewController *platilloTableController;

@property (strong, nonatomic) IBOutlet UIImageView *userIconImage;
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) short preIndex;
@property (nonatomic, assign) BOOL fromMenu;
@property (strong, nonatomic) NSMutableArray *parseArray;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (strong, nonatomic) NSMutableArray *preParseArray;
@property (strong, nonatomic) PFObject* dish;




- (IBAction)backActionButton:(id)sender;
- (IBAction)shareButton:(id)sender;

@end
