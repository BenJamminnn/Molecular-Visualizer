//
//  Molecule.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SceneKit;

@interface MoleculeImage : NSObject

@property (nonatomic, readonly, strong) NSArray *allMolecules;

+ (SCNNode *)moleculeForName:(NSString *)name;

@end