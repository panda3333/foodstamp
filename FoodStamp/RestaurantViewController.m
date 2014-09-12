//
//  RestaurantViewController.m
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created on 4/2/14.
//  Authors: Red Prado, Jesus Cruz Perez and Jose Daniel Leal Avila.
//
//	Purpose:
//	This file is for the Restaurant Screen.
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

#import "RestaurantViewController.h"
#import "UserInteractionCell.h"
#import "RestInfoCell.h"
#import "infoTableViewCell.h"
#import "LocationViewController.h"
#import "PlatilloViewController.h"
#import "menuViewController.h"
#import <Social/Social.h>
#import "ViewController.h"

@interface RestaurantViewController ()

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSString *description;
@property(nonatomic, strong) UIImage *logo;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation RestaurantViewController{
    NSString *restaurantPhone;
}

@synthesize restaurantTableView,restaurantTableController,scrollView,pageControl,pageImages,pageViews,miniMenuCollectionView, dish,restaurantNameLabel,description,logo;


- (void)loadPage:(NSInteger)page {
    
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what needs to be displayed, then do nothing
        return;
    }
    
    // 1

    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // 2

        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // 3
        PFObject *imageObject = [self.pageImages objectAtIndex:page];
        PFFile *imageFile = [imageObject objectForKey:@"Photo"];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error){
                
                UIImageView *newPageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
                
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
        }];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what needs to be displayed, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control

    self.pageControl.currentPage = page;
    
    // Work out which pages shall be loaded

    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + pageImages.count;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
	// Load pages in the proposed range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryParseMethod];
    [miniMenuCollectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that could be recreated.
}
#pragma mark - Parse retrieve Methods

-(void)queryParseMethod{
    //2
    PFObject *restaurant = self.dish[@"Restaurant"];
    
    [restaurant fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error){
            [self populateImages:restaurant];
//          NSLog(@"-------------------->%@",restaurant);
            restaurantNameLabel.text = [restaurant objectForKey:@"Name"];
            description = [restaurant objectForKey:@"Description"];
            
        }
    }];
}

- (void)populateImages: (PFObject *) restaurant{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo_Restaurant"];
    [query whereKey:@"Restaurant" equalTo:restaurant];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.pageImages = [NSArray arrayWithArray:objects];
            self.pageControl.currentPage = 0;
            self.pageControl.numberOfPages = self.pageImages.count;
            
            // 4
            self.pageViews = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < self.pageImages.count; i++) {
                [self.pageViews addObject:[NSNull null]];
            }
            [self loadVisiblePages];
            CGSize pagesScrollViewSize = self.scrollView.frame.size;
            self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
        }
    }];
}

#pragma mark -  TableView Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath{
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
    
    switch (indexPath.section){
        case 0:
            cellIdentifier = @"descripcionRestCell";
            break;
        case 1:
            cellIdentifier = @"userInteractionCell";
            break;
        case 2:
            cellIdentifier = @"infoCell";
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
    //NSLog(@"indexPath: %ld",(long)indexPath.section);
    if (indexPath.section == 0 ){
        static NSString *cellIdentifier = @"descripcionRestCell";
        RestInfoCell *cell = [restaurantTableView dequeueReusableCellWithIdentifier: cellIdentifier];
//      RestInfoCell *cell = (RestInfoCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        if(cell == nil){
            cell = [[RestInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }

        [cell.contentView addSubview:cell.restInfoLabel];
        cell.restInfoLabel.text = description;
        return cell;
    }else if (indexPath.section == 1){
        static NSString* cellIdentifier1 = @"userInteractionCell";
        UserInteractionCell *cellTwo = (UserInteractionCell *)[restaurantTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        if (cellTwo == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:nil options:nil];
            cellTwo  = (UserInteractionCell*)[nib objectAtIndex:0];
            cellTwo = [[UserInteractionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
        }
        
        [cellTwo.contentView addSubview:cellTwo.decideLabel];
            cellTwo.decideLabel.text = @"Menu";
        [cellTwo.contentView addSubview:cellTwo.exploraLabel];
    //    [cellTwo.contentView addSubview:cellTwo.calificaLabel];
        [cellTwo.contentView addSubview:cellTwo.shareLabel];
        
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *mapaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //            UIButton *rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];

        // Set the position of the button
        menuButton.frame = CGRectMake(cellTwo.frame.origin.x + 45, cellTwo.frame.origin.y + 12, 38, 38);
        mapaButton.frame = CGRectMake(cellTwo.frame.origin.x + 140, cellTwo.frame.origin.y + 12, 38, 38);
        //    rateButton.frame = CGRectMake(cellTwo.frame.origin.x + 171, cellTwo.frame.origin.y + 8, 38, 38);
        shareButton.frame = CGRectMake(cellTwo.frame.origin.x + 233, cellTwo.frame.origin.y + 12, 38, 38);
        // Define Custom Image
        UIImage *menuImage =[UIImage imageNamed: @"boton_menu.png"];
                UIImage *menuOnImage =[UIImage imageNamed: @"boton_menu-on.png"];
        UIImage *mapImage =[UIImage imageNamed: @"boton_mapa.png"];
            UIImage *mapOnImage =[UIImage imageNamed: @"boton_mapa-on.png"];
      //  UIImage *rateImage =[UIImage imageNamed: @"boton_califica.png"];
      //      UIImage *rateOnImage =[UIImage imageNamed: @"boton_califica-on.png"];
        UIImage *shareImage =[UIImage imageNamed: @"boton_facebook.png"];
        UIImage *shareOnImage =[UIImage imageNamed: @"boton_facebook-on.png"];
        // Set image for state
        [menuButton setImage:menuImage forState:UIControlStateNormal];
                [menuButton setImage:menuOnImage forState:UIControlStateSelected];
        [mapaButton setImage:mapImage forState:UIControlStateNormal];
            [mapaButton setImage:mapOnImage forState:UIControlStateSelected];
        //[rateButton setImage:rateImage forState:UIControlStateNormal];
        //    [rateButton setImage:rateOnImage forState:UIControlStateSelected];
        [shareButton setImage:shareImage forState:UIControlStateNormal];
        [shareButton setImage:shareOnImage forState:UIControlStateSelected];
        
        [menuButton addTarget:self action:@selector(goToMenu:) forControlEvents:UIControlEventTouchUpInside];
        [mapaButton addTarget:self action:@selector(goToMap:) forControlEvents:UIControlEventTouchUpInside];
//        [rateButton addTarget:self action:@selector(rateAction:) forControlEvents:UIControlEventTouchUpInside];
       [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        menuButton.backgroundColor= [UIColor clearColor];
        mapaButton.backgroundColor= [UIColor clearColor];
//        rateButton.backgroundColor= [UIColor clearColor];
//        shareButton.backgroundColor= [UIColor clearColor];
        
        [cellTwo.contentView addSubview:menuButton];
            [cellTwo.contentView addSubview:mapaButton];
        //        [cellTwo.contentView addSubview:rateButton];
        [cellTwo.contentView addSubview:shareButton];
        
        return cellTwo;
    }if(indexPath.section ==2){
        
        static NSString* cellIdentifier2 =@"infoCell";
        infoTableViewCell *cellThree = (infoTableViewCell *)[restaurantTableView dequeueReusableCellWithIdentifier:cellIdentifier2 ];
        
        if (cellThree ==nil) {
            cellThree = [[infoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2];
        }
        // Get logo
         PFObject *restaurant = dish[@"Restaurant"];
        PFFile *logoImage = [restaurant  objectForKey:@"Logo"];
        
        [logoImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            if(!error){
                cellThree.infoLogoImage.image = [UIImage imageWithData:data];
            }
        }];
        [restaurant fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if(!error){
                cellThree.horarioLabel.text = [restaurant objectForKey:@"Schedule"];
                cellThree.paymentLabel.text =[restaurant objectForKey:@"Payment"];
                cellThree.directionTextView.text =[restaurant objectForKey:@"Address"] ;
                cellThree.directionTextView.textColor = [UIColor colorWithRed:(76/255.0) green:(76/255.0) blue:(76/255.0) alpha:1] ;
                restaurantPhone = [restaurant objectForKey:@"Phone"];
                cellThree.phoneLabel.text=[restaurant objectForKey:@"Phone"];
            }
        }];
        
        UITapGestureRecognizer *phoneLabelTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callRestaurant)];
        [cellThree.contentView addSubview:cellThree.phoneLabel];
        [cellThree.phoneLabel addGestureRecognizer:phoneLabelTouch];
        return cellThree;
    }
    return nil;
}

-(void)goToMenu :(id)sender{
    NSLog(@"To Menu");
    menuViewController *menuInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
    menuInstance.parseArray = self.parseArray;
    menuInstance.dish = self.dish;
    menuInstance.index = self.index;
    menuInstance.firstTimeInMenu = true;
    [self presentViewController:menuInstance animated:YES completion:nil];
}

-(void)goToMap :(id)sender {
    PFObject *restaurant = self.dish[@"Restaurant"];
    NSLog(@"EL restaurante--------------->%@",restaurant);
    PFGeoPoint *restaurantLocation = [restaurant objectForKey:@"GeoLocation"];
    
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(restaurantLocation.latitude, restaurantLocation.longitude) addressDictionary:nil];
    _destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    [_destination setName:[restaurant objectForKey:@"Name"]];
    [_destination openInMapsWithLaunchOptions:nil];
    
    // Show user location in the map only works with a device, not with the simulator.
    _minMapView.showsUserLocation = YES;
    
    MKUserLocation *userLocation = _minMapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate,
                                                                   20000, 20000);
    
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

-(void)rateAction :(id)sender{
    NSLog(@"Rating!!");
}

-(void)shareAction :(id)sender{
    NSLog(@"sharing");
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        PFObject *restaurant = dish[@"Restaurant"];
        PFFile *logoImage = [restaurant  objectForKey:@"Logo"];
        
        NSString *platilloName = [dish objectForKey:@"Name"];
        NSString *initialText = @"de ";
        NSString *restaurantName = [restaurant objectForKey:@"Name"];
        NSString *endingText = @"#RecomendacionFoodstamp";
        NSString *socialMessage = [NSString stringWithFormat:@"%@ %@ %@ %@",platilloName,initialText,restaurantName, endingText];
        [controller setInitialText:socialMessage];
        // [controller addURL:[NSURL URLWithString:@"http://www.foodstamp.mx/landing/"]];
        
        // If this can be set, the image of the dish can be added to the facebook of the user who's going to share it, which might be cool
        // Get image and add it
        [logoImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            if(!error){
                UIImage *logoFinal;
                logoFinal = [UIImage imageWithData:data];
                        [controller addImage:logoFinal];
            }
        }];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)backButton:(id)sender {
    
    PlatilloViewController *dishInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"PlatilloView"];
    dishInstance.dish = [self.parseArray objectAtIndex: self.index];
    dishInstance.parseArray = self.parseArray;
    dishInstance.index = self.index;
    [self presentViewController:dishInstance animated:YES completion:nil];
    
}

-(void) callRestaurant{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:restaurantPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    NSLog(@"calling");
}

@end
