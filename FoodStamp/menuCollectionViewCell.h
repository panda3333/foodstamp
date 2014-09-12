//
//  menuCollectionViewCell.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Red Prado on 6/12/14.
//
//	Purpose:
//	This file is for the cell that contains dish data.
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

@interface menuCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *platilloImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpiner;
@property (strong, nonatomic) IBOutlet UILabel *platilloNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UILabel *labelYummies;

@end
