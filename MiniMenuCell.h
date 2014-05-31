//
//  MiniMenuCell.h
//  FoodStamp
//
//  Created by Red Prado on 4/3/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniMenuCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *miniParseImage;
@property (strong, nonatomic) IBOutlet UILabel *platilloNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *restNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;



@end
