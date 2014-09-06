//
//  MiniMenuContainerCell.m
//  FoodStamp
//
//  Created by Tracer on 6/5/14.
//  Copyright (c) 2014 Red Prado. All rights reserved.
//

#import "MiniMenuContainerCell.h"

@implementation MiniMenuContainerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        // Initialization code
        
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.collectionView.frame=self.contentView.bounds;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
