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
@property (nonatomic, assign) int index;
@property (nonatomic, assign) short preIndex;
@property (nonatomic, assign) BOOL fromMenu;
@property (strong, nonatomic) NSMutableArray *parseArray;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (strong, nonatomic) NSMutableArray *preParseArray;
@property (strong, nonatomic) PFObject* dish;



- (IBAction)backActionButton:(id)sender;
- (IBAction)shareButton:(id)sender;

@end
