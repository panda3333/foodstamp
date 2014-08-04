//
//  RestaurantViewController.m
//  FoodStamp
//
//  Created by Red Prado on 4/2/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import "RestaurantViewController.h"
#import "UserInteractionCell.h"
#import "RestInfoCell.h"
#import "infoTableViewCell.h"
#import "LocationViewController.h"
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
        // If it's outside the range of what you have to display, then do nothing
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
        // If it's outside the range of what you have to display, then do nothing
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
    
    // Work out which pages you want to load

    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + pageImages.count;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
	// Load pages in our range
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryParseMethod];
    [miniMenuCollectionView reloadData];
    
    
}

    
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
}
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Parse retrieve Methods

-(void)queryParseMethod{
    //2
    
    PFObject *restaurant = self.dish[@"Restaurant"];
    
    [restaurant fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if(!error){
        
            [self populateImages:restaurant];
//     NSLog(@"-------------------->%@",restaurant);
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

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    /*  o
     
     Obtener y definir los cellIdentifiers de manera "Global" énfasis en las comillas.
     De esta forma podemos llamarlos an HeightForRowAtIndexPath y así obtendremos la altura de cada celda
     individualmente. Si esto no se obtiene HeightForRowAtIndexPath solo tomará la altura de la primer celda y todas las celdas restantes tendrán la misma altura.
     ////////////
     Esto NO permite agustar dinámicamente el tamaño de la celda de acuerdo al texto recibido desde web es por eso que se recomienda no cambiar el layout dinamicamente pues puede provocar errores en el diseño.
     */
    
    NSString *cellIdentifier = nil;
    
    switch (indexPath.section)
    {
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
     En este método se relizan 3 pasos:
     - Se incia por obtener el identificador especifico de cada celda. Almacenandolo en un NSString, esto se logra delegando la obtención del identificador al método cellIdentifierForIndexPath.
     - Después se genera un diccionarió para almacenar los distintos tamaños de cada celda. Esto es posible ya heightForRowAtIndexPath obtiene la altura desde la celda que existe en el storyboard.
     Por lo mismo la altura deseda para cada celda debe estár correctamente ajustada desde el storyboard y en el Size Inspector.
     - Se comprueba que el dicionario esté vacio para inicializarlo y alocar el mismo.
     - La variable cachedHeight es el número correspondiente a la altura según el identificador.
     - Una ves obtenida la altura respectiva a la celda se asigna a la celda creada y la cual se mostrará en la aplicación.
     
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
     //   RestInfoCell *cell = (RestInfoCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
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
            cellTwo.decideLabel.text = @"Decide";
        [cellTwo.contentView addSubview:cellTwo.exploraLabel];
        [cellTwo.contentView addSubview:cellTwo.calificaLabel];
        [cellTwo.contentView addSubview:cellTwo.shareLabel];
        
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
                UIButton *mapaButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];

        //set the position of the button
        menuButton.frame = CGRectMake(cellTwo.frame.origin.x + 26, cellTwo.frame.origin.y + 8, 38, 38);
                mapaButton.frame = CGRectMake(cellTwo.frame.origin.x + 95, cellTwo.frame.origin.y + 8, 38, 38);
                    rateButton.frame = CGRectMake(cellTwo.frame.origin.x + 171, cellTwo.frame.origin.y + 8, 38, 38);
                        shareButton.frame = CGRectMake(cellTwo.frame.origin.x + 247, cellTwo.frame.origin.y + 8, 38, 38);
        //Define Custom Image
        UIImage *menuImage =[UIImage imageNamed: @"boton_menu.png"];
                UIImage *menuOnImage =[UIImage imageNamed: @"boton_menu-on.png"];
        UIImage *mapImage =[UIImage imageNamed: @"boton_mapa.png"];
            UIImage *mapOnImage =[UIImage imageNamed: @"boton_mapa-on.png"];
        UIImage *rateImage =[UIImage imageNamed: @"boton_califica.png"];
            UIImage *rateOnImage =[UIImage imageNamed: @"boton_califica-on.png"];
        UIImage *shareImage =[UIImage imageNamed: @"boton_facebook.png"];
                UIImage *shareOnImage =[UIImage imageNamed: @"boton_facebook-on.png"];
        //set image for state
        [menuButton setImage:menuImage forState:UIControlStateNormal];
                [menuButton setImage:menuOnImage forState:UIControlStateSelected];
        [mapaButton setImage:mapImage forState:UIControlStateNormal];
            [mapaButton setImage:mapOnImage forState:UIControlStateSelected];
        [rateButton setImage:rateImage forState:UIControlStateNormal];
            [rateButton setImage:rateOnImage forState:UIControlStateSelected];
        [shareButton setImage:shareImage forState:UIControlStateNormal];
            [shareButton setImage:shareOnImage forState:UIControlStateSelected];
        
        [menuButton addTarget:self action:@selector(goToMenu:) forControlEvents:UIControlEventTouchUpInside];
        [mapaButton addTarget:self action:@selector(goToMap:) forControlEvents:UIControlEventTouchUpInside];
        [rateButton addTarget:self action:@selector(rateAction:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        menuButton.backgroundColor= [UIColor clearColor];
            mapaButton.backgroundColor= [UIColor clearColor];
                rateButton.backgroundColor= [UIColor clearColor];
                    shareButton.backgroundColor= [UIColor clearColor];
        
        [cellTwo.contentView addSubview:menuButton];
            [cellTwo.contentView addSubview:mapaButton];
                [cellTwo.contentView addSubview:rateButton];
                    [cellTwo.contentView addSubview:shareButton];
        
        return cellTwo;
    }if(indexPath.section ==2){
        
        static NSString* cellIdentifier2 =@"infoCell";
        infoTableViewCell *cellThree = (infoTableViewCell *)[restaurantTableView dequeueReusableCellWithIdentifier:cellIdentifier2 ];
        
        if (cellThree ==nil) {
            cellThree = [[infoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2];
        }
        //get logo
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
                cellThree.directionTextView.text =[restaurant objectForKey:@"Adress"] ;
                cellThree.phoneLabel.text =[restaurant objectForKey:@"Web"] ;
                restaurantPhone = [restaurant objectForKey:@"Phone"];
                
          
            }
        }];
        
        UITapGestureRecognizer *phoneLabelTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callRestaurant)];
        [cellThree.contentView addSubview:cellThree.phoneLabel];
            [cellThree.phoneLabel addGestureRecognizer:phoneLabelTouch];
        
         //[cellThree.contentView addSubview:cellThree.infoLogoImage];
        
        
        return cellThree;
    }
    return nil;
    
}

-(void)goToMenu :(id)sender
{

    NSLog(@"To Menu");
    menuViewController *menuInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
    menuInstance.dish = self.dish;
    
    [self presentViewController:menuInstance animated:YES completion:nil];

    
}
-(void)goToMap :(id)sender
{
    NSLog(@"To Map");
    LocationViewController *mapInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationView"];
    mapInstance.dish = self.dish;
    
    [self presentViewController:mapInstance animated:YES completion:nil];
}
-(void)rateAction :(id)sender
{
    NSLog(@"Rating!!");
}
-(void)shareAction :(id)sender
{
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
        //Si seteamos este podemos agregar la imagen del platillo al facebook del wey que lo va a compartir, esta chido creo.
        //Obtener image y agregarla
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
    

ViewController *homeinstance = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
     homeinstance.dish = [self.parseArray objectAtIndex: self.index];
    homeinstance.parseArray = self.parseArray;
    homeinstance.index = self.index;
    [self presentViewController:homeinstance animated:YES completion:nil];
    
    
}
-(void) callRestaurant{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:restaurantPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    NSLog(@"calling");
}

@end
