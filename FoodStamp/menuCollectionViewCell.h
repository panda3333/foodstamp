//
//  menuCollectionViewCell.h
//  FoodStamp
//
//  Created by Red Pradp on 6/12/14.
//  Copyright (c) 2014 Foodstamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menuCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *platilloImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpiner;
@property (strong, nonatomic) IBOutlet UILabel *platilloNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UILabel *labelYummies;

@end
