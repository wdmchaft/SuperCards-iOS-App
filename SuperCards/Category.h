//
//  Category.h
//  SuperCards
//
//  Created by Sean Reichle on 5/9/11.
//  Copyright (c) 2011 Adventesia LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cards;

@interface Category : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * CategoryID;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSSet* Cards;

@end
