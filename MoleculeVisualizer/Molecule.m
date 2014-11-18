//
//  MoleculeData.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 11/4/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "Molecule.h"

/*
This class will output a dictionary of information based on the chemical input
*/

@implementation Molecule

+ (NSDictionary *)dataForMoleculeName:(NSString *)name {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *moleculeData = [[NSDictionary alloc]initWithContentsOfFile:path];
    if(!moleculeData) {
        NSLog(@"molecule file does not exist!");
        return nil;
    }
    return moleculeData;
}

@end
