//
//  MoleculeData.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 11/4/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Molecule : NSObject

+ (NSDictionary *)dataForMoleculeName:(NSString *)name;

@end
