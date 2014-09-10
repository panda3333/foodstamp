//
//  menuViewController.m
//  FoodStamp
//
//  Created by Tracer on 6/12/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import "menuViewController.h"
#import "menuCollectionViewCell.h"
#import "RestaurantViewController.h"
#import "PlatilloViewController.h"
#import <Parse/Parse.h>


@interface menuViewController (){
    NSString *restaurantName;
    PFObject *restaurant;
}


@end

@implementation menuViewController
@synthesize platillosCollectionView,parseArray,preParseArray,restaurantNameLabel,menuArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self getRestaurant];
    
    if (self.dish != NULL){
    restaurant = self.dish[@"Restaurant"];
    NSString *restaurantHeaderName = [restaurant objectForKey:@"Name"];
    restaurantNameLabel.text = restaurantHeaderName;
    }
    if(self.menuArray.count == 0){
        [self dishesQuery];
    }
    /*if(self.parseArray.count == 0){
        [self dishesQuery];
    }*/

}

- (void)getRestaurant{
    restaurant = self.dish[@"Restaurant"];
    
   // NSLog(@"Los platillos----------> %@",restaurant);
}
-(void)dishesQuery{
    
  
    PFQuery *query = [PFQuery queryWithClassName:@"Dishes"];

   // NSLog(@"El id -------->%@",[restaurant objectId]);

    [query whereKey:@"Restaurant"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Restaurant" objectId:[restaurant objectId]]];
    [ query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
    if(!error){
        menuArray = [[NSMutableArray alloc] initWithArray:results];
        //parseArray = [[NSMutableArray alloc] initWithArray:results];
        NSLog(@"resultados: %@",results);
        [platillosCollectionView reloadData];
          }
    }];

}

#pragma mark - UICollectionView Methods

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [menuArray count];
    //return [parseArray count];
    NSLog(@"oarse array coun in Restaurante--->%lu",(unsigned long)menuArray.count);
    NSLog(@"oarse array coun in Restaurante--->%lu",(unsigned long)parseArray.count);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"platilloCell";

    menuCollectionViewCell *cell = ( menuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath]; 
    
    PFObject *imageObject = [menuArray objectAtIndex:indexPath.row];
    //PFObject *imageObject = [parseArray objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"Photo"];
    

    NSString *platilloName = [imageObject objectForKey:@"Name"];
    NSNumber *platilloPrice = [imageObject objectForKey:@"Price"];
    NSNumber *countYummies = [imageObject objectForKey:@"Yummies"];
    
    NSString *yummies = countYummies.stringValue;
    
    if (yummies == nil) {
        yummies = @"0";
    }
    
    
    NSString *nameYummies = @"Favoritos";
    
    NSString *joinYummies = [NSString stringWithFormat:@"%@ %@",yummies, nameYummies];
    
    [cell.loadingSpiner stopAnimating];
    cell.loadingSpiner.hidden  =YES;
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if(!error){
            NSString *precioFinal = platilloPrice.stringValue;
            NSString *precioLogo = @"$";

            NSString *joinString=[NSString stringWithFormat:@"%@ %@",precioLogo,precioFinal];
            

            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:joinString];
            
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0,1)];
            cell.priceLabel.attributedText = string;
           
            cell.platilloNameLabel.text = platilloName;
            cell.labelYummies.text = joinYummies;
            cell.platilloImage.image=[UIImage imageWithData:data];
            
            [cell.loadingSpiner stopAnimating];
            cell.loadingSpiner.hidden  = YES;
        }
        
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
    
    PlatilloViewController *dishViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlatilloView"];

    dishViewController.preParseArray = self.preParseArray;
    if (self.firstTimeInMenu) {
        dishViewController.preParseArray = self.parseArray; // Save previous state of Array
        dishViewController.preIndex = self.index;           // Save previous state of Index from original Array
        self.firstTimeInMenu = false;
    }
    dishViewController.menuArray = self.menuArray;
    dishViewController.parseArray = self.menuArray;     // Substitute array to correctly gather data
    dishViewController.index =  indexPath.row;          // Substitute index to correctly gather data
    dishViewController.dish = self.dish;
    dishViewController.fromMenu = true;
    
    
    //NSString *className = NSStringFromClass([[self.platillosImagesArray objectAtIndex:indexPath.row] class]);
    //NSLog(@"%@",className);
    
    [self presentViewController:dishViewController animated:YES completion:nil];
}
    
    

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5; // This is the minimum inter item spacing, can be more
}
- (IBAction)backRestButton:(id)sender {

    RestaurantViewController *RestaurantInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantView"];
    RestaurantInstance.dish = self.dish;
    if (self.preParseArray.count == 0) { // if user has gone to menuView, use preParseArray and preIndex, otherwise use normal parseArray and index
        RestaurantInstance.parseArray = self.parseArray;
        RestaurantInstance.index = self.index;
    }else{
        RestaurantInstance.parseArray = self.preParseArray;
        RestaurantInstance.index = self.preIndex;
    }
    self.firstTimeInMenu = true;
    //RestaurantInstance.index = self.index;
    [self presentViewController:RestaurantInstance animated:YES completion:nil];
}
@end
