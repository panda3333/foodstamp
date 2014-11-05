//
//  infoViewController.m
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

#import "infoViewController.h"
#import "FBLoginViewController.h"
#import <Parse/Parse.h>
#import "ViewController.h"

@interface infoViewController ()

@end

@implementation infoViewController

@synthesize parseArray, index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backHome:(id)sender {
    ViewController *homeinstance = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    homeinstance.parseArray = self.parseArray;
    homeinstance.index = self.index;
    [self presentViewController:homeinstance animated:YES completion:nil];

}



- (IBAction)logOut:(id)sender {
    
    [PFUser logOut];
    FBLoginViewController *fbLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FaceBookLogInViewController"];
        [self presentViewController:fbLoginViewController animated:YES completion:nil];
    
        NSLog(@"Sign out from FoodStamp");

}
@end
