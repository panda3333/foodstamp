//
//  infoTableViewCell.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Red Prado on 6/6/14.
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

@interface infoTableViewCell : UITableViewCell
 
@property (strong, nonatomic) IBOutlet UIImageView *infoLogoImage;
@property (strong, nonatomic) IBOutlet UITextView *directionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *directionIconImage;
@property (strong, nonatomic) IBOutlet UILabel *horarioLabel;
@property (strong, nonatomic) IBOutlet UIImageView *horarioIconImage;
@property (strong, nonatomic) IBOutlet UILabel *paymentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *paymentIconImage;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIImageView *telIconImage;


@end
