//
//  SocialCell.h
//  FoodStamp
//
//  Created by Red Prado on 3/30/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialCell : UITableViewCell

//Declare Labels
@property (strong, nonatomic) IBOutlet UILabel *wishLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareLabel;

//Actions For Buttons
- (IBAction)wishActionButton:(id)sender;
- (IBAction)likeActionButton:(id)sender;
- (IBAction)facebookActionButton:(id)sender;



@end
