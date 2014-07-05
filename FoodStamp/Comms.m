//
//  Comms.m
//  FoodStamp
//
//  Created by Jesus Cruz Perez on 01/04/14.
//  Copyright (c) 2014 Toby Stephens. All rights reserved.
//

#import "Comms.h"

@implementation Comms

+ (void) login:(id<CommsDelegate>)delegate
{
   NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

    [PFFacebookUtils initializeFacebook];
    
   // Login PFUser using Facebook
   [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
      if (!user) {
			if (!error) {
            NSLog(@"The user cancelled the Facebook login.");
         } else {
            NSLog(@"An error occurred: %@", error.localizedDescription);
         }
         
			// Callback - login failed
			if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
				[delegate commsDidLogin:NO];
			}
		} else {
			if (user.isNew) {
				NSLog(@"User signed up and logged in through Facebook!");
			} else {
				NSLog(@"User logged in through Facebook!");
			}
         
			// Callback - login successful
			if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
				[delegate commsDidLogin:YES];
			}
		}
   }];
}


@end
