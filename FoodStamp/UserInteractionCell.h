//
//  UserInteractionCell.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Red Prado on 4/2/14.
//
//	Purpose:
//	This file is for a cell of the Restaurant Screen.
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
#import "RestaurantViewController.h"

@interface UserInteractionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *decideLabel;
@property (strong, nonatomic) IBOutlet UILabel *exploraLabel;
@property (strong, nonatomic) IBOutlet UILabel *calificaLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareLabel;

//userInteraction Buttons

@end
