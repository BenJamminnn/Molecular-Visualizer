//
//  WolframAlpha.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/22/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "WolframAlpha.h"

@implementation WolframAlpha

#pragma mark - lifecycle

- (instancetype)init {
    if(self = [super init]) {
        _appid = @"RVQ28W-KTEAXGTYG";
    }
    return self;
}

#pragma mark - class methods

+ (NSDictionary *)parameterDictonaryFromKeys:(NSArray *)keys
                                      values:(NSArray *)vals {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    for (int i = 0; i < [keys count]; i++){
        if (![dict objectForKey:[keys objectAtIndex:i]]){
            [dict setObject:[vals objectAtIndex:i] forKey:[keys objectAtIndex:i]];
        }
        else{
            if ([[dict objectForKey:[keys objectAtIndex:i]] isKindOfClass:[NSMutableArray class]]){
                [[dict objectForKey:[keys objectAtIndex:i]] addObject:[vals objectAtIndex:i]];
            }
            else{
                NSString *s = [[NSString alloc] initWithString:[dict objectForKey:[keys objectAtIndex:i]]];
                [dict removeObjectForKey:[keys objectAtIndex:i]];
                NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:s,[vals objectAtIndex:i], nil];
                [dict setObject:arr forKey:[keys objectAtIndex:i]];
            }
        }
    }
    return dict;
}

#pragma mark - Querying

- (void)doQueryWithInput:(NSString *)input parameters:(NSDictionary *)dict
{
    if ((input == nil) || ([input length] <= 0)){
        return;
    }
    NSMutableString *queryString = [[NSMutableString alloc] initWithFormat:@"%@appid=%@&input=%@",kQueryURL,_appid,input];
    if ((dict != nil) && ([dict count] > 0)){
        NSArray *keys = [dict allKeys];
        for (int i = 0; i < [keys count]; i++) {
            if (![[dict objectForKey:[keys objectAtIndex:i]] isKindOfClass:[NSMutableArray class]]) {
                [queryString appendFormat:@"&%@=%@",[keys objectAtIndex:i],[dict objectForKey:[keys objectAtIndex:i]]];
            }
            else{
                for (int j = 0; j < [[dict objectForKey:[keys objectAtIndex:i]] count]; j++) {
                    [queryString appendFormat:@"&%@=%@",[keys objectAtIndex:i],[[dict objectForKey:[keys objectAtIndex:i]] objectAtIndex:j]];
                }
            }
        }
    }
    
    NSURL *url = [[NSURL alloc] initWithString:[queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",[url absoluteString]);
    
    [self doGetRequest:url];

}

#pragma mark - requesting

- (void)doPostRequest:(NSURL *)url withBodyData:(NSData *)bodyData {
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:bodyData];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (con){
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
    }

}

- (void)doGetRequest:(NSURL *)url {
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (con){
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
    }
}

#pragma mark - URL Connection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_receivedData setLength:0];
    self.URLResponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *dataString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",dataString);
    
    self.receivedData = nil;
    self.URLResponse = nil;
}


@end
