//
//  ViewController.h
//  FoodStamp
//
//  Created by Red Prado on 3/28/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePlatilloCell.h"
#import "Parse/Parse.h"


@interface ViewController : UIViewController{
    NSArray *imageFileArray;
    NSArray *restaurantNameArray;
}

@property (strong, nonatomic) IBOutlet UICollectionView *platillosCollectionView;
@property (strong, nonatomic) IBOutlet UIImageView *userIconHomeImage;

@property (strong, nonatomic) IBOutlet UIView *optionsView;
@property (nonatomic, assign) int index;
@property (strong, nonatomic) NSMutableArray *parseArray;

//Button para menu opciones
- (IBAction)optionsButton:(id)sender;

//Botones de opciones
- (IBAction)randomButton:(id)sender;
- (IBAction)favoritesButton:(id)sender;
- (IBAction)popularButton:(id)sender;
- (IBAction)breakfastButton:(id)sender;
- (IBAction)lunchButton:(id)sender;
- (IBAction)dinnerButton:(id)sender;
- (IBAction)aboutButton:(id)sender;

- (NSMutableArray *)randomizeArray: (NSMutableArray *) originalArray;


@end
