//
//  infoViewController.m
//  FoodStamp
//
//  Created by Tracer on 6/14/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import "infoViewController.h"
#import "FBLoginViewController.h"
#import <Parse/Parse.h>
#import "ViewController.h"

@interface infoViewController ()

@end

@implementation infoViewController

@synthesize parseArray;

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
    ViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    homeViewController.parseArray = self.parseArray;
    [self presentViewController:homeViewController animated:YES completion:nil];
}

- (IBAction)logOut:(id)sender {
    
    [PFUser logOut];
    FBLoginViewController *fbLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FaceBookLogInViewController"];
        [self presentViewController:fbLoginViewController animated:YES completion:nil];
    
        NSLog(@"Sign out from FoodStamp");

}
@end
