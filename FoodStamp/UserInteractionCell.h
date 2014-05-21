//
//  UserInteractionCell.h
//  FoodStamp
//
//  Created by Red Prado on 4/2/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInteractionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *decideLabel;
@property (strong, nonatomic) IBOutlet UILabel *exploraLabel;
@property (strong, nonatomic) IBOutlet UILabel *calificaLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareLabel;

//userInteraction Buttons
- (IBAction)decideButton:(id)sender;
- (IBAction)exploraButton:(id)sender;
- (IBAction)rateButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;


@end
