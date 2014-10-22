//
//  ViewController.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SceneKit;
@class Molecule;

@interface ViewController : UIViewController
@property (strong, nonatomic) SCNNode *geometryNode;

- (instancetype)initWithMolecule:(SCNNode *)molecule;

@end

