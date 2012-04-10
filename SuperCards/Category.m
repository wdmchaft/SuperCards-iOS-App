//
//  Category.m
//  SuperCards
//
//  Created by Sean Reichle on 5/9/11.
//  Copyright (c) 2011 Adventesia LLC. All rights reserved.
//

#import "Category.h"
#import "Cards.h"


@implementation Category
@dynamic CategoryID;
@dynamic Name;
@dynamic Cards;

- (void)addCardsObject:(Cards *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Cards" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Cards"] addObject:value];
    [self didChangeValueForKey:@"Cards" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeCardsObject:(Cards *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Cards" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Cards"] removeObject:value];
    [self didChangeValueForKey:@"Cards" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addCards:(NSSet *)value {    
    [self willChangeValueForKey:@"Cards" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Cards"] unionSet:value];
    [self didChangeValueForKey:@"Cards" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeCards:(NSSet *)value {
    [self willChangeValueForKey:@"Cards" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Cards"] minusSet:value];
    [self didChangeValueForKey:@"Cards" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
