//
//  WolframAlphaHelper.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/27/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "WolframAlphaHelper.h"

static NSXMLParser *parser = nil;

@implementation WolframAlphaHelper 

#pragma mark - lifecycle

- (instancetype)initWithQuery:(NSString *)query {
    if(self = [super init]) {
        NSString *removedSpaces = [self replaceSpaces:query];
        NSString *fullQuery = kQuery;
        [fullQuery stringByAppendingString:removedSpaces];
        [fullQuery stringByAppendingString:kQueryEnd];
        NSURL *url = [NSURL URLWithString:fullQuery];
        parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
        parser.delegate = self;
    }
    return self;
}

#pragma mark - convieniece

- (NSString *)replaceSpaces:(NSString *)string {
    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - XML Parser Delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    //here is where parsing begins, we will initialize some data structure to hold all the necessary data
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //here is where parsing ends, we'll send the info back to the caller
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //an error occurred, lets raise an exception if this happens
    [[NSException exceptionWithName:@"Error parsing" reason:@"" userInfo:0]raise];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //here we get the info
}
@end
