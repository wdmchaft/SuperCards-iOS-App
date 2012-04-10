//
//  CardCell.h
//  SuperCards
//
//  Created by Sean Reichle on 12/12/11.
//  Copyright (c) 2011 Adventesia LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CardCell : UITableViewCell
{
    UIImage *thumbNail;
    NSString *cardTitle;
    NSString *purchasePrice;
    
}

@property(retain) UIImage *thumbNail;
@property(retain) NSString *cardTitle;
@property(retain) NSString *purchasePrice;
@end