//
//  infoViewController.h
//  FoodStamp
//
//  Created by Red Prado on 6/14/14.
//  Copyright (c) 2014 FoodStamp. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface infoViewController : UIViewController

@property (strong,nonatomic) NSMutableArray *parseArray;

- (IBAction)backHome:(id)sender;
- (IBAction)logOut:(id)sender;


@end
