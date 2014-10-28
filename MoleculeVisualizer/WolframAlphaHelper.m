//
//  WolframAlphaHelper.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/27/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "WolframAlphaHelper.h"

/*
HOW TO PARSE XML
 -> call downloadDataFromURL:withCompletionHandler: to get a reference to the data we're getting back
    >>within the block
    -> utilize an instance of NSXMLParser {
        xmlParser initWithData:data     ---data from calling downloadDataFromURL:
        initialize any other properties to hold temp data
        [xmlParser parse] -- to begin
       }
 
 
  
*/


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

#pragma mark - making requests

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler {
    //init a session config object
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //init a session object
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    //create a data task object to perform the downloading
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            //if an error occurred, log it
            NSLog(@"%@" , [error localizedDescription]);
        } else {
            //no error occurred, check the HTTP status code
            NSInteger httpStatusCode = [(NSHTTPURLResponse *)response statusCode];
            //if its other than 200, log it
            if(httpStatusCode != 200) {
                NSLog(@"Http status code: %li" , (long)httpStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
        
    }];
    //makes the task start working for us
    [task resume];
}


@end
