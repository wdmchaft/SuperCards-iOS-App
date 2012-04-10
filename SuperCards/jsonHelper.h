//
//  jsonHelper.h
//  SuperCards
//
//  Created by Sean Reichle on 4/2/11.
//  Copyright 2011 Adventesia LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBJsonParser;
@class SBJsonWriter;

@interface jsonHelper : NSObject {
    SBJsonParser * parser;
    SBJsonWriter * writer;
}

@end
