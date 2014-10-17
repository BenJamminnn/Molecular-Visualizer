//
//  Atom.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SceneKit;

@interface Atom : NSObject

+ (SCNGeometry *)carbonAtom;
+ (SCNGeometry *)fluorineAtom;
+ (SCNGeometry *)oxygenAtom;
+ (SCNGeometry *)hydrogenAtom;
+ (SCNGeometry *)nitrogenAtom;
+ (SCNGeometry *)chlorineAtom;

@end
