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
#import "MiniMenuCell.h"
#import "ViewController.h"

@interface RestaurantViewController ()

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation RestaurantViewController

@synthesize restaurantTableView,restaurantTableController,scrollView,pageControl,pageImages,pageViews,miniMenuCollectionView, dish;


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
    NSLog(@"updating page control");
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSLog(@"Checando bounds");
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
        [self populateImages:restaurant];
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

#pragma mark - UICollectionView data source

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [imageFilesArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"miniMenuCell";
    MiniMenuCell *cell = (MiniMenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    
    
    PFFile *imageFile = [imageObject objectForKey:@"platilloImage"];
    NSString *restaurantName = [imageObject objectForKey:@"restaurantName"];
    NSString *platilloName = [imageObject objectForKey:@"platilloName" ];
    NSString *platilloPrice = [imageObject objectForKey:@"precio" ];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        if(!error){
            cell.miniParseImage.image = [UIImage imageWithData:data];
            cell.restNameLabel.text = restaurantName;
            cell.platilloNameLabel.text = platilloName;
            cell.priceLabel.text =  platilloPrice;
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

#pragma mark -  TableView Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Creating cells");
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
        //case 2:
          //  cellIdentifier = @"menuCell";
            //break;
    
            
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
    
    NSLog(@"indexPath: %ld",(long)indexPath.section);
    
    if (indexPath.section == 0 ){
        
        static NSString *cellIdentifier = @"descripcionRestCell";
        
     RestInfoCell *cell = [restaurantTableView dequeueReusableCellWithIdentifier: cellIdentifier];
     //   RestInfoCell *cell = (RestInfoCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        if(cell == nil){
            cell = [[RestInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }

        [cell.contentView addSubview:cell.restInfoLabel];
        NSLog(@"setting kekas Text");
        cell.restInfoLabel.text = @"Restarant Bien bonito, con forma de chozita de tacos. Tambien venden quesadillas gourmet, tacos gourmet, agua fresca , refresco no está en una esquina, pero si sobre una calle";

        return cell;
        
    }else if (indexPath.section == 1){
        
        static NSString* cellIdentifier1 = @"userInteractionCell";

        UserInteractionCell *cellTwo = (UserInteractionCell *)[restaurantTableView dequeueReusableCellWithIdentifier:cellIdentifier1];

        
        if (cellTwo == nil) {
            
            NSLog(@"entró a segundo nil");
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:nil options:nil];
            cellTwo  = (UserInteractionCell*)[nib objectAtIndex:0];
            cellTwo = [[UserInteractionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
            
        }
        
        [cellTwo.contentView addSubview:cellTwo.decideLabel];
            cellTwo.decideLabel.text = @"Decide";
        [cellTwo.contentView addSubview:cellTwo.exploraLabel];
        [cellTwo.contentView addSubview:cellTwo.calificaLabel];
        [cellTwo.contentView addSubview:cellTwo.shareLabel];
        
        return cellTwo;
        }
        return nil;
    
}


//- (void)reloadData{
//    
//}



- (IBAction)backButton:(id)sender {
    
    NSLog(@"ET phone Home ");
    ViewController *homeinstance = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    [self presentViewController:homeinstance animated:YES completion:nil];
    
    
}
@end
