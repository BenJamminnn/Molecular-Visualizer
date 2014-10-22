//
//  DetailsViewController.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/22/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Molecule;

@interface DetailsViewController : UIViewController

- (instancetype)initWithMolecule:(NSString *)molecule;

@end
