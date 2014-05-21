//
//  ScrollTableViewCell.h
//  FoodStamp
//
//  Created by Red Prado on 4/2/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mapIconImage;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end
