//
//  CardCell.m
//  SuperCards
//
//  Created by Sean Reichle on 12/12/11.
//  Copyright (c) 2011 Adventesia LLC. All rights reserved.
//

#import "CardCell.h"

@implementation CardCell
@synthesize thumbNail, cardTitle, purchasePrice;


/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
*/


/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/

- (void)dealloc
{
    [thumbNail release];
    [cardTitle release];
    [purchasePrice release];
    [super dealloc];
}
@end
