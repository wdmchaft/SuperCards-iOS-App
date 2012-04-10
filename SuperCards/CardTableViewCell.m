//
//  CardTableViewCell.m
//  SuperCards
//
//  Created by Sean Reichle on 12/12/11.
//  Copyright (c) 2011 Adventesia LLC. All rights reserved.
//

#import "CardTableViewCell.h"

@implementation CardTableViewCell 

- (void) setTitle:(NSString *)newTitle{
    [super setCardTitle:newTitle];
    cardTitleLabel.text = newTitle;
}

- (void) setThumbNail:(UIImage *)newThumbNail
{
    [super setThumbNail:newThumbNail];
    thumbNailView.image = newThumbNail;
}

- (void) setPurchase:(NSString *)newPurchasePrice
{
    [super setPurchasePrice:newPurchasePrice];
    purchasePriceButton.titleLabel.text = newPurchasePrice;
    if(newPurchasePrice.length==0){
        purchasePriceButton.enabled=false;
    }
}

- (void)dealloc
{
    [cardTitle release];
    [thumbNail release];
    [purchasePriceButton release];
    [super dealloc];
}

@end
