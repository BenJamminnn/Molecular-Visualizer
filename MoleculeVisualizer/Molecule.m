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

- (SCNNode *)connectorWithPositions:(SCNVector3)positionA and:(SCNVector3)positionB command:(NSString *)command distance:(CGFloat)distance {
    SCNNode *node = [SCNNode node];

    distance = distance *2;
    SCNGeometry *cylinder = [SCNCylinder cylinderWithRadius:0.15 height:distance];
    cylinder.firstMaterial.diffuse.contents = [UIColor darkGrayColor];
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



- (SCNNode *)connectorWithPositions:(SCNVector3)positionA and:(SCNVector3)positionB command:(NSString *)command {
    SCNNode *node = [SCNNode node];
    
    //first compute the distance. i.e height
    CGFloat distance = [MathFunctions distanceFormulaWithVectors:positionA and:positionB];
    
    SCNGeometry *cylinder = [SCNCylinder cylinderWithRadius:0.15 height:distance];
    cylinder.firstMaterial.diffuse.contents = [UIColor darkGrayColor];
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
    
    //XY
    if([command isEqualToString:@"90xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI_2, 0, 1, 0);
    } else if([command isEqualToString:@"0xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI_2, 0, 0, 1);
    } else if([command isEqualToString:@"45xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, 2.5, 0);
    } else if([command isEqualToString:@"135xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -2.5, 0);
    }else if ([command isEqualToString:@"345xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 2.2,-2.5, 0);
    //YZ
    } else if([command isEqualToString:@"45yz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 0, -2.5, 1);
    } else if([command isEqualToString:@"135yz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 0, -2.5, -1);
    }else if([command isEqualToString:@"-135yz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 0, 2.5, -1);
    }
    //XYZ
     else if([command isEqualToString:@"-45xyz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -2.5, 0.5);
    } else if([command isEqualToString:@"45xyz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -2.5, -0.5);
    } else if([command isEqualToString:@"135xyz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, -1, -2.5, -0.5);
    }  else if([command isEqualToString:@"45-xyz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, -1, -2.5, 0.5);
    }  else if([command isEqualToString:@"-45yz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 0, -2.5, -1);
    } else if([command isEqualToString:@"45xz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, -3, 4, -2.5);
    } else if([command isEqualToString:@"135xz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 3, 4, -2.5);
    }
    
    return rotation;
}

- (SCNNode *)methaneMolecule {
    SCNNode *methane = [SCNNode node];
    methane.name = @"Methane";
    SCNVector3 carbonPosition = SCNVector3Make(0, 0, 0);
    
    SCNVector3 hydrogenOnePosition = SCNVector3Make(0, -3.5, 3.5);
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
    SCNVector3 carbonLeft = SCNVector3Make(-3, 0, 0);
    SCNVector3 carbonRight = SCNVector3Make(+3, 0, 0);
    SCNVector3 carbonDoubleBondLeft = SCNVector3Make(+3, +0.3, 0);
    SCNVector3 carbonDoubleBondRight = SCNVector3Make(-3, +0.3, 0);
    SCNVector3 carbonDoubleBondLeftSecond = SCNVector3Make(+3, -0.3, 0);
    SCNVector3 carbonDoubleBondRightSecond = SCNVector3Make(-3, -0.3, 0);


    
    SCNVector3 fluorineTopLeft = SCNVector3Make(-7, +4, 0);
    SCNVector3 fluorineTopRight = SCNVector3Make(+7, +4, 0);
    SCNVector3 fluorineBottomLeft = SCNVector3Make(-7, -4, 0);
    SCNVector3 fluorineBottomRight = SCNVector3Make(+7, -4, 0);
    
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
    
    SCNVector3 hydroOne = SCNVector3Make(0, -3.4, -3.4);
    SCNVector3 hydroTwo = SCNVector3Make(+3, -3.5, +2);
    SCNVector3 hydroThree = SCNVector3Make(-3, -3.5, +2);

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

- (SCNNode *)hydrogenPeroxideMolecule {
    SCNNode *hydrogenPeroxide = [SCNNode node];
    SCNVector3 oxygenOne = SCNVector3Make(-2, 0, 0);
    SCNVector3 oxygenTwo = SCNVector3Make(+2, 0, 0);
    
    SCNVector3 hydroOne = SCNVector3Make(+5, +3, 0);
    SCNVector3 hydroTwo = SCNVector3Make(-2, -3, 3);
    
    [self nodeWithAtom:[Atom oxygenAtom] molecule:hydrogenPeroxide position:oxygenOne];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:hydrogenPeroxide position:oxygenTwo];
    [hydrogenPeroxide addChildNode:[self connectorWithPositions:oxygenOne and:oxygenTwo command:@"0xy"]];
    
    [hydrogenPeroxide addChildNode:[self connectorWithPositions:oxygenTwo and:hydroOne command:@"45xy"]];
    [hydrogenPeroxide addChildNode:[self connectorWithPositions:oxygenOne and:hydroTwo command:@"45yz"]];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:hydrogenPeroxide position:hydroOne];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:hydrogenPeroxide position:hydroTwo];
    
    hydrogenPeroxide.name = @"Hydrogen Peroxide";
    return hydrogenPeroxide;
}

- (SCNNode *)hydrogenChlorideMolecule {
    SCNNode *hydroChloride = [SCNNode node];
    
    SCNVector3 chlorinePosition = SCNVector3Make(-2, 0, 0);
    SCNVector3 hydrogenPosition = SCNVector3Make(2, 0, 0);
    
    [self nodeWithAtom:[Atom chlorineAtom] molecule:hydroChloride position:chlorinePosition];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:hydroChloride position:hydrogenPosition];
    [hydroChloride addChildNode:[self connectorWithPositions:chlorinePosition and:hydrogenPosition command:@"0xy"]];
    hydroChloride.name = @"Hydrogen Chloride";
    return hydroChloride;
}

- (SCNNode *)sulfuricAcidMolecule {
    
    SCNNode *H2SO4 = [SCNNode node];
   
    //3 sulfur positions for double bonding
    SCNVector3 sulfurPosition = SCNVector3Make(0, 0, 0);
    SCNVector3 sulfurPositive = SCNVector3Make(0, 0, 2);
    SCNVector3 sulfurNegative = SCNVector3Make(0, 0, 1);
    //oxygens on the yz plane, double bonded at 45 and 135 degrees
    SCNVector3 oxygenZPositiveA = SCNVector3Make(0, -4, -5);
    SCNVector3 oxygenZPositiveB = SCNVector3Make(0, -3, -3);
    SCNVector3 oxygenZPosition = SCNVector3Make(0, -4, -4);
    
    SCNVector3 oxygenZPositionNeg = SCNVector3Make(0, 4, -4);
    SCNVector3 oxygenZNegativeA = SCNVector3Make(0, 4, -4.5);
    SCNVector3 oxygenZNegativeB = SCNVector3Make(0, 4, -4.5);
    
    //oxygens on the xz plane, single bonded 45 and 135 degrees
    SCNVector3 oxygenXZaxisA = SCNVector3Make(4, 0, 3.5);
    SCNVector3 oxygenXZaxisB = SCNVector3Make(-4, 0, 3.5);
    
    //hydrogens on the yz plane, single bonded
    SCNVector3 hydrogenPositive = SCNVector3Make(4, 3, 6);
    SCNVector3 hydrogenNegative = SCNVector3Make(-4, -3, 6);
    
    [self nodeWithAtom:[Atom sulfurAtom] molecule:H2SO4 position:sulfurPosition];
    
    //adding yz oxygens
    [self nodeWithAtom:[Atom oxygenAtom] molecule:H2SO4 position:oxygenZPosition];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:H2SO4 position:oxygenZPositionNeg];
    
    //adding xz oxygens
    [self nodeWithAtom:[Atom oxygenAtom] molecule:H2SO4 position:oxygenXZaxisA];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:H2SO4 position:oxygenXZaxisB];
    
    //adding hydrogens
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:H2SO4 position:hydrogenPositive];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:H2SO4 position:hydrogenNegative];
    
    //+Z double bond
    [H2SO4 addChildNode:[self connectorWithPositions:sulfurPositive and:oxygenZPositiveA command:@"-45yz"]];
    [H2SO4 addChildNode:[self connectorWithPositions:sulfurPosition and:oxygenZPositiveB command:@"-45yz"]];
    
    //-Z double bond
    [H2SO4 addChildNode:[self connectorWithPositions:sulfurPosition and:oxygenZNegativeA command:@"45yz"]];
    [H2SO4 addChildNode:[self connectorWithPositions:sulfurNegative and:oxygenZNegativeB command:@"45yz"]];

    //other 2 oxygens bonds xz plane
    [H2SO4 addChildNode:[self connectorWithPositions:sulfurPosition and:oxygenXZaxisA command:@"45xz"]];
    [H2SO4 addChildNode:[self connectorWithPositions:sulfurPosition and:oxygenXZaxisB command:@"135xz"]];
    
    //hydrogen connectors
    [H2SO4 addChildNode:[self connectorWithPositions:oxygenXZaxisB and:hydrogenNegative command:@"-135yz"]];
    [H2SO4 addChildNode:[self connectorWithPositions:oxygenXZaxisA and:hydrogenPositive command:@"135yz"]];

    
    H2SO4.name = @"Sulfuric Acid";
    return H2SO4;
}

- (SCNNode *)nitricAcidMolecule {
    SCNNode *nitricAcid = [SCNNode node];
    
    SCNVector3 nitrogenPosition = SCNVector3Make(0, 0, 0);
    //double bond locations
    SCNVector3 nitrogenPositionA = SCNVector3Make(0, 1, 0);
    SCNVector3 nitrogenPositionB = SCNVector3Make(0, -1, 0);
    
    SCNVector3 oxygen45A = SCNVector3Make(4.5, 4, 0);
    SCNVector3 oxygen45B = SCNVector3Make(4.5, 5, 0);
    
    SCNVector3 oxygen45 = SCNVector3Make(4.5, 4.5, 0);
    
    SCNVector3 oxygen135 = SCNVector3Make(-4.5, 4.5, 0);
    
    SCNVector3 oxygen90 = SCNVector3Make(0, -5, 0);
    
    SCNVector3 hydrogen = SCNVector3Make(4, -5.5, 0);
    
    [self nodeWithAtom:[Atom nitrogenAtom] molecule:nitricAcid position:nitrogenPosition];
    
    [self nodeWithAtom:[Atom oxygenAtom] molecule:nitricAcid position:oxygen45];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:nitricAcid position:oxygen135];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:nitricAcid position:oxygen90];
    
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:nitricAcid position:hydrogen];
    
    //adding bonds - oxygen
    [nitricAcid addChildNode:[self connectorWithPositions:oxygen90 and:nitrogenPosition command:@"90xy"]];
    [nitricAcid addChildNode:[self connectorWithPositions:oxygen135 and:nitrogenPosition command:@"135xy"]];
    
    //double bond
    [nitricAcid addChildNode:[self connectorWithPositions:oxygen45A and:nitrogenPositionA command:@"45xy"]];
    [nitricAcid addChildNode:[self connectorWithPositions:oxygen45B and:nitrogenPositionB command:@"45xy"]];

    //adding hydrogen bond
    [nitricAcid addChildNode:[self connectorWithPositions:oxygen90 and:hydrogen command:@"345xy"]];
    
    nitricAcid.name = @"Nitric Acid";
    return nitricAcid;
}

- (SCNNode *)aceticAcidMolecule {
    //C4H2O2
    SCNNode *aceticAcid = [SCNNode node];
    
    //right carbon with double bond
    SCNVector3 carbonRight = SCNVector3Make(3, 0, 0);
    SCNVector3 carbonRightA = SCNVector3Make(3, 1, 0);
    SCNVector3 carbonRightB = SCNVector3Make(3, -1, 0);
    
    //left carbon
    SCNVector3 carbonLeft = SCNVector3Make(-3, 0, 0);
    
    //oxygen45
    SCNVector3 oxygen45 = SCNVector3Make(7, 4.5, 0);
    SCNVector3 oxygen45A = SCNVector3Make(7, 4, 0);
    SCNVector3 oxygen45B = SCNVector3Make(7, 5, 0);
    
    //oxygen135
    SCNVector3 oxygen135 = SCNVector3Make(7, -4.5, 0);
    
    //hydrogens
    SCNVector3 hydrogenRightMost = SCNVector3Make(11, -3.8, 0);
    SCNVector3 hydrogenZ = SCNVector3Make(carbonLeft.x -1.75, carbonLeft.y - 2.5, 3);
    SCNVector3 hydrogenZNeg = SCNVector3Make(carbonLeft.x -1.75, carbonLeft.y - 2.5, -3);
    SCNVector3 hydrogenSouthMost = SCNVector3Make(carbonLeft.x -1.75, carbonLeft.y +3.5, 0);
    
    //adding atoms
    [self nodeWithAtom:[Atom carbonAtom] molecule:aceticAcid position:carbonRight];
    [self nodeWithAtom:[Atom carbonAtom] molecule:aceticAcid position:carbonLeft];
    
    [self nodeWithAtom:[Atom oxygenAtom] molecule:aceticAcid position:oxygen45];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:aceticAcid position:oxygen135];
    
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:aceticAcid position:hydrogenRightMost];
    
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:aceticAcid position:hydrogenZ];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:aceticAcid position:hydrogenZNeg];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:aceticAcid position:hydrogenSouthMost];
    
    //adding connectors
    [aceticAcid addChildNode:[self connectorWithPositions:carbonRightA and:oxygen45A command:@"45xy"]];
    [aceticAcid addChildNode:[self connectorWithPositions:carbonRightB and:oxygen45B command:@"45xy"]];

    [aceticAcid addChildNode:[self connectorWithPositions:oxygen135 and:carbonRight command:@"135xy"]];
    
    SCNNode *hydroRightMost = [self connectorWithPositions:oxygen135 and:hydrogenRightMost command:@"0xy"];
    hydroRightMost.pivot = SCNMatrix4MakeRotation(M_PI, 1, 1.2, 0);
    [aceticAcid addChildNode:hydroRightMost];
    
    [aceticAcid addChildNode:[self connectorWithPositions:carbonLeft and:carbonRight command:@"0xy"]];
    
    SCNNode *leftHydro = [self connectorWithPositions:carbonLeft and:hydrogenZ command:@"45xyz"];
    SCNNode *rightHydro = [self connectorWithPositions:carbonLeft and:hydrogenZNeg command:@"45xyz"];
    SCNNode *southHydro = [self connectorWithPositions:carbonLeft and:hydrogenSouthMost command:@"45xy"];
    leftHydro.pivot = SCNMatrix4MakeRotation(M_PI, -4, -14, 6);
    rightHydro.pivot = SCNMatrix4MakeRotation(M_PI, -4, -14, -6);
    southHydro.pivot = SCNMatrix4MakeRotation(M_PI, -2, 8, 0);
    [aceticAcid addChildNode:rightHydro];
    [aceticAcid addChildNode:leftHydro];
    [aceticAcid addChildNode:southHydro];
    
    aceticAcid.name = @"Acetic Acid";
    return aceticAcid;
}

- (SCNNode *)sulfurDioxideMolecule {
    SCNNode *sulfurDioxide = [SCNNode node];
    
    SCNVector3 sulfurPosition = SCNVector3Make(0, 0, 0);
    SCNVector3 sulfurPositionRight = SCNVector3Make(1, 0, 0);
    SCNVector3 sulfurPositionLeft = SCNVector3Make(-1, 0, 0);
    
    SCNVector3 oxygenPosition = SCNVector3Make(4, 4, 0);
    SCNVector3 oxygenPositionA = SCNVector3Make(4, 3.5, 0);
    SCNVector3 oxygenPositionB = SCNVector3Make(3, 4.5, 0);
    
    SCNVector3 oxygenTwoPosition = SCNVector3Make(-4, 4, 0);
    SCNVector3 oxygenTwoPositionA = SCNVector3Make(-4, 3.5, 0);
    SCNVector3 oxygenTwoPositionB = SCNVector3Make(-3, 4.5, 0);
    
    //adding atoms
    [self nodeWithAtom:[Atom sulfurAtom] molecule:sulfurDioxide position:sulfurPosition];
    
    [self nodeWithAtom:[Atom oxygenAtom] molecule:sulfurDioxide position:oxygenPosition];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:sulfurDioxide position:oxygenTwoPosition];
    
    //adding connectors
    [sulfurDioxide addChildNode:[self connectorWithPositions:sulfurPositionLeft and:oxygenTwoPositionB command:@"135xy"]];
    [sulfurDioxide addChildNode:[self connectorWithPositions:sulfurPosition and:oxygenTwoPositionA command:@"135xy"]];

    [sulfurDioxide addChildNode:[self connectorWithPositions:sulfurPosition and:oxygenPositionA command:@"45xy"]];
    [sulfurDioxide addChildNode:[self connectorWithPositions:sulfurPositionRight and:oxygenPositionB command:@"45xy"]];

    sulfurDioxide.name = @"Sulfur Dioxide";
    return sulfurDioxide;
}

- (SCNNode *)sulfurTrioxideMolecule {
    SCNNode *sulfurTrioxide = [self sulfurDioxideMolecule];
    
    SCNVector3 southOxygen = SCNVector3Make(0, -5, 0);
    
    SCNVector3 sulfurDoubleBondA = SCNVector3Make(-0.2, 0, 0);
    SCNVector3 sulfurDoubleBondB = SCNVector3Make(0.2, 0, 0);
    
    SCNVector3 oxygenDoubleA = SCNVector3Make(0.2, -5, 0);
    SCNVector3 oxygenDoubleB = SCNVector3Make(-0.2, -5, 0);
    
    [self nodeWithAtom:[Atom oxygenAtom] molecule:sulfurTrioxide position:southOxygen];
    
    //connectors
    [sulfurTrioxide addChildNode:[self connectorWithPositions:sulfurDoubleBondA and:oxygenDoubleB command:@"90xy"]];
    [sulfurTrioxide addChildNode:[self connectorWithPositions:sulfurDoubleBondB and:oxygenDoubleA command:@"90xy"]];

    sulfurTrioxide.name = @"Sulfur Trioxide";
    return sulfurTrioxide;
}

- (SCNNode *)carbonMonoxideMolecule {
    SCNNode *carbonMonoxide = [SCNNode node];
    
    SCNVector3 carbonPosition = SCNVector3Make(-2, 0, 0);
    SCNVector3 carbonPositionUpper = SCNVector3Make(-2, 0.35, 0);
    SCNVector3 carbonPositionLower = SCNVector3Make(-2, -0.35, 0);
    
    SCNVector3 oxygenPosition = SCNVector3Make(2, 0, 0);
    SCNVector3 oxygenPositionUpper = SCNVector3Make(2, 0.35, 0);
    SCNVector3 oxygenPositionLower = SCNVector3Make(2, -0.35, 0);
    
    [self nodeWithAtom:[Atom carbonAtom] molecule:carbonMonoxide position:carbonPosition];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:carbonMonoxide position:oxygenPosition];
    
    //connectors
    [carbonMonoxide addChildNode:[self connectorWithPositions:carbonPositionUpper and:oxygenPositionUpper command:@"0xy"]];
    [carbonMonoxide addChildNode:[self connectorWithPositions:carbonPosition and:oxygenPosition command:@"0xy"]];
    [carbonMonoxide addChildNode:[self connectorWithPositions:carbonPositionLower and:oxygenPositionLower command:@"0xy"]];

    carbonMonoxide.name = @"Carbon Monoxide";
    return carbonMonoxide;
}

- (SCNNode *)carbonDioxideMolecule {
    SCNNode *carbonDioxide = [SCNNode node];
    
    SCNVector3 carbonPosition = SCNVector3Make(0, 0, 0);
    SCNVector3 carbonPositionUpper = SCNVector3Make(0, 0.2, 0);
    SCNVector3 carbonPositionLower = SCNVector3Make(0, -0.2, 0);
    
    SCNVector3 oxygenLeft = SCNVector3Make(-5, 0, 0);
    SCNVector3 oxygenLeftUpper = SCNVector3Make(-5, 0.2, 0);
    SCNVector3 oxygenLeftLower = SCNVector3Make(-5, -0.2, 0);
    
    SCNVector3 oxygenRight = SCNVector3Make(5, 0, 0);
    SCNVector3 oxygenRightUpper = SCNVector3Make(5, 0.2, 0);
    SCNVector3 oxygenRightLower = SCNVector3Make(5, -0.2, 0);
    
    //adding atoms
    [self nodeWithAtom:[Atom carbonAtom] molecule:carbonDioxide position:carbonPosition];
    
    [self nodeWithAtom:[Atom oxygenAtom] molecule:carbonDioxide position:oxygenLeft];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:carbonDioxide position:oxygenRight];
    
    //connectors
    [carbonDioxide addChildNode:[self connectorWithPositions:carbonPositionUpper and:oxygenLeftUpper command:@"0xy"]];
    [carbonDioxide addChildNode:[self connectorWithPositions:carbonPositionLower and:oxygenLeftLower command:@"0xy"]];
    [carbonDioxide addChildNode:[self connectorWithPositions:carbonPositionUpper and:oxygenRightUpper command:@"0xy"]];
    [carbonDioxide addChildNode:[self connectorWithPositions:carbonPositionLower and:oxygenRightLower command:@"0xy"]];

    carbonDioxide.name = @"Carbon Dioxide";
    return carbonDioxide;
}

- (void)nodeWithAtom:(SCNGeometry *)atom molecule:(SCNNode *)molecule position:(SCNVector3)position {
    SCNNode *node = [SCNNode nodeWithGeometry:atom];
    node.position = position;
    [molecule addChildNode:node];
}



@end
