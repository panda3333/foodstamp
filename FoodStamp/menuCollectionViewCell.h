//
//  menuCollectionViewCell.h
//  FoodStamp
//
//  Created by Tracer on 6/12/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menuCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *platilloImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpiner;
@property (strong, nonatomic) IBOutlet UILabel *platilloNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
