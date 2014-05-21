//
//  LocationViewController.m
//  FoodStamp
//
//  Created by Red Prado on 4/3/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import "LocationViewController.h"
#import "ViewController.h"
#import "LocRestDescrCell.h"
#import "LocSocialCell.h"
#import "LocInfoCell.h"
#import "Parse/Parse.h"

#define METROS_POR_MILLA 1609.344

@interface LocationViewController ()

@end

@implementation LocationViewController
@synthesize minMapView;
@synthesize locationTableView, locationTableController;
@synthesize userLocationImage,restHeaderNameLabel,rateImageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //mostrar locación de usuario en el mapa solo funciona en dispositivos no simulador.
    minMapView.showsUserLocation = YES;
    
    userLocationImage.layer.cornerRadius= userLocationImage.frame.size.height/2;
    userLocationImage.layer.borderWidth=0; //hancho del borde.
    userLocationImage.clipsToBounds =YES;
    

    
}

- (void)viewWillAppear:(BOOL)animated {

    //Imagen de Usuario Redonda

    // 1 Fijar coordenadas estas deberán ser llamadas por un Query hacia parse recibidas, almacenadas en una variable Double y reemplazadas en latitutde y longitud.
    
    // coordenas de Tacos La choza    20.674266, -103.374803
    zoomLocation.latitude =  20.674266;
    zoomLocation.longitude= -103.374803;
    
    // 2 Fijar la distancia que se verá en el mápa (Zoom)
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METROS_POR_MILLA, 0.5*METROS_POR_MILLA);
    
    // 3 Ajusta region y animar zoom
    [minMapView setRegion:viewRegion animated:YES];
    
    // 4 Poner pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:zoomLocation];
    [annotation setTitle:@"RestaurantLocation"];
    [minMapView addAnnotation:annotation];
}
#pragma mark - MapView Methods
-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    
//    MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
//    CLLocationCoordinate2D myCoordinate;
//    myCoordinate.latitude=13.04016;
//    myCoordinate.longitude=80.243044;
//    MKCoordinateRegionMakeWithDistance(myCoordinate, 13.04016, 80.243044);
//    annotation.coordinate = myCoordinate;
//    [minMapView addAnnotation:annotation];
    
}


#pragma mark - Table view data source

# pragma TableViewMethods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
            cellIdentifier = @"locRestDescrCell";
            break;
        case 1:
            cellIdentifier = @"locSocialCell";
            break;
        case 2:
            cellIdentifier = @"locInfoCell";
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
    
    NSLog(@"indexPath: %ld",(long)indexPath.section);
    
    if (indexPath.section == 0 ){
        
        static NSString *cellIdentifier = @"locRestDescrCell";
        
        LocRestDescrCell *cell = [locationTableView dequeueReusableCellWithIdentifier: cellIdentifier];
        if(cell == nil){
            cell = [[LocRestDescrCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        [cell.contentView addSubview:cell.restDescrLabel];
        

        return cell;
        
    }else if (indexPath.section == 1){
        

        static NSString* cellIdentifier1 = @"locSocialCell";

        LocSocialCell *cellTwo = (LocSocialCell *)[locationTableView dequeueReusableCellWithIdentifier:cellIdentifier1];

        
        if (cellTwo == nil) {
            
            NSLog(@"entró a segundo nil");
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:nil options:nil];
            cellTwo  = (LocSocialCell*)[nib objectAtIndex:0];
            cellTwo = [[LocSocialCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
            
        }
        [cellTwo.contentView addSubview:cellTwo.descubreLabel];
        [cellTwo.contentView addSubview:cellTwo.exploraLabel];
        [cellTwo.contentView addSubview:cellTwo.rateLabel];
        [cellTwo.contentView addSubview:cellTwo.shareLabel];
            cellTwo.rateLabel.text =@"Decide";
            cellTwo.exploraLabel.text = @"Explora";
            cellTwo.descubreLabel.text = @"Descubre";
            cellTwo.shareLabel.text = @"Comparte";
        
        return cellTwo;
        
    }else if (indexPath.section == 2){

        static NSString* cellIdentifier2 = @"locInfoCell";

        LocInfoCell *cellThree = (LocInfoCell*) [tableView dequeueReusableCellWithIdentifier: cellIdentifier2];
        
        if (cellThree == nil) {
            NSLog(@"entrando a tercer nil");
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:nil options:nil];
            cellThree = (LocInfoCell*)[nib objectAtIndex:0];
            cellThree = [[LocInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2 ];
        }
        NSLog(@"cell 3 Rturned");
        [cellThree.contentView addSubview:cellThree.infoRestNameLabel];
        [cellThree.contentView addSubview:cellThree.infoDirecLabel];
        [cellThree.contentView addSubview:cellThree.infoHoraLabel];
        [cellThree.contentView addSubview:cellThree.infoPagoLabel];
        [cellThree.contentView addSubview:cellThree.infoTelLabel];
        [cellThree.contentView addSubview:cellThree.infoWebLabel];
        
        return cellThree;
    }
    return nil;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
    
    NSLog(@"ET phone Home ");
    ViewController *homeinstance = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    [self presentViewController:homeinstance animated:YES completion:nil];
    

}
@end
