//
//  WolframAlphaHelper.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/27/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif


#import "WolframAlphaHelper.h"
@import UIKit;
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

@interface WolframAlphaHelper()
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic, readwrite) NSMutableArray *images;
@property (strong, nonatomic) NSMutableDictionary *elements;
@end
@implementation WolframAlphaHelper 



#pragma mark - lifecycle

- (instancetype)initWithData:(NSData *)data {
    if(self = [super init]) {
        self.parser = [[NSXMLParser alloc]initWithData:data];
        self.parser.delegate = self;
        [self.parser parse];
        
    }
    return self;
}

- (NSDictionary *)elementsForMolecule {
    return self.elements;
}

- (void)setUpElementsDict {
    NSMutableArray *images = [NSMutableArray new];
    NSDictionary *tempDict = @{
                               //basic properties
                               @"images" : images ,
                               @"Formula" : @"" ,
                               @"Molar Mass" : @"" ,
                               @"Phase" : @"" ,
                               @"Melting Point" : @"" ,
                               @"Boiling Point" : @"" ,
                               @"Density" : @"" ,
                               
                               //gas properties at STP
                               @"Molar Volume" : @"" ,
                               @"Vapor Density" : @"" ,
                               
                               //thermodynamic properties
                               @"Specific Heat Capacity" : @"" ,
                               @"Molar Heat Capacity" : @"" ,
                               @"Specific Free Energy of Formation" : @"" ,
                               @"Molar Free Energy of Formation" : @""  ,
                               @"Specific Heat of Formation" : @"",
                               @"Molar Heat of Formation" : @"" ,
                               @"Specific Entropy" : @"" ,
                               @"Molar Entropy" : @"" ,
                               @"Critical Temperature" : @"",
                               @"Critical Pressure" : @""
                               };
    self.elements = [NSMutableDictionary dictionaryWithDictionary:tempDict];
}

#pragma mark - convieniece

- (UIImage *)imageFromURLString:(NSString *)url {
    NSURL *imageURL = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:imageData];
}

- (NSMutableArray *)images {
    if(!_images) {
        _images = [NSMutableArray new];
    }
    return _images;
}

- (void)performActionWithElement:(NSString *)element attributes:(NSDictionary *)attributes {
    if([element isEqualToString:@"plaintext"]) {
        NSLog(@"%@" , attributes);
    } else if([element isEqualToString:@"img"]) {
        NSString *imageURLString = [attributes valueForKey:@"src"];
        UIImage *image = [self imageFromURLString:imageURLString];
        [self.images addObject:image];
        
    } else if([element isEqualToString:@"source"]) {
        return;
    } else if([element isEqualToString:@"pod"]) {
        
    }
}

#pragma mark - XML Parser Delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    //here is where parsing begins, we will initialize some data structure to hold all the necessary data
    NSLog(@"Parsing begins");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //here is where parsing ends, we'll send the info back to the caller
    NSLog(@"Parsing Ends");
    [self.elements setValue:_images forKey:@"images"];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //an error occurred, lets raise an exception if this happens
    NSLog(@"%@" , [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //here we get the info

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSLog(@"Element Name: %@" , elementName);
    
    [self performActionWithElement:elementName attributes:attributeDict];
  
    if(attributeDict.allKeys.count != 0) {
        NSLog(@"Attributes: %@" ,attributeDict );

    }
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
