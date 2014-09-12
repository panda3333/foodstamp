//
//  HomePlatilloCell.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Red Prado on 4/1/14.
//
//	Purpose:
//	This file is for cells of the Home Screen.
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

@interface HomePlatilloCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *parseImage;
@property (strong, nonatomic) IBOutlet UIView *platilloTopView;
@property (strong, nonatomic) IBOutlet UIView *platilloBotView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpiner;

// agregar platilloNameLabel, restaurantNameLabel.
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *platilloNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *platilloPriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *labelYummies;


@end
