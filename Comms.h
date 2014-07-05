//
//  Comms.h
//  FoodStamp
//
//  Created by Jesus Cruz Perez on 01/04/14.
//  Copyright (c) 2014 Toby Stephens. All rights reserved.
//

@protocol CommsDelegate <NSObject>
//Comentario de prueba asjhkalsdfk
@optional
   - (void) commsDidLogin:(BOOL)loggedIn;
@end

@interface Comms : NSObject
    + (void) login:(id<CommsDelegate>)delegate;
@end
