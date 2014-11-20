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

@property (nonatomic, readonly, strong) NSArray *otherMolecules;
@property (nonatomic, readonly, strong) NSArray *diatomicMolecules;
@property (nonatomic, readonly, strong) NSArray *acidMolecules;
@property (nonatomic, readonly, strong) NSArray *hydrocarbonMolecules;


+ (SCNNode *)moleculeForName:(NSString *)name;

@end
