//
//  SocialCell.h
//  FoodStamp
//
//  Created by Red Prado on 3/30/14.
//  Copyright (c) 2014 FoodStamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialCell : UITableViewCell

//Declare Labels
@property (strong, nonatomic) IBOutlet UILabel *wishLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareLabel;
//Buttons
@property (strong, nonatomic) IBOutlet UIButton *favButton;
@property (strong, nonatomic) IBOutlet UIButton *toRestaurant;

//Actions For Buttons

- (IBAction)likeActionButton:(id)sender;
- (IBAction)facebookActionButton:(id)sender;



@end
