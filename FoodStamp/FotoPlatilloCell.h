//
//  FotoPlatilloCell.h
//  FoodStamp
//
//  Created by Red Prado on 3/28/14.
//  Copyright (c) 2014 FoodStamp. All rights reserved.
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
