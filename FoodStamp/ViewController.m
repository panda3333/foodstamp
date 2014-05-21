//
//  ViewController.m
//  FoodStamp
//
//  Created by Red Prado on 3/28/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//---------
// Pase Account data:
//      user: encisoenrique@foodstamp.mx
//      pass: foodstampwinners

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize platillosCollectionView,userIconHomeImage, optionsView, platillosImagesArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    //swipeRecognizers
    UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(optionsButton:)];
    [swipeLeftRight setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
    [self.view addGestureRecognizer:swipeLeftRight];
    
    //Imagen de Usuario Redonda
    userIconHomeImage.layer.cornerRadius= userIconHomeImage.frame.size.height/2;
    userIconHomeImage.layer.borderWidth=0; //hancho del borde.
    userIconHomeImage.clipsToBounds =YES;
    
    //Auto correr Query en parse para buscar imágenes al iniciar pantalla.
    
    [PFQuery clearAllCachedResults];
    [ self queryParseMethod];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryParseMethod{
    
//    PFQuery *query = [[PFQuery queryWithClassName:@"Restaurant"];
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    
    PFObject *sourceObject = [query getObjectWithId:@"l4KoI7x11p"];
    PFRelation *relation = [sourceObject relationforKey:@"Dishes"];
    
   // [query whereKey:@"Name" equalTo:@"Bacana"];
    
    [ [relation query] findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        
        if (!error){
            self.platillosImagesArray = [[NSMutableArray alloc] initWithArray:results];
                                        //[self.platillosImagesArray writeToFile:cacheDirectory atomically:YES];
            
                                        [platillosCollectionView reloadData];
                                        NSLog(@"the array is: %@ ",self.platillosImagesArray);
          }
        
    }];
    
}


#pragma mark - UICollectionView data source

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [platillosImagesArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"imageCell";
    HomePlatilloCell *cell = (HomePlatilloCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *imageObject = [platillosImagesArray objectAtIndex:indexPath.row];
    
    PFFile *imageFile = [imageObject objectForKey:@"Photo"];
    NSString *restaurantName = [imageObject objectForKey:@"restaurantName"];
        NSString *platilloName = [imageObject objectForKey:@"platilloName" ];
            NSString *platilloPrice = [imageObject objectForKey:@"precio" ];

   cell.loadingSpiner.hidden = NO;
   [cell.loadingSpiner startAnimating];
   
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            cell.parseImage.image = [UIImage imageWithData:data];
            cell.restaurantNameLabel.text = restaurantName;
            cell.platilloNameLabel.text = platilloName;
            cell.platilloPriceLabel.text =  platilloPrice;
           [cell.loadingSpiner stopAnimating];
           cell.loadingSpiner.hidden = YES;
        }
    }];
    
    return cell;
}

// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5; // This is the minimum inter item spacing, can be more
}


#pragma  - Animate optionsView Methods
- (IBAction)optionsButton:(id)sender {
    
    //posición inicial: -48x, 322 y , 95 width 492 height.

    if(optionsView.frame.origin.x >= 0){
        
        [self animateMainViewToLeft];
    
        
    }else{
        
        [self animateMainViewToRight];
    
    }
    
}

- (void) animateMainViewToLeft{
    //Animate mainView
    [UIView animateWithDuration:0.5 animations:^(void){
        optionsView.frame = CGRectMake(-100, 77, optionsView.frame.size.width, optionsView.frame.size.height);
    }];
    //[_homeIcon setImage:[UIImage imageNamed:@"Pokeball.png"]];
    
}

- (void) animateMainViewToRight{
    //Animate mainView
    [UIView animateWithDuration:0.5 animations:^(void){
        optionsView.frame = CGRectMake(0, 77, optionsView.frame.size.width, optionsView.frame.size.height);
    }];
    //[_homeIcon setImage:[UIImage imageNamed:@"clickedPokeBall.png"]];
}
- (IBAction)randomButton:(id)sender {
    
    NSLog(@"On a Faim!!! ");
    ViewController *platilloinstance = [self.storyboard instantiateViewControllerWithIdentifier:@"PlatilloView"];
    [self presentViewController:platilloinstance animated:YES completion:nil];
    

}

- (IBAction)favoritesButton:(id)sender {
}

- (IBAction)popularButton:(id)sender {
}

- (IBAction)breakfastButton:(id)sender {
}

- (IBAction)lunchButton:(id)sender {
}

- (IBAction)dinnerButton:(id)sender {
}

- (IBAction)aboutButton:(id)sender {
}
@end
