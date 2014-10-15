//
//  Molecule.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "Molecule.h"
#import "Atom.h"
#import "MathFunctions.h"

@implementation Molecule

- (SCNNode *)connectorWithPositions:(SCNVector3)positionA and:(SCNVector3)positionB command:(NSString *)command {
    SCNNode *node = [SCNNode node];
    
    //first compute the distance. i.e height
    CGFloat distance = [MathFunctions distanceFormulaWithVectors:positionA and:positionB];
    
    SCNGeometry *cylinder = [SCNCylinder cylinderWithRadius:0.15 height:distance];
    cylinder.firstMaterial.diffuse.contents = [UIColor blackColor];
    cylinder.firstMaterial.specular.contents = [UIColor whiteColor];
    node.geometry = cylinder;
    
    
    //we set the position of the connector half way between the two points
    node.position = [MathFunctions connectorPositionWithVector:positionA and:positionB];
    
    //now we set the angle of the cylinder
    //CYLINDER APPROACH ===== find the angle the hard way
    
    node.pivot = [self rotationWithCommand:command];
    node.name = @"connector";
    
    return node;
}

- (SCNMatrix4)rotationWithCommand:(NSString *)command {
    SCNMatrix4 rotation = SCNMatrix4MakeRotation(M_PI_2, 0, 0, 0);
    if([command isEqualToString:@"90xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI_2, 0, 1, 0);
    } else if([command isEqualToString:@"0xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI_2, 0, 0, 1);
    } else if([command isEqualToString:@"45xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, 2.5, 0);
    } else if([command isEqualToString:@"135xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -2.5, 0);
    } else if([command isEqualToString:@"45yz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 0, -2.5, 1);
    } else if([command isEqualToString:@"45xyz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -2.5, -0.5);
    } else if([command isEqualToString:@"135xyz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, -1, -2.5, -0.5);
    } else if([command isEqualToString:@"135yz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 0, -2.5, -1);
    } else if([command isEqualToString:@"-45xyz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -2.5, 0.5);
    } else if([command isEqualToString:@"45-xyz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, -1, -2.5, 0.5);
    }
    
    return rotation;
}

- (SCNNode *)methaneMolecule {
    SCNNode *methane = [SCNNode node];
    methane.name = @"Methane";
    SCNVector3 carbonPosition = SCNVector3Make(0, 0, 0);
    
    SCNVector3 hydrogenOnePosition = SCNVector3Make(0, -4, 4);
    SCNVector3 hydrogenTwoPosition = SCNVector3Make(+4, -2, -1);
    SCNVector3 hydrogenThreePosition = SCNVector3Make(-4, -2, -1);
    SCNVector3 hydrogenFourPosition = SCNVector3Make(0, +4, 0);
    
    [self nodeWithAtom:[Atom carbonAtom] molecule:methane position:carbonPosition];
    
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:methane position:hydrogenOnePosition];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:methane position:SCNVector3Make(hydrogenTwoPosition.x, hydrogenTwoPosition.y - 1, hydrogenTwoPosition.z - 0.5)];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:methane position:SCNVector3Make(hydrogenThreePosition.x, hydrogenThreePosition.y -1, hydrogenThreePosition.z - 0.5)];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:methane position:hydrogenFourPosition];
    
    //adding connectors
    
    [methane addChildNode:[self connectorWithPositions:carbonPosition and:hydrogenOnePosition command:@"45yz"]];
    [methane addChildNode:[self connectorWithPositions:carbonPosition and:hydrogenTwoPosition command:@"45xyz"]];
    [methane addChildNode:[self connectorWithPositions:carbonPosition and:hydrogenThreePosition command:@"135xyz"]];
    [methane addChildNode:[self connectorWithPositions:carbonPosition and:hydrogenFourPosition command:@"90xy"]];
    
    return methane;
}

- (SCNNode *)ptfeMolecule {
    SCNNode *ptfe = [SCNNode node];
    SCNVector3 carbonLeft = SCNVector3Make(-4, 0, 0);
    SCNVector3 carbonRight = SCNVector3Make(+4, 0, 0);
    SCNVector3 carbonDoubleBondLeft = SCNVector3Make(+4, +0.3, 0);
    SCNVector3 carbonDoubleBondRight = SCNVector3Make(-4, +0.3, 0);
    SCNVector3 carbonDoubleBondLeftSecond = SCNVector3Make(+4, -0.3, 0);
    SCNVector3 carbonDoubleBondRightSecond = SCNVector3Make(-4, -0.3, 0);


    
    SCNVector3 fluorineTopLeft = SCNVector3Make(-10, +6, 0);
    SCNVector3 fluorineTopRight = SCNVector3Make(+10, +6, 0);
    SCNVector3 fluorineBottomLeft = SCNVector3Make(-10, -6, 0);
    SCNVector3 fluorineBottomRight = SCNVector3Make(+10, -6, 0);
    
    //connecting the carbons
    [self nodeWithAtom:[Atom carbonAtom] molecule:ptfe position:carbonLeft];
    [self nodeWithAtom:[Atom carbonAtom] molecule:ptfe position:carbonRight];
    [ptfe addChildNode:[self connectorWithPositions:carbonDoubleBondRight and:carbonDoubleBondLeft command:@"0xy"]];
    [ptfe addChildNode:[self connectorWithPositions:carbonDoubleBondRightSecond and:carbonDoubleBondLeftSecond command:@"0xy"]];

    //left fluorines
    [self nodeWithAtom:[Atom fluorineAtom] molecule:ptfe position:fluorineTopLeft];
    [self nodeWithAtom:[Atom fluorineAtom] molecule:ptfe position:fluorineBottomLeft];
    [ptfe addChildNode:[self connectorWithPositions:carbonLeft and:fluorineTopLeft command:@"135xy"]];
    [ptfe addChildNode:[self connectorWithPositions:carbonLeft and:fluorineBottomLeft command:@"45xy"]];

    
    //right fluorines
    [self nodeWithAtom:[Atom fluorineAtom] molecule: ptfe position:fluorineTopRight];
    [self nodeWithAtom:[Atom fluorineAtom] molecule: ptfe position:fluorineBottomRight];
    [ptfe addChildNode:[self connectorWithPositions:carbonRight and:fluorineTopRight command:@"45xy"]];
    [ptfe addChildNode:[self connectorWithPositions:carbonRight and:fluorineBottomRight command:@"135xy"]];
    ptfe.name = @"Polytetraflueroethalyne\n(teflon)";
    
    return ptfe;
}

- (SCNNode *)ammoniaMolecule {
    SCNNode *ammonia = [SCNNode node];
    SCNVector3 nitrogenPosition = SCNVector3Make(0, 0, 0);
    
    SCNVector3 hydroOne = SCNVector3Make(0, -4, -3);
    SCNVector3 hydroTwo = SCNVector3Make(+4, -3, +2);
    SCNVector3 hydroThree = SCNVector3Make(-4, -3, +2);

    [self nodeWithAtom:[Atom nitrogenAtom] molecule:ammonia position:nitrogenPosition];
    [ammonia addChildNode:[self connectorWithPositions:nitrogenPosition and:hydroOne command:@"135yz"]];
    [ammonia addChildNode:[self connectorWithPositions:nitrogenPosition and:hydroTwo command:@"-45xyz"]];
    [ammonia addChildNode:[self connectorWithPositions:nitrogenPosition and:hydroThree command:@"45-xyz"]];

    
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:ammonia position:hydroOne];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:ammonia position:hydroTwo];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:ammonia position:hydroThree];
    
    ammonia.name = @"Ammonia";
    return ammonia;
}

- (SCNNode *)waterMolecule {
    SCNNode *water = [SCNNode node];
    SCNVector3 oxygenPosition = SCNVector3Make(0, 0, 0);
    SCNVector3 hydroOne = SCNVector3Make(3, 3, 0);
    SCNVector3 hydroTwo = SCNVector3Make(-3, 3, 0);
    
    [self nodeWithAtom:[Atom oxygenAtom] molecule:water position:oxygenPosition];
    [water addChildNode:[self connectorWithPositions:oxygenPosition and:hydroOne command:@"45xy"]];
    [water addChildNode:[self connectorWithPositions:oxygenPosition and:hydroTwo command:@"135xy"]];
    
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:water position:hydroOne];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:water position:hydroTwo];
    
    water.name = @"Water";
    
    return water;
}



- (void)nodeWithAtom:(SCNGeometry *)atom molecule:(SCNNode *)molecule position:(SCNVector3)position {
    SCNNode *node = [SCNNode nodeWithGeometry:atom];
    node.position = position;
    [molecule addChildNode:node];
}


@end
