//
//  LocSocialCell.h
//  FoodStamp
//
//  Created by Red Prado on 4/3/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocSocialCell : UITableViewCell
- (IBAction)descubreButton:(id)sender;
- (IBAction)exploraButton:(id)sender;
- (IBAction)rateButton:(id)sender;
- (IBAction)shareButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *shareLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateLabel;
@property (strong, nonatomic) IBOutlet UILabel *exploraLabel;
@property (strong, nonatomic) IBOutlet UILabel *descubreLabel;

@end
