//
//  PlatilloTableViewController.m
//  FoodStamp
//
//  Created by Red Prado on 3/30/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import "PlatilloTableViewController.h"
#import "PlatilloViewController.h"
#import "FotoPlatilloCell.h"
#import "DescripcionRestTableViewCell.h"
#import "SocialCell.h"

@interface PlatilloTableViewController ()

@end

@implementation PlatilloTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSLog(@"Creating cells");
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 ){
        
        static NSString *cellIdentifier = @"fotoPlatilloCell";
        
        FotoPlatilloCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
        if(cell == nil){
            cell = [[FotoPlatilloCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }       NSLog(@"platillo image returner");
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
        NSLog(@"define cell origin");
        DescripcionRestTableViewCell *cellTwo = (DescripcionRestTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        NSLog(@"creating 2nd cell NIB");
        
        if (cellTwo == nil) {
            
            NSLog(@"entradno a segundo nil");
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:nil options:nil];
            cellTwo  = (DescripcionRestTableViewCell*)[nib objectAtIndex:0];
            cellTwo = [[DescripcionRestTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
            
        }
        
        [cellTwo.contentView addSubview:cellTwo.descripcionTextView];
        cellTwo.descripcionTextView.text = @"Combinación de ";
        
        return cellTwo;
        
    }else if (indexPath.section == 2){
        NSLog(@"Crating 3rd label");
        static NSString* cellIdentifier2 = @"socialIconsCell";
        SocialCell *cellThree = (SocialCell*) [tableView dequeueReusableCellWithIdentifier: cellIdentifier2];
        
        if (cellThree == nil) {
            NSLog(@"entrando a tercer nil");
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:nil options:nil];
            cellThree = (SocialCell*)[nib objectAtIndex:0];
            cellThree = [[SocialCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2 ];
        }
        [cellThree.contentView addSubview:cellThree.wishLabel];
        [cellThree.contentView addSubview:cellThree.shareLabel];
        [cellThree.contentView addSubview:cellThree.likeLabel];
        
        
        return cellThree;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* In this example, there is a different cell for
     the top, middle and bottom rows of the tableView.
     Each type of cell has a different height.
     self.model contains the data for the tableview
     */
    static NSString *CellIdentifier;
    if (indexPath.row == 0)
        CellIdentifier = @"fotoPlatilloCell";
    else if (indexPath.row == 1)
        CellIdentifier = @"descripcionRestCell";
    else
        CellIdentifier = @"socialIconsCell";
    
    UITableViewCell *cell =
    [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell.bounds.size.height;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
