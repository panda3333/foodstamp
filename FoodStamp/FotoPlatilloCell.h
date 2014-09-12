//
//  FotoPlatilloCell.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Red Prado on 3/28/14.
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


@interface FotoPlatilloCell : UITableViewCell
//Imagen de platillo
@property (strong, nonatomic) IBOutlet UIImageView *platilloImage;
//Subvista para mostrar precio y distancia
@property (strong, nonatomic) IBOutlet UIView *subDataView;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mapIconImage;
@property (strong, nonatomic) IBOutlet UILabel *yummieLabel;



@end
