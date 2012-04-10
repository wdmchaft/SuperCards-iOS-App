//
//  Cards.h
//  SuperCards
//
//  Created by Sean Reichle on 5/9/11.
//  Copyright (c) 2011 Adventesia LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Cards : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * CardID;
@property (nonatomic, retain) NSString * CardImage;
@property (nonatomic, retain) NSString * Thumb;
@property (nonatomic, retain) NSString * Price;
@property (nonatomic, retain) NSString * CategoryID;
@property (nonatomic, retain) NSString * Nib;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * CardTitle;
@property (nonatomic, retain) Category * Category;

@end
