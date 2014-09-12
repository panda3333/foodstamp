//
//  DirecCell.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Red Prado on 3/31/14.
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

@class DirecCell;
@protocol MyCustomCellDelegate
@end
@interface DirecCell : UITableViewCell{
    
    
}
//button

//labels

@property (strong, nonatomic) IBOutlet UILabel *horarioLabel;
@property (strong, nonatomic) IBOutlet UILabel *pagoLabel;
@property (strong, nonatomic) IBOutlet UILabel *telLabel;
//TextView
@property (strong, nonatomic) IBOutlet UITextView *directionTextView;
//UiImages
@property (strong, nonatomic) IBOutlet UIImageView *direcIconImage;
@property (strong, nonatomic) IBOutlet UIImageView *horaIconImage;
@property (strong, nonatomic) IBOutlet UIImageView *pagoIconImage;
@property (strong, nonatomic) IBOutlet UIImageView *telIconImage;

@property (strong, nonatomic) IBOutlet UIImageView *logoImage;

@end
