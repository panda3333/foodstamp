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
#import "PlatilloViewController.h"
#import "infoViewController.h"
#include <stdlib.h>
#include <time.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize platillosCollectionView,userIconHomeImage, optionsView, parseArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    //swipeRecognizers
    UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(optionsButton:)];
    [swipeLeftRight setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
    [self.view addGestureRecognizer:swipeLeftRight];
    
    
    //Obtener los elementos de Facabook
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            
            if (userData[@"location"][@"name"]) {
                userProfile[@"location"] = userData[@"location"][@"name"];
            }
            
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            
            if (userData[@"birthday"]) {
                userProfile[@"birthday"] = userData[@"birthday"];
            }
            
            if (userData[@"relationship_status"]) {
                userProfile[@"relationship"] = userData[@"relationship_status"];
            }
            
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            [self updateProfile];
            
        } else {
            NSLog(@"Error in the request Facebook: %@",error);
        }
    }];
    
    //Imagen de Usuario Redonda
    
    /*
    userIconHomeImage.layer.cornerRadius= userIconHomeImage.frame.size.height/2;
    userIconHomeImage.layer.borderWidth=0; //hancho del borde.
    userIconHomeImage.clipsToBounds = YES;*/
    
    //Auto correr Query en parse para buscar imágenes al iniciar pantalla.
    [PFQuery clearAllCachedResults];
    if (self.parseArray.count == 0) {
    [ self queryParseMethod];
}

    if (self.index != 0) {
        CGPoint savedScrollPosition = CGPointMake(0, 145 * (self.index/2));
        [self.platillosCollectionView setContentOffset:savedScrollPosition animated:NO];
    }
}

// Set received values if they are not nil and reload the table
- (void)updateProfile {
    
    
    // Download the user's facebook profile picture
    
    self.imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]) {
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        // Run network request asynchronously
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        if (!urlConnection) {
            NSLog(@"Failed to download picture");
        }
    }
}


#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // All data has been downloaded, now we can set the image in the header image view
    self.userIconHomeImage.image = [UIImage imageWithData:self.imageData];
    
    // Add a nice corner radius to the image
    self.userIconHomeImage.layer.cornerRadius = 17.0f;
    self.userIconHomeImage.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryParseMethod{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Dishes"];
    
    //PFObject *sourceObject = [query getObjectWithId:@"l4KoI7x11p"];
    //PFRelation *relation = [sourceObject relationforKey:@"Dishes"];
    
   // [query whereKey:@"Name" equalTo:@"Bacana"];
    
    //Con relacion
    //[[relation query] findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error){
        
            parseArray = [[NSMutableArray alloc] initWithArray:results];
                                        //[self.platillosImagesArray writeToFile:cacheDirectory atomically:YES];
            parseArray  = [self randomizeArray:parseArray];
                                        [platillosCollectionView reloadData];
            //NSLog(@"the array is: %@ ",platillosImagesArray);
          }
        
    }];
    
    
}


#pragma mark - UICollectionView data source

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [parseArray count];
    NSLog(@"oarse array coun in Restaurante--->%@",parseArray);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"imageCell";
    
    HomePlatilloCell *cell = (HomePlatilloCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *imageObject = [parseArray objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"Photo"];
    
    NSString *restaurantName = [imageObject objectForKey:@"restaurantName"];
    NSString *platilloName = [imageObject objectForKey:@"Name" ];
    NSNumber *platilloPrice = [imageObject objectForKey:@"Price"];
    NSNumber *countYummies = [imageObject objectForKey:@"Yummies"];
    
    NSString *yummies = countYummies.stringValue;
    
    if (yummies == nil) {
        yummies = @"0";
    }
    
    NSString *nameYummies = @"Yummies";
    
    NSString *joinYummies = [NSString stringWithFormat:@"%@ %@",yummies, nameYummies];

   cell.loadingSpiner.hidden = NO;
   [cell.loadingSpiner startAnimating];
   
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            cell.parseImage.image = [UIImage imageWithData:data];
            cell.restaurantNameLabel.text = restaurantName;
            cell.platilloNameLabel.text = platilloName;
            cell.labelYummies.text = joinYummies;

//NSNumber does have a stringValue, it does work but is not my personal preference because it gives you little control as to the format of the string.
            NSString *precioFinal = platilloPrice.stringValue;

            cell.platilloPriceLabel.text= precioFinal;
        
           [cell.loadingSpiner stopAnimating];
           cell.loadingSpiner.hidden = YES;
        }
    }];
    
    return cell;
}


- (NSMutableArray *)randomizeArray: (NSMutableArray *) originalArray{
    /* initialize random seed: */
    srand (time(NULL));
    
    for (NSUInteger i=1; i < originalArray.count; ++i) {
        /* generate secret number */
        NSUInteger pos = (rand() % i);
        [originalArray exchangeObjectAtIndex:i withObjectAtIndex:pos];
        
    }
    return originalArray;
}



// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//  NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
    
    PlatilloViewController *dishViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlatilloView"];
    
    dishViewController.parseArray = self.parseArray;
    dishViewController.index =  indexPath.row;
    
    
    //NSString *className = NSStringFromClass([[self.platillosImagesArray objectAtIndex:indexPath.row] class]);
    //NSLog(@"%@",className);
    
    [self presentViewController:dishViewController animated:YES completion:nil];
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
        optionsView.frame = CGRectMake(-100, 64, optionsView.frame.size.width, optionsView.frame.size.height);
    }];
    //[_homeIcon setImage:[UIImage imageNamed:@"Pokeball.png"]];
    
}

- (void) animateMainViewToRight{
    //Animate mainView
    [UIView animateWithDuration:0.2 animations:^(void){
        optionsView.frame = CGRectMake(0, 64, optionsView.frame.size.width, optionsView.frame.size.height);
    }];
    //[_homeIcon setImage:[UIImage imageNamed:@"clickedPokeBall.png"]];
}


- (IBAction)randomButton:(id)sender {
    [ self queryParseMethod];
}

- (void) filterDishesby: (NSString*)filter{
    
    PFQuery *query = [PFQuery queryWithClassName: @"Dishes"];
    
    [query whereKey:@"Category" equalTo:filter];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            parseArray = [[NSMutableArray alloc] initWithArray:objects];
            parseArray  = [self randomizeArray:parseArray];
            [platillosCollectionView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (IBAction)dessertsButton:(id)sender {
    [self filterDishesby:@"Postre"];
}


- (IBAction)breakfastButton:(id)sender {
    [self filterDishesby:@"Desayuno"];
}

- (IBAction)lunchButton:(id)sender {
    [self filterDishesby:@"Comida"];
}

- (IBAction)dinnerButton:(id)sender {
    [self filterDishesby:@"Comida, Cena"];
}

- (IBAction)aboutButton:(id)sender {
    infoViewController *aboutInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutView"];
    aboutInstance.parseArray = self.parseArray;
    
    [self presentViewController:aboutInstance animated:YES completion:nil];
    
}
@end
