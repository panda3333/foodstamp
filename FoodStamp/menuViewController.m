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
#import <Parse/Parse.h>


@interface menuViewController (){
    NSString *restaurantName;
    PFObject *restaurant;
}


@end

@implementation menuViewController
@synthesize platillosCollectionView,parseArray,preParseArray,restaurantNameLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self getRestaurant];
    
    if(self.parseArray.count == 0){
        
    [self dishesQuery];
    }

}

- (void)getRestaurant{
    restaurant = self.dish[@"Restaurant"];
    
   // NSLog(@"Los platillos----------> %@",restaurant);
}
-(void)dishesQuery{
    
    restaurant = self.dish[@"Restaurant"];
    NSString *restaurantHeaderName = [restaurant objectForKey:@"Name"];
    restaurantNameLabel.text = restaurantHeaderName;

    PFQuery *query = [PFQuery queryWithClassName:@"Dishes"];

   // NSLog(@"El id -------->%@",[restaurant objectId]);

    [query whereKey:@"Restaurant"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Restaurant" objectId:[restaurant objectId]]];
    [ query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
    if(!error){
        parseArray = [[NSMutableArray alloc] initWithArray:results];
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

 return [parseArray count];
    
    NSLog(@"oarse array coun in Restaurante--->%lu",(unsigned long)parseArray.count);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"platilloCell";

    menuCollectionViewCell *cell = ( menuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath]; 
    
    PFObject *imageObject = [parseArray objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"Photo"];
    

    NSString *platilloName = [imageObject objectForKey:@"Name"];
            NSNumber *platilloPrice = [imageObject objectForKey:@"Price"];
    
    [cell.loadingSpiner stopAnimating];
    cell.loadingSpiner.hidden  =YES;
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if(!error){
            NSString *precioFinal = platilloPrice.stringValue;
            NSString *precioLogo = @"$";
            NSString *joinString=[NSString stringWithFormat:@"%@ %@",precioLogo,precioFinal];
            cell.priceLabel.text =joinString;
           
            cell.platilloNameLabel.text = platilloName;
            cell.platilloImage.image=[UIImage imageWithData:data];
            
            [cell.loadingSpiner stopAnimating];
            cell.loadingSpiner.hidden  =YES;
           
            
        }
        
    }];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5; // This is the minimum inter item spacing, can be more
}
- (IBAction)backRestButton:(id)sender {

    RestaurantViewController *RestaurantInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantView"];
    RestaurantInstance.dish = self.dish;
    [self presentViewController:RestaurantInstance animated:YES completion:nil];
}
@end
