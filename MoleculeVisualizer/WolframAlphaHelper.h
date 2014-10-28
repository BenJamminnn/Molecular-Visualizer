//
//  WolframAlphaHelper.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/27/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kQuery @"http://api.wolframalpha.com/v2/query?input="
#define kQueryEnd @"&appid=RVQ28W-KTEAXGTYG"

@interface WolframAlphaHelper : NSObject <NSXMLParserDelegate>


- (instancetype)initWithQuery:(NSString *)query;

@end
