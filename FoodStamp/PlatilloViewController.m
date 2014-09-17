//
//  PlatilloViewController.m
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created on 3/28/14.
//  Authors: Red Prado, Jesus Cruz Perez and Jose Daniel Leal Avila.
//
//	Purpose:
//	This file is for the Dish Screen.
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

#import "PlatilloViewController.h"
#import "FotoPlatilloCell.h"
#import "DescripcionRestTableViewCell.h"
#import "RestaurantViewController.h"
#import "LocationViewController.h"
#import "SocialCell.h"
#import "DirecCell.h"
#import "ViewController.h"
#import "menuViewController.h"
#import "Parse/Parse.h"
#import <Social/Social.h>
#import "MBProgressHUD.h"

@interface PlatilloViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) MBProgressHUD *mainHud;


@end

@implementation PlatilloViewController{
    NSString *restaurantPhone;
}

@synthesize platilloTableView,platilloTableController,userIconImage, index, parseArray, preParseArray, menuArray, restaurantNameLabel;


- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     Make round avatar: Note that iOS7 automatically imports <QuartzCore/QuartzCore.h>
     So to make this code functional in previous versions this framework needs to be imported.
     */
    userIconImage.layer.cornerRadius= userIconImage.frame.size.height/2;
    userIconImage.layer.borderWidth=0; // border width.
    userIconImage.clipsToBounds =YES;
    
    self.mainHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.mainHud.labelText = NSLocalizedString(@"Loading", nil);
    self.mainHud.dimBackground = YES;
    
    //NSLog(@"LOS datos-------------->%@",self.parseArray);
    
    //NSDictionary *platilloActual = [[NSDictionary alloc] initWithObjectsAndKeys:self.dish, nil];
    //NSLog(@"%@",platilloActual);
}

# pragma TableViewMethods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // NSLog(@"Creating cells");
    return 1;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
  /*  o
   Obtain and define the cellIdentifiers in a "Global" manner (emphasis on the quotation marks).
   This way, it is possible to call them in HeightForRowAtIndexPath and hence obtain the height of each cell
   individually. If this is not obtained, HeightForRowAtIndexPath would only take the height of the first cell
   and all remaining cells would have the same height
   ////////////
   This DOES NOT allow dynamicallt adjusting the size of the cell in relation to the received text from web, thus
   it is recommended to NOT change the layout dynamically or else it might provoke design flaws.
   */
    NSString *cellIdentifier = nil;
    
    switch (indexPath.section)
    {
        case 0:
            cellIdentifier = @"fotoPlatilloCell";
                        break;
        case 1:
            cellIdentifier = @"descripcionRestCell";
                        break;
        case 2:
            cellIdentifier = @"socialIconsCell";
                        break;
        case 3:
            cellIdentifier = @"descripcionCell";
                        break;
  
    }
    return cellIdentifier;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     This method does 3 steps:
     1. It starts by obtaining the specific identifier of each cell, saving it in a NSString. This is done by
        delegating the attainment the identifier to the method cellIdentifierForIndexPath.
     2. A dictionary is generated to store the different sizes of each cell. This is possible since heightForRowAtIndexPath
        gets the height from the cell that exists in the StoryBoard. For this same reason, the desired height for each
        cell must be correctly adjusted from the StoryBoard and in the Size Inspector.
     3. It is proved that the dictionary is null to then initialize it and allocate it.
     Once the height is obtained, it is then assigned to the created cell which is then shown in the app.
     */
    
    NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    static NSMutableDictionary *heightCache;
    if (!heightCache)
        heightCache = [[NSMutableDictionary alloc] init];
    NSNumber *cachedHeight = heightCache[cellIdentifier];
    if (cachedHeight)
        return cachedHeight.floatValue;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CGFloat height = cell.bounds.size.height;
    heightCache[cellIdentifier] = @(height);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
          //  NSLog(@"indexPath: %ld",(long)indexPath.section);
    PFObject *dish = [self.parseArray objectAtIndex:self.index];
    restaurantNameLabel.text = [dish objectForKey:@"Name"];
    NSString *restaurantName;
    if (indexPath.section == 0 ){
        
        static NSString *cellIdentifier = @"fotoPlatilloCell";
        
        FotoPlatilloCell *cell = [platilloTableView dequeueReusableCellWithIdentifier: cellIdentifier];
        if(cell == nil){
            cell = [[FotoPlatilloCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }

        PFFile *imageFile = [dish objectForKey:@"Photo"];
        NSNumber *platilloPrice = [dish objectForKey:@"Price" ];
        NSNumber *countYummies = [dish objectForKey:@"Yummies"];
   
        //NSLog(@"%@",dish);
        
        [cell.contentView addSubview:cell.platilloImage];
       
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            if(!error){
                cell.platilloImage.image = [UIImage imageWithData: data];
            }
        }];
        
        PFObject *restaurant = dish[@"Restaurant"];
        
        [restaurant fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if(!error){
                NSLog(@"----------------:%@",restaurant);
                cell.distanceLabel.text = [restaurant objectForKey:@"Name"];
            }
        }];
        
        [cell.contentView addSubview:cell.subDataView];
        [cell.subDataView addSubview:cell.priceLabel];
        
        NSString *precioFinal = platilloPrice.stringValue;
        NSString *yummies = countYummies.stringValue;

        if (yummies == nil) {
            yummies = @"0";
        }
        
        NSString *nameYummies = @"Favoritos";
        NSString *precioLogo = @"$";
        NSString *joinString=[NSString stringWithFormat:@"%@ %@",precioLogo,precioFinal];
        NSString *joinYummies = [NSString stringWithFormat:@"%@ %@",yummies, nameYummies];
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:joinString];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0,2)];
        
        cell.priceLabel.attributedText= string;
        cell.yummieLabel.text = joinYummies;
        
        [cell.subDataView addSubview:cell.mapIconImage];
        //NSLog(@"distance returned");
        [cell.subDataView addSubview:cell.distanceLabel];
        cell.distanceLabel.text = restaurantName;
        //NSLog(@"cell returned");
        return cell;
        
    }else if (indexPath.section == 1){
        
        //NSLog(@"creating second custom cell");
        static NSString* cellIdentifier1 = @"descripcionRestCell";
        //NSLog(@"define cell 2 origin");
        DescripcionRestTableViewCell *cellTwo = (DescripcionRestTableViewCell*)[platilloTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        //NSLog(@"creating 2nd cell NIB");
        
        if (cellTwo == nil) {
            // NSLog(@"entró a segundo nil");
            // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:nil options:nil];
            // cellTwo  = (DescripcionRestTableViewCell*)[nib objectAtIndex:0];
            cellTwo = [[DescripcionRestTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
        }
        
        [cellTwo.contentView addSubview:cellTwo.descripcionTextView];
        NSString *descripcionPlatillo = [dish objectForKey:@"Description"];
        cellTwo.descripcionTextView.text = descripcionPlatillo;
        
        return cellTwo;
        
    }else if (indexPath.section == 2){
        //NSLog(@"creating third custom cell");
        static NSString* cellIdentifier2 = @"socialIconsCell";
        //NSLog(@"deque'ing cellidentifier2");
        SocialCell *cellThree = (SocialCell*) [tableView dequeueReusableCellWithIdentifier: cellIdentifier2];
        
        [cellThree.toRestaurant addTarget:self action:@selector(restButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        if (cellThree == nil) {
            //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:nil options:nil];
            //cellThree = (SocialCell*)[nib objectAtIndex:0];
            cellThree = [[SocialCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2 ];
        }
        
        //NSLog(@"cell 3 Rturned");
        [cellThree.contentView addSubview:cellThree.wishLabel];
        [cellThree.contentView addSubview:cellThree.shareLabel];
        [cellThree.contentView addSubview:cellThree.likeLabel];
        
        if (self.fromMenu) {
            //add images pressed :)
            //[cellThree.toRestaurant setImage:nil forState:UIControlStateDisabled];
            [cellThree.toRestaurant setImage:[UIImage imageNamed:@"boton-restaurantON.png"] forState:UIControlStateNormal];
            [cellThree.toRestaurant setEnabled:NO];
        } else {
            [cellThree.toRestaurant setEnabled:YES];
            cellThree.toRestaurant.hidden = NO;
        }
        
        PFObject *dish = [self.parseArray objectAtIndex:self.index];
        NSString *dishId = dish.objectId;
        NSString *userId = [PFUser currentUser].objectId;
        
        // Query if the current dish exists for this user in the YummieRels, Yummie or Unyummie the dish according to the result
        
        // Create a query to the YummiesRels table
        PFQuery *YumQuery = [PFQuery queryWithClassName:@"YummiesRels"];
        
        // Follow relationship
        [YumQuery whereKey:@"UserID" equalTo:userId];
        [YumQuery whereKey:@"YummiedDish" equalTo:dishId];
        
        [YumQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                if (count != 0) {
                    [cellThree.favButton setImage:nil forState:UIControlStateNormal];
                    [cellThree.favButton setImage:[UIImage imageNamed:@"boton-favoritoON-02.png"] forState:UIControlStateNormal];
                } else {
                    [cellThree.favButton setImage:[UIImage imageNamed:@"boton-favorito-01.png"] forState:UIControlStateNormal];
                }
            }
        }];
        
        return cellThree;
    }else if (indexPath.section == 3){
        
            static NSString* cellIdentifier3 = @"descripcionCell";
        
            DirecCell *cellFour = (DirecCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        
            if (cellFour == nil) {
                //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier3 owner:nil options:nil];
                //cellFour = (DirecCell*)[nib objectAtIndex:0];
                cellFour = [[DirecCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier3 ];
        }
        //Get thumbnail file
        PFObject *restaurant = dish[@"Restaurant"];

        [restaurant fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if(!error){
                NSLog(@"----------------:%@",restaurant);

                cellFour.horarioLabel.text = [restaurant objectForKey:@"Schedule"];
                cellFour.pagoLabel.text =[restaurant objectForKey:@"Payment"];
                cellFour.directionTextView.text =[restaurant objectForKey:@"Address"] ;
                cellFour.directionTextView.textColor = [UIColor colorWithRed:(76/255.0) green:(76/255.0) blue:(76/255.0) alpha:1] ;
                restaurantPhone =[restaurant objectForKey:@"Phone"];
                cellFour.telLabel.text=[restaurant objectForKey:@"Phone"];
                
                PFFile *logoImage = [restaurant  objectForKey:@"Logo"];
                if (logoImage==nil) {               // if there is no Restaurant logo, hide mainHud
                    NSLog(@"data image is null");
                    NSLog(@"Hiding mainHUD");
                    [self.mainHud hide:YES];
                }else{
                    [logoImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                        if(!error){
                            cellFour.logoImage.image = [UIImage imageWithData:data];
                            NSLog(@"Hiding mainHUD");
                            [self.mainHud hide:YES];
                        }
                    }];
                }
            }
        }];
        
        [cellFour.contentView addSubview:cellFour.horarioLabel];
        [cellFour.contentView addSubview:cellFour.pagoLabel];

        UITapGestureRecognizer *telLabelTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callRestaurant)];
        telLabelTouch.numberOfTapsRequired = 1;
        [cellFour.contentView addSubview:cellFour.telLabel];
        [cellFour.telLabel addGestureRecognizer:telLabelTouch];
        
        [cellFour.contentView addSubview:cellFour.direcIconImage];
        UITapGestureRecognizer *direcImageTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMap:)];
        direcImageTouch.numberOfTapsRequired = 1;
        cellFour.direcIconImage.userInteractionEnabled =YES;
        [cellFour.direcIconImage addGestureRecognizer:direcImageTouch];
        
        [cellFour.contentView addSubview:cellFour.directionTextView];
        UITapGestureRecognizer *directionTextTouch =    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMap:)];
        directionTextTouch.numberOfTapsRequired =1;
        cellFour.directionTextView.userInteractionEnabled =YES;
        [cellFour.directionTextView addGestureRecognizer:directionTextTouch];
        
        [cellFour.contentView addSubview:cellFour.horaIconImage];
        [cellFour.contentView addSubview:cellFour.pagoIconImage];
        [cellFour.contentView addSubview:cellFour.telIconImage];
            UITapGestureRecognizer *phoneImageTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callRestaurant)];
        phoneImageTouch.numberOfTapsRequired = 1;
        cellFour.telIconImage.userInteractionEnabled = YES;
        [cellFour.telIconImage addGestureRecognizer:phoneImageTouch];
        
        [cellFour.contentView addSubview:cellFour.logoImage];
        
        if (!self.fromMenu) {
            UITapGestureRecognizer *toRestaurantTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restButtonClicked)];
            toRestaurantTouch.numberOfTapsRequired = 1;
            cellFour.logoImage.userInteractionEnabled = YES;
            [cellFour.logoImage addGestureRecognizer:toRestaurantTouch];
        }
        
        [cellFour.contentView addSubview:cellFour.directionTextView];

        return cellFour;
    }
    return nil;
}

-(void) callRestaurant{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:restaurantPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    NSLog(@"calling");
}

- (void)reloadData{
    
}

-(void) restButtonClicked{
    RestaurantViewController *RestaurantInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantView"];
    RestaurantInstance.parseArray = self.parseArray;
    RestaurantInstance.index =  self.index;
    
    RestaurantInstance.dish = [self.parseArray objectAtIndex: self.index];
    [self presentViewController:RestaurantInstance animated:YES completion:nil];
}

- (IBAction)backActionButton:(id)sender {
    // NSLog(@"ET phone Home ");
    
    if (self.fromMenu) {
        menuViewController *menuinstance = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
        menuinstance.menuArray = self.menuArray;
        menuinstance.parseArray = self.parseArray;
        menuinstance.preParseArray = self.preParseArray; // Just save previous state of original array
        menuinstance.preIndex = self.preIndex;           // Just save previous state of original index
        menuinstance.index = self.index;
        menuinstance.dish = self.dish;
        [self presentViewController:menuinstance animated:YES completion:nil];
    } else {
        ViewController *homeinstance = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
        homeinstance.parseArray = self.parseArray;
        homeinstance.index = self.index;
        [self presentViewController:homeinstance animated:YES completion:nil];
    }
}

- (IBAction)shareButton:(id)sender {
    NSLog(@"sharing");
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        PFObject *dish = [self.parseArray objectAtIndex:self.index];
        PFFile *thumbnailFile = [dish objectForKey:@"Photo"];
        PFObject *restaurant = dish[@"Restaurant"];
        
        
        NSString *platilloName = [dish objectForKey:@"Name"];
        NSString *initialText = @"de ";
        NSString *restaurantName = [restaurant objectForKey:@"Name"];
        NSString *endingText = @"#RecomendacionFoodstamp";
        NSString *socialMessage = [NSString stringWithFormat:@"%@ %@ %@ %@",platilloName,initialText,restaurantName, endingText];
        [controller setInitialText:socialMessage];
        // [controller addURL:[NSURL URLWithString:@"http://www.foodstamp.mx/landing/"]];
       
        // If this can be set, the image of the dish can be added to the facebook of the user who's going to share it, which might be cool
        // Get image and add it
        
        [thumbnailFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            if(!error){
                UIImage *logoFinal;
                logoFinal = [UIImage imageWithData:data];
                [controller addImage:logoFinal];
            }
        }];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)YummyButto:(id)sender {
    
    PFObject *dish = [self.parseArray objectAtIndex:self.index];
    NSString *dishId = dish.objectId;
    NSString *userId = [PFUser currentUser].objectId;
    
    //Query if the current dish exists for this user in the YummieRels, Yummie or Unyummie the dish according to the result
    
    // Create a query to the YummiesRels table
    PFQuery *YumQuery = [PFQuery queryWithClassName:@"YummiesRels"];
    
    // Follow relationship
    [YumQuery whereKey:@"UserID" equalTo:userId];
    [YumQuery whereKey:@"YummiedDish" equalTo:dishId];
    
    [YumQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { // if nothing went wrong
            if ([objects count] == 0) { // This means YUMMIE!! we want to INSERT to YummiesRels and yummie++
                NSLog(@"Not found so... Yummie the dish!");
                [dish incrementKey:@"Yummies" byAmount:[NSNumber numberWithInt:1]]; // yummie++
                
                self.hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:self.hud];
                
                self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
                
                self.hud.mode = MBProgressHUDModeCustomView;
                self.hud.labelText = @"¡Yummie! ";
                
                [self.hud showWhileExecuting:@selector(waitForTwoSeconds)
                                    onTarget:self withObject:nil animated:YES];
                
                // INSERT new relation
                PFObject *newYumRel = [PFObject objectWithClassName:@"YummiesRels"]; // Create Yummie
                newYumRel[@"YummiedDish"] = dishId;                                  // Set the content
                newYumRel[@"UserID"] = userId;                                       // Create relationship
                
                // Save new relation and new Yummied dish
                [newYumRel saveInBackground];
                [dish saveInBackground];
                
                // Update the Yummie counter with new count
                [self updateYummiesCount:[dish objectForKey:@"Yummies"]];
                [sender setImage:[UIImage imageNamed:@"boton-favoritoON-02.png"] forState:UIControlStateNormal];
                
            } else { // This means UNYUMMIE!! we want to DELETE to YummiesRels and yummie--
                NSLog(@"Relation found so... Unyummie!");
                [dish incrementKey:@"Yummies" byAmount:[NSNumber numberWithInt:-1]]; // yummie--
                
                self.hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:self.hud];
                
                self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
                
                self.hud.mode = MBProgressHUDModeCustomView;
                self.hud.labelText = @"¡No Yummie! :(";
                
                [self.hud showWhileExecuting:@selector(waitForTwoSeconds)
                                    onTarget:self withObject:nil animated:YES];
                
                /*DELETE relation */
                PFObject *toDelete = [objects objectAtIndex:0]; // Create object to be deleted
                [toDelete deleteInBackground];                  // Remove content
                
                [dish saveInBackground];
                
                // Update the Yummie counter with new count
                [self updateYummiesCount:[dish objectForKey:@"Yummies"]];
                [sender setImage:[UIImage imageNamed:@"boton-favorito-01.png"] forState:UIControlStateNormal];
            }
        }else{
            NSLog(@"Error...");
            
        }
    }];
    
}

- (void)updateYummiesCount: (NSNumber *) num {
    NSIndexPath * indexCell = [NSIndexPath indexPathForItem:0 inSection:0];
    FotoPlatilloCell *cell = (FotoPlatilloCell *)[platilloTableView cellForRowAtIndexPath:indexCell];

    NSString *yummies = num.stringValue;
    if (yummies == nil) {
        yummies = @"0";
    }
    NSString *nameYummies = @"Favoritos";
    NSString *joinYummies = [NSString stringWithFormat:@"%@ %@",yummies, nameYummies];
    NSLog(@"Contador Yummies %@", joinYummies);
    cell.yummieLabel.text = joinYummies;
}

- (void)waitForTwoSeconds {
    sleep(2);
}

-(void)goToMap :(id)sender
{
    PFObject *dish = [self.parseArray objectAtIndex:self.index];
    NSLog(@"To Map");
    PFObject *restaurant = dish[@"Restaurant"];
    PFGeoPoint *restaurantLocation = [restaurant objectForKey:@"GeoLocation"];
    NSLog(@"%@",restaurantLocation);
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(restaurantLocation.latitude, restaurantLocation.longitude) addressDictionary:nil];
    _destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    [_destination setName:[restaurant objectForKey:@"Name"]];
    [_destination openInMapsWithLaunchOptions:nil];
  
    // Show user location in the map only works with a device, not with the simulator.
    _minMapView.showsUserLocation = YES;
    
    MKUserLocation *userLocation = _minMapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate,20000, 20000);
    
    [_minMapView setRegion:region animated:NO];
    //_minMapView.delegate = self;
    [self getDirections];
    
}
- (void)getDirections{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = _destination;
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response{
    for (MKRoute *route in response.routes)
    {
        [_routeMap
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

@end
