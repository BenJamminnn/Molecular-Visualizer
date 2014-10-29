//
//  WolframAlphaHelper.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/27/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kQueryURL @"http://api.wolframalpha.com/v2/query?"
#define kAppID @"RVQ28W-KTEAXGTYGT"

@interface WolframAlphaHelper : NSObject <NSXMLParserDelegate>
@property (strong, nonatomic, readonly) NSMutableArray *images;


- (instancetype)initWithData:(NSData *)data;

- (NSDictionary *)elementsForMolecule;

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler;

@end
