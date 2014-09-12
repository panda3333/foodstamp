//
//  SocialCell.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Red Prado on 3/30/14.
//
//	Purpose:
//	This file is for a cell of the Dish Screen.
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

@interface SocialCell : UITableViewCell

//Declare Labels
@property (strong, nonatomic) IBOutlet UILabel *wishLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareLabel;
//Buttons
@property (strong, nonatomic) IBOutlet UIButton *favButton;
@property (strong, nonatomic) IBOutlet UIButton *toRestaurant;

//Actions For Buttons

- (IBAction)likeActionButton:(id)sender;
- (IBAction)facebookActionButton:(id)sender;



@end
