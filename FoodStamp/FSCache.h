//
//  Cache.h
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

#import <Foundation/Foundation.h>

@interface FSCache : NSObject

+ (id)sharedCache;
@property (nonatomic,strong) NSCache *cache;

@end
