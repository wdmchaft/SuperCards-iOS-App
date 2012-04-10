//
//  jsonHelper.m
//  SuperCards
//
//  Created by Sean Reichle on 4/2/11.
//  Copyright 2011 Adventesia LLC. All rights reserved.
//

#import "jsonHelper.h"
#import "json.h"

@implementation jsonHelper


- (void)setUp {
    parser = [SBJsonParser new];
    writer = [SBJsonWriter new];
}

- (void)tearDown {
    [parser release];
    [writer release];
}

@end
