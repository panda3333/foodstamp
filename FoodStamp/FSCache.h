//
//  Cache.h
//  FoodStamp
//
//  Created by Jesus Cruz Perez on 18/04/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSCache : NSObject

+ (id)sharedCache;
@property (nonatomic,strong) NSCache *cache;

@end
