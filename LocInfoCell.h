//
//  LocInfoCell.h
//  FoodStamp
//
//  Created by Red Prado on 4/3/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *restLogoImageView;
@property (strong, nonatomic) IBOutlet UILabel *infoRestNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoDirecLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoHoraLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoPagoLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoTelLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoWebLabel;

@end
