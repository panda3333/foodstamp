//
//  Cache.m
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Jesus Cruz Perez on 18/04/14.
//
//	Purpose:
//	This file is for Cache functions.
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


#import "FSCache.h"
@implementation FSCache

@synthesize cache;

#pragma mark - Initialization

+ (id)sharedCache{
   static dispatch_once_t pred = 0;
   __strong static id _sharedObject = nil;
   
   dispatch_once(&pred, ^{
      _sharedObject = [[self alloc] init];
   });
   
   return _sharedObject;
}

- (id)init{
   self = [super init];
   if (self) {
      self.cache = [[NSCache alloc] init];
   }
   return self;
}

#pragma mark - FSCache

- (void) setPhoto:(PFObject *)photo{
   
}

@end
