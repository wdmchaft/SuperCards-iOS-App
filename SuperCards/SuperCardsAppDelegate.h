//
//  SuperCardsAppDelegate.h
//  SuperCards
//
//  Created by Sean Reichle on 3/21/11.
//  Copyright 2011 Adventesia LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardBrowser.h"
#import "json.h"
#import "Cards.h"

@interface SuperCardsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CardBrowser *cbtvc;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CardBrowser *cbtvc;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)loadDbase; 
- (NSURL *)applicationDocumentsDirectory;
- (void)resetPersistantStore;

@end
