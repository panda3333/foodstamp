//
//  infoViewController.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Red Prado on 6/14/14.
//
//	Purpose:
//	This file is for the Information Disclaimer Screen View. Content may include code created and shared by Facebook, Inc.
//
//  Modifications:
//
//  File    Patching Date in
//  Version Bug      Production   Author           Modification
//  ======= ======== ============ ================ ===================================
//  1.0     00000000 DD-MMM-YYYY  Author's Name    - created
//
//  ==================================================================================
//

#import <UIKit/UIKit.h>


@interface infoViewController : UIViewController

@property (strong,nonatomic) NSMutableArray *parseArray;

- (IBAction)backHome:(id)sender;
- (IBAction)logOut:(id)sender;


@end
