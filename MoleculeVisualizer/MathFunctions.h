//
//  MathFunctions.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/13/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SceneKit;

@interface MathFunctions : NSObject

+ (CGFloat)angleBetween:(SCNVector3)vectorA and:(SCNVector3)vectorB;

+ (CGFloat)distanceFormulaWithVectors:(SCNVector3)vectorA and:(SCNVector3)vectorB;

+ (SCNVector3)connectorPositionWithVector:(SCNVector3)vectorA and:(SCNVector3)vectorB;


@end
