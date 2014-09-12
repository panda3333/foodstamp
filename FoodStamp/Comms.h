//
//  Comms.h
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Jesus Cruz Perez on 01/04/14.
//
//	Purpose:
//	This file is for communication protocol purposes
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

@protocol CommsDelegate <NSObject>
//Test comment... blah blah blah awesome happens blah blah
@optional
   - (void) commsDidLogin:(BOOL)loggedIn;
@end

@interface Comms : NSObject
    + (void) login:(id<CommsDelegate>)delegate;
@end
