//
//  PlatilloViewController.h
//  FoodStamp
//
//  Created by Red Prado on 3/28/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "FotoPlatilloCell.h"
#import "PlatilloTableViewController.h"

@interface PlatilloViewController : UIViewController 
{
    //IBOutlet UITableView *platilloTableView;
}
@property (strong, nonatomic) IBOutlet UITableView *platilloTableView;
@property (strong, nonatomic) PlatilloTableViewController *platilloTableController;

@property (strong, nonatomic) IBOutlet UIImageView *userIconImage;
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) PFObject* dish;

- (IBAction)backActionButton:(id)sender;

@end
