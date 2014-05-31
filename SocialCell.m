//
//  SocialCell.m
//  FoodStamp
//
//  Created by Red Prado on 3/30/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import "SocialCell.h"

@implementation SocialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)wishActionButton:(id)sender {
    NSLog(@"wish pressed");
}

- (IBAction)likeActionButton:(id)sender {
        NSLog(@"like pressed");
}

- (IBAction)facebookActionButton:(id)sender {
        NSLog(@"facebook pressed");
}

@end
