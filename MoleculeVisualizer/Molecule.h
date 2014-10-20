//
//  Molecule.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SceneKit;

@interface Molecule : NSObject

- (SCNNode *)methaneMolecule;

- (SCNNode *)ptfeMolecule;

- (SCNNode *)ammoniaMolecule;

- (SCNNode *)waterMolecule;

- (SCNNode *)hydrogenPeroxideMolecule;

- (SCNNode *)hydrogenChlorideMolecule;

- (SCNNode *)sulfuricAcidMolecule;

- (SCNNode *)nitricAcidMolecule;

- (SCNNode *)aceticAcidMolecule;

- (SCNNode *)sulfurDioxideMolecule;

- (SCNNode *)sulfurTrioxideMolecule;
@end
