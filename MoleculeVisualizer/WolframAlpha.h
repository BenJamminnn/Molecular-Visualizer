//
//  WolframAlpha.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/22/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kQueryURL @"http://api.wolframalpha.com/v2/query?"
#define kValidateQueryURL @"￼http://api.wolframalpha.com/v2/validatequery?"


@interface WolframAlpha : NSObject 

@property(nonatomic, strong) NSString *appid;
@property(nonatomic, strong) NSMutableData *receivedData;
@property(nonatomic, strong) NSURLResponse *URLResponse;

- (void)doQueryWithInput:(NSString *)input parameters:(NSDictionary *)dict;

+ (NSDictionary *)parameterDictonaryFromKeys:(NSArray *)keys values:(NSArray *)vals;


@end
