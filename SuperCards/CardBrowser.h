//
//  CardBrowser.h
//  my eCards
//
//  Created by Sean Reichle on 3/18/11.
//  Copyright 2011 Adventesia LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "Cards.h"
#import "CardCell.h"

@interface CardBrowser : UITableViewController <NSFetchedResultsControllerDelegate> 
{
    NSArray *CardsData;
    NSArray  *CategoryData;
    
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
    
    CardCell *tmpCell;
}

@property (retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) NSArray *CardsData;
@property (nonatomic, retain) NSArray *CategoryData;
@property (nonatomic, assign) IBOutlet CardCell *tmpCell;

-(id)initWithManagedObject:(NSManagedObjectContext *)context;
-(void)GetJsonFromServer;
-(int)getCardCountFromDB;
-(int)getCardCountFromServer;
-(int)getCategoryCountFromServer;

-(void) removeCards;
-(void) removeCategories;
-(Category *)getCategoryByID:(NSInteger *)CategoryID;

-(NSArray*) LoadCards;
-(NSArray*) LoadCategories;

@end
