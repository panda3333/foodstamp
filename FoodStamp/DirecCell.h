//
//  DirecCell.h
//  FoodStamp
//
//  Created by Red Prado on 3/31/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirecCell : UITableViewCell

//labels
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *horarioLabel;
@property (strong, nonatomic) IBOutlet UILabel *pagoLabel;
@property (strong, nonatomic) IBOutlet UILabel *telLabel;
//TextView
@property (strong, nonatomic) IBOutlet UITextView *directionTextView;
//UiImages
@property (strong, nonatomic) IBOutlet UIImageView *direcIconImage;
@property (strong, nonatomic) IBOutlet UIImageView *horaIconImage;
@property (strong, nonatomic) IBOutlet UIImageView *pagoIconImage;
@property (strong, nonatomic) IBOutlet UIImageView *telIconImage;

@property (strong, nonatomic) IBOutlet UIImageView *logoImage;

@end
