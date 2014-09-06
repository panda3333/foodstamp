//
//  infoTableViewCell.h
//  FoodStamp
//
//  Created by Tracer on 6/6/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoTableViewCell : UITableViewCell
 
@property (strong, nonatomic) IBOutlet UIImageView *infoLogoImage;
@property (strong, nonatomic) IBOutlet UITextView *directionTextView;
@property (strong, nonatomic) IBOutlet UILabel *horarioLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@end
