//
//  HomePlatilloCell.h
//  FoodStamp
//
//  Created by Red Prado on 4/1/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
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
