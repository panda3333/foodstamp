//
//  PlatilloViewController.m
//  FoodStamp
//
//  Created by Red Prado on 3/28/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import "PlatilloViewController.h"
#import "FotoPlatilloCell.h"
#import "DescripcionRestTableViewCell.h"
#import "SocialCell.h"
#import "DirecCell.h"
#import "ViewController.h"
#import "Parse/Parse.h"



@interface PlatilloViewController ()

@end

@implementation PlatilloViewController

@synthesize platilloTableView,platilloTableController,userIconImage,restaurantNameLabel;


- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     Hacer avatar Redondo: Tomar en cuenta que iOS7 importa de manera automatica <QuartzCore/QuartzCore.h>
     Para hacer este código funcional en versiones anteriores hay que importar este framework.
     */
    userIconImage.layer.cornerRadius= userIconImage.frame.size.height/2;
    userIconImage.layer.borderWidth=0; //hancho del borde.
    userIconImage.clipsToBounds =YES;
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
//    
    NSLog(@"View Did LOAD");
}



# pragma TableViewMethods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
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
        
        static NSString *cellIdentifier = @"fotoPlatilloCell";
        
        FotoPlatilloCell *cell = [platilloTableView dequeueReusableCellWithIdentifier: cellIdentifier];
        if(cell == nil){
            cell = [[FotoPlatilloCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        [cell.contentView addSubview:cell.platilloImage];
        [cell.contentView addSubview:cell.subDataView];
        [cell.subDataView addSubview:cell.priceLabel];
        [cell.subDataView addSubview:cell.mapIconImage];
        NSLog(@"distance returned");
        [cell.subDataView addSubview:cell.distanceLabel];
        NSLog(@"cell returned");
        return cell;
        
    }else if (indexPath.section == 1){
        
        NSLog(@"creating second custom cell");
        static NSString* cellIdentifier1 = @"descripcionRestCell";
        NSLog(@"define cell 2 origin");
        DescripcionRestTableViewCell *cellTwo = (DescripcionRestTableViewCell*)[platilloTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        NSLog(@"creating 2nd cell NIB");
        
        if (cellTwo == nil) {
            
            NSLog(@"entró a segundo nil");
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:nil options:nil];
            //cellTwo  = (DescripcionRestTableViewCell*)[nib objectAtIndex:0];
            cellTwo = [[DescripcionRestTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
            
        }
        
        [cellTwo.contentView addSubview:cellTwo.descripcionTextView];
        cellTwo.descripcionTextView.text = @"Combinación de ";
        
        return cellTwo;
        
    }else if (indexPath.section == 2){
        NSLog(@"creating third custom cell");
        static NSString* cellIdentifier2 = @"socialIconsCell";
        NSLog(@"deque'ing cellidentifier2");
        SocialCell *cellThree = (SocialCell*) [tableView dequeueReusableCellWithIdentifier: cellIdentifier2];
        
        if (cellThree == nil) {
            NSLog(@"entrando a tercer nil");
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:nil options:nil];
            //cellThree = (SocialCell*)[nib objectAtIndex:0];
            cellThree = [[SocialCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2 ];
        }
        NSLog(@"cell 3 Rturned");
        [cellThree.contentView addSubview:cellThree.wishLabel];
        [cellThree.contentView addSubview:cellThree.shareLabel];
        [cellThree.contentView addSubview:cellThree.likeLabel];
        
        
        return cellThree;
        

    }else if (indexPath.section == 3){
                    NSLog(@"creating fourth custom cell");
            static NSString* cellIdentifier3 = @"descripcionCell";
            NSLog(@"pasó 3rt NIL");
            DirecCell *cellFour = (DirecCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        
            if (cellFour == nil) {

                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier3 owner:nil options:nil];
                
                //cellFour = (DirecCell*)[nib objectAtIndex:0];
                cellFour = [[DirecCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier3 ];

        }
            
        [cellFour.contentView addSubview:cellFour.restaurantNameLabel];
        [cellFour.contentView addSubview:cellFour.horarioLabel];
        [cellFour.contentView addSubview:cellFour.pagoLabel];
        [cellFour.contentView addSubview:cellFour.telLabel];
        
        [cellFour.contentView addSubview:cellFour.direcIconImage];
        [cellFour.contentView addSubview:cellFour.horaIconImage];
        [cellFour.contentView addSubview:cellFour.pagoIconImage];
        [cellFour.contentView addSubview:cellFour.telIconImage];
        
        [cellFour.contentView addSubview:cellFour.logoImage];
        
        [cellFour.contentView addSubview:cellFour.directionTextView];
          cellFour.directionTextView.text = @"Miguel Cervantes de Saavedra #81, Lafayette. Guadalajara, Jalisco ";
        
        return cellFour;
    }
    return nil;
    
}


- (void)reloadData{
    
}

- (IBAction)backActionButton:(id)sender {
    NSLog(@"ET phone Home ");
    ViewController *homeinstance = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    [self presentViewController:homeinstance animated:YES completion:nil];
    

}
@end
