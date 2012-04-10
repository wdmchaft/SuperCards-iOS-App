//
//  CardTableViewCell.h
//  SuperCards
//
//  Created by Sean Reichle on 12/12/11.
//  Copyright (c) 2011 Adventesia LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardCell.h"

@interface CardTableViewCell : CardCell{

    IBOutlet UIImageView *thumbNailView;
    IBOutlet UILabel *cardTitleLabel;
    IBOutlet UIButton *purchasePriceButton;
}

@end
