//
//  Molecule.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "MoleculeImage.h"
#import "Atom.h"
#import "MathFunctions.h"

static NSArray *molecules = nil;
static NSArray *diatomicMolecules = nil;

@interface MoleculeImage()
@property (nonatomic, strong, readwrite) NSArray *normalMolecules;
@property (nonatomic, strong, readwrite) NSArray *diatomicMolecules;

@end
@implementation MoleculeImage


#pragma mark - hydrocarbons

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
    ptfe.name = @"Polytetraflueroethalyne";
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

- (SCNNode *)ethaneMolecule {
    SCNNode *ethane = [SCNNode node];
    
    //left half of the molecule
    SCNNode *leftHalf = [SCNNode node];
    SCNVector3 carbonLeft = SCNVector3Make(0, 0, 0);
    SCNVector3 hydrogenA = SCNVector3Make(-2.5, -2.5, 0);
    SCNVector3 hydrogenB = SCNVector3Make(-2, 2, -2.5);
    SCNVector3 hydrogenC = SCNVector3Make(-2, 2, 2.5);
    
    //atoms of the left
    [self nodeWithAtom:[Atom carbonAtom] molecule:leftHalf position:carbonLeft];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:leftHalf position:hydrogenA];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:leftHalf position:hydrogenB];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:leftHalf position:hydrogenC];
    
    //connectors of the left
    [leftHalf addChildNode:[self connectorWithPositions:carbonLeft and:hydrogenA command:@"45xy"]];
    SCNNode *problemConnector = [self connectorWithPositions:carbonLeft and:hydrogenB command:@"-45xyzWIDE"];
    problemConnector.name = @"problem";
    [leftHalf addChildNode:problemConnector];
    [leftHalf addChildNode:[self connectorWithPositions:carbonLeft and:hydrogenC command:@"45xyzWIDE"]];

    leftHalf.position = SCNVector3Make(-2.5, 0, 0);
    [ethane addChildNode:leftHalf];
    
    SCNNode *rightHalf = [leftHalf clone];
    rightHalf.position = SCNVector3Make(2.5, 0, 0);

    rightHalf.pivot = SCNMatrix4MakeRotation(M_PI, 3, 10, -5);
    
    [ethane addChildNode:rightHalf];
    
    [ethane addChildNode:[self connectorWithPositions:SCNVector3Make(-2.5, 0, 0) and:SCNVector3Make(+2.5, 0, 0) command:@"0xy"]];
    ethane.name = @"Ethane";
    return ethane;
}

- (SCNNode *)propaneMolecule {
    SCNNode *propane = [SCNNode node];
    
    //top left submolec
    SCNNode *topLeft = [self oneCarbonThreeHydrogen];
    topLeft.position = SCNVector3Make(-4, 0, 0);
    [propane addChildNode:topLeft];
    
    //top right submolec
    SCNNode *topRight = [topLeft clone];
    topRight.position = SCNVector3Make(+4, 0, 0);
    topRight.pivot = SCNMatrix4MakeRotation(M_PI, 1, 50, 1);
    [propane addChildNode:topRight];
    
    //bottom submolec
    SCNNode *bottomSubMolec = [self oneCarbonTwoHydrogenYZFaceUp:NO];
    bottomSubMolec.position = SCNVector3Make(0, -3, 0);

    //connecting the sub molecules
    SCNVector3 bottomCarbon = SCNVector3Make(0, -3, 0);
    SCNVector3 topLeftCarbon = SCNVector3Make(-4, 0, 0);
    SCNVector3 topRightCarbon = SCNVector3Make(4, 0, 0);
    [propane addChildNode:[self connectorWithPositions:bottomCarbon and:topLeftCarbon command:@"135xy"]];
    [propane addChildNode:[self connectorWithPositions:bottomCarbon and:topRightCarbon command:@"45xy"]];

    [propane addChildNode:bottomSubMolec];
    
    propane.name = @"Propane";
    return propane;
}

- (SCNNode *)butaneMolecule {
    SCNNode *butane = [SCNNode node];
    SCNNode *leftThreeHydro = [self oneCarbonThreeHydrogen];
    leftThreeHydro.position = SCNVector3Make(-6, -1, 0);
    leftThreeHydro.pivot = SCNMatrix4MakeRotation(M_PI, 7, -1, 0);
    [butane addChildNode:leftThreeHydro];
    
    SCNNode *leftTwoHydro = [self oneCarbonTwoHydrogenYZFaceUp:YES];
    leftTwoHydro.position = SCNVector3Make(-2, +1, 0);
    [butane addChildNode:leftTwoHydro];
    
    SCNNode *rightTwoHydro = [self oneCarbonTwoHydrogenYZFaceUp:NO];
    rightTwoHydro.position = SCNVector3Make(+2, -1, 0);
    [butane addChildNode:rightTwoHydro];
    
    SCNNode *rightThreeHydro = [self oneCarbonThreeHydrogen];
    rightThreeHydro.position = SCNVector3Make(+6, +1, 0);
    rightThreeHydro.pivot = SCNMatrix4MakeRotation(M_PI, 1, 50, 1);

    [butane addChildNode:rightThreeHydro];
    
    //add connectors
    [butane addChildNode:[self connectorWithPositions:leftThreeHydro.position and:leftTwoHydro.position command:@"30xy"]];
    [butane addChildNode:[self connectorWithPositions:leftTwoHydro.position and:rightTwoHydro.position command:@"-30xy"]];
    [butane addChildNode:[self connectorWithPositions:rightTwoHydro.position and:rightThreeHydro.position command:@"30xy"]];

    butane.name = @"Butane";
    return butane;
}

- (SCNNode *)pentaneMolecule {
    SCNNode *pentane = [SCNNode node];
    
    SCNNode *leftSubMolecule = [self oneCarbonTwoHydrogenYZFaceUp:YES];
    leftSubMolecule.position = SCNVector3Make(-4, +1.5, 0);
    SCNNode *middleSubMolecule = [self oneCarbonTwoHydrogenYZFaceUp:NO];
    middleSubMolecule.position = SCNVector3Make(0, -1.5, 0);
    SCNNode *rightSubMolecule = [self oneCarbonTwoHydrogenYZFaceUp:YES];
    rightSubMolecule.position = SCNVector3Make(+4, +1.5, 0);
    
    SCNNode *leftThreeHydro = [self oneCarbonThreeHydrogen];
    leftThreeHydro.position = SCNVector3Make(-8, -1.5, 0);
    leftThreeHydro.pivot = SCNMatrix4MakeRotation(M_PI, 7, -1, 0);
    
    SCNNode *rightThreeHydro = [self oneCarbonThreeHydrogen];
    rightThreeHydro.pivot = SCNMatrix4MakeRotation(M_PI, 7, -1, 0);
    rightThreeHydro.pivot = SCNMatrix4MakeRotation(M_PI, 0, 0, 10);
    rightThreeHydro.position = SCNVector3Make(+8, -1.5, 0);
    
    [pentane addChildNode:leftSubMolecule];
    [pentane addChildNode:middleSubMolecule];
    [pentane addChildNode:rightSubMolecule];
    [pentane addChildNode:leftThreeHydro];
    [pentane addChildNode:rightThreeHydro];
    
    //connectors
    [pentane addChildNode:[self connectorWithPositions:leftThreeHydro.position and:leftSubMolecule.position command:@"40xy"]];
    [pentane addChildNode:[self connectorWithPositions:leftSubMolecule.position and:middleSubMolecule.position command:@"-40xy"]];
    [pentane addChildNode:[self connectorWithPositions:middleSubMolecule.position and:rightSubMolecule.position command:@"40xy"]];
    [pentane addChildNode:[self connectorWithPositions:rightSubMolecule.position and:rightThreeHydro.position command:@"-40xy"]];

    pentane.name = @"Pentane";
    return pentane;
}

- (SCNNode *)benzeneMolecule {
    SCNNode *benzeneMolecule = [SCNNode node];
    
    //adding atoms...
    SCNNode *bottomHalf = [SCNNode node];
    SCNNode *middleNode = [self oneCarbonOneHydrogenFaceUp:NO];
    SCNNode *leftNode = [middleNode clone];
    SCNNode *rightNode = [middleNode clone];
    SCNMatrix4 leftNodeRotation = [self rotationWithCommand:@"40xy"];
    SCNMatrix4 rightNodeRotation = [self rotationWithCommand:@"-40xy"];
    
    middleNode.position = SCNVector3Make(0, -4.5, 0);
    leftNode.position = SCNVector3Make(-4.5, -2, 0);
    rightNode.position = SCNVector3Make(+4.5, -2, 0);
    
    leftNode.pivot = leftNodeRotation;
    rightNode.pivot = rightNodeRotation;
    
    [bottomHalf addChildNode:middleNode];
    [bottomHalf addChildNode:rightNode];
    [bottomHalf addChildNode:leftNode];
    bottomHalf.position = SCNVector3Make(0, 0, 0);
    
    [benzeneMolecule addChildNode:bottomHalf];
    
    SCNNode *topHalf = [bottomHalf clone];
    topHalf.pivot = SCNMatrix4MakeRotation(M_PI, 1, 1, 50);
    topHalf.position = SCNVector3Make(0, 1, 0);
    
    [benzeneMolecule addChildNode:topHalf];
    
    //adding double bonds...

    SCNNode *doubleBondLeft = [self doubleBondConnectorPositionA:SCNVector3Make(-4.5, 2, 0) b:SCNVector3Make(-4.5, -2, 0) YBased:NO command:@"90xy"];
    SCNNode *doubleBondBottom = [self doubleBondConnectorPositionA:middleNode.position b:rightNode.position YBased:YES command:@"40xy"];
    
    SCNVector3 topDoubleBondPosition = SCNVector3Make(0, 5.5, 0);
    SCNVector3 rightDoubleBondPosition = SCNVector3Make(4.5, 3, 0);
    
    SCNNode *doubleBondTop = [self doubleBondConnectorPositionA:topDoubleBondPosition b:rightDoubleBondPosition YBased:YES command:@"-40xy"];

    [benzeneMolecule addChildNode:doubleBondTop];
    [benzeneMolecule addChildNode:doubleBondBottom];
    [benzeneMolecule addChildNode:doubleBondLeft];
    
    //adding single bonds
    [benzeneMolecule addChildNode:[self connectorWithPositions:middleNode.position and:leftNode.position command:@"-40xy"]];
    [benzeneMolecule addChildNode:[self connectorWithPositions:topDoubleBondPosition and:SCNVector3Make(-4.5, 3, 0) command:@"40xy"]];
    [benzeneMolecule addChildNode:[self connectorWithPositions:rightNode.position and:rightDoubleBondPosition command:@"90xy"]];
    benzeneMolecule.name = @"Benzene";
    return benzeneMolecule;
}

- (SCNNode *)acetoneMolecule {
    SCNNode *acetone = [SCNNode node];
    
    SCNNode *leftSubmolecule = [self oneCarbonThreeHydrogen];
    leftSubmolecule.position = SCNVector3Make(-4, 3, 0);
    
    SCNNode *rightSubmolecule = [leftSubmolecule clone];
    rightSubmolecule.position = SCNVector3Make(4, 3, 0);
    rightSubmolecule.pivot = SCNMatrix4MakeRotation(M_PI, 1, 50, 1);
    
    [acetone addChildNode:rightSubmolecule];
    [acetone addChildNode:leftSubmolecule];
    
    [self nodeWithAtom:[Atom carbonAtom] molecule:acetone position:SCNVector3Make(0, 0, 0)];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:acetone position:SCNVector3Make(0, -4, 0)];
    SCNNode *bottomDoubleBond = [self doubleBondConnectorPositionA:SCNVector3Make(0, 0, 0) b:SCNVector3Make(0, -4, 0) YBased:NO command:@"90xy"];
    
    [acetone addChildNode:bottomDoubleBond];
    
    [acetone addChildNode:[self connectorWithPositions:rightSubmolecule.position and:SCNVector3Make(0, 0, 0) command:@"40xy"]];
    [acetone addChildNode:[self connectorWithPositions:leftSubmolecule.position and:SCNVector3Make(0, 0, 0) command:@"-40xy"]];
    
    acetone.name = @"Acetone";
    return acetone;
}

- (SCNNode *)etherMolecule {
    SCNNode *ether = [SCNNode node];
    
    [self nodeWithAtom:[Atom oxygenAtom] molecule:ether position:SCNVector3Make(0, -1.5, 0)];
    
    SCNNode *leftSubMolecule = [self oneCarbonTwoHydrogenYZFaceUp:YES];
    leftSubMolecule.position = SCNVector3Make(-4, +1.5, 0);
    
    SCNNode *rightSubMolecule = [self oneCarbonTwoHydrogenYZFaceUp:YES];
    rightSubMolecule.position = SCNVector3Make(+4, +1.5, 0);
    
    SCNNode *leftThreeHydro = [self oneCarbonThreeHydrogen];
    leftThreeHydro.position = SCNVector3Make(-8, -1.5, 0);
    leftThreeHydro.pivot = SCNMatrix4MakeRotation(M_PI, 10, -1, 0);
    
    SCNNode *rightThreeHydro = [self oneCarbonThreeHydrogen];
    rightThreeHydro.pivot = SCNMatrix4MakeRotation(M_PI, 10, -1, 0);
    rightThreeHydro.pivot = SCNMatrix4MakeRotation(M_PI, 0, 0, 10);
    rightThreeHydro.position = SCNVector3Make(+8, -1.5, 0);
    
    [ether addChildNode:leftSubMolecule];
    [ether addChildNode:rightSubMolecule];
    [ether addChildNode:leftThreeHydro];
    [ether addChildNode:rightThreeHydro];
    
    [ether addChildNode:[self connectorWithPositions:leftThreeHydro.position and:leftSubMolecule.position command:@"40xy"]];
    [ether addChildNode:[self connectorWithPositions:leftSubMolecule.position and:SCNVector3Make(0, -1.5, 0) command:@"-40xy"]];
    [ether addChildNode:[self connectorWithPositions:SCNVector3Make(0, -1.5, 0) and:rightSubMolecule.position command:@"40xy"]];
    [ether addChildNode:[self connectorWithPositions:rightSubMolecule.position and:rightThreeHydro.position command:@"-40xy"]];
    
    ether.name = @"Ether";
    return ether;
}

- (SCNNode *)nitrousOxideMolecule {
    SCNNode *nitrousOxide = [SCNNode node];
    
    SCNVector3 nitrogenCenter = SCNVector3Make(0, 0, 0);
    SCNVector3 nitrogenLeft = SCNVector3Make(-4, 0, 0);
    SCNVector3 oxygenRight = SCNVector3Make(4, 0, 0);
    
    [self nodeWithAtom:[Atom nitrogenAtom] molecule:nitrousOxide position:nitrogenCenter];
    [self nodeWithAtom:[Atom nitrogenAtom] molecule:nitrousOxide position:nitrogenLeft];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:nitrousOxide position:oxygenRight];
    
    SCNNode *connector = [self tripleBondConnectorPositionA:nitrogenCenter b:nitrogenLeft YBased:YES command:@"0xy"];
    
    [nitrousOxide addChildNode:[self connectorWithPositions:nitrogenLeft and:nitrogenCenter command:@"0xy"]];
    [nitrousOxide addChildNode:[self connectorWithPositions:nitrogenCenter and:oxygenRight command:@"0xy"]];
    
    [nitrousOxide addChildNode:connector];
    
    nitrousOxide.name = @"Nitrous Oxide";
    return nitrousOxide;
}

#pragma mark - acids

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

#pragma mark - diatomics and polyatomics

- (SCNNode *)oxygenMolecule {
    SCNNode *oxygen = [SCNNode node];
    oxygen.position = SCNVector3Make(0, 0, 0);
    [self nodeWithAtom:[Atom oxygenAtom] molecule:oxygen position:SCNVector3Make(-2.5, 0, 0)];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:oxygen position:SCNVector3Make(2.5, 0, 0)];
    
    SCNNode *connector = [self doubleBondConnectorPositionA:SCNVector3Make(-2.5, 0, 0) b:SCNVector3Make(2.5, 0, 0) YBased:YES command:@"0xy"];
    
    [oxygen addChildNode:connector];
    
    oxygen.name = @"Oxygen";
    return oxygen;
}

- (SCNNode *)chlorineMolecule {
    SCNNode *chlorine = [SCNNode node];
    chlorine.position = SCNVector3Make(0, 0, 0);
    [self nodeWithAtom:[Atom chlorineAtom] molecule:chlorine position:SCNVector3Make(-2.5, 0, 0)];
    [self nodeWithAtom:[Atom chlorineAtom] molecule:chlorine position:SCNVector3Make(+2.5, 0, 0)];
    
    [chlorine addChildNode:[self connectorWithPositions:SCNVector3Make(-2.5, 0, 0) and:SCNVector3Make(+2.5, 0, 0) command:@"0xy"]];
    
    chlorine.name = @"Chlorine";
    return chlorine;
}

- (SCNNode *)IodineMolecule {
    SCNNode *iodine = [SCNNode node];
    iodine.position = SCNVector3Make(0, 0, 0);
    [self nodeWithAtom:[Atom iodineAtom] molecule:iodine position:SCNVector3Make(-2.5, 0, 0)];
    [self nodeWithAtom:[Atom iodineAtom] molecule:iodine position:SCNVector3Make(+2.5, 0, 0)];
    
    [iodine addChildNode:[self connectorWithPositions:SCNVector3Make(-2.5, 0, 0) and:SCNVector3Make(+2.5, 0, 0) command:@"0xy"]];
    
    iodine.name = @"Iodine";
    return iodine;
}

- (SCNNode *)hydrogenMolecule {
    SCNNode *hydro = [SCNNode node];
    hydro.position =SCNVector3Make(0, 0, 0);
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:hydro position:SCNVector3Make(-2.5, 0, 0)];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:hydro position:SCNVector3Make(+2.5, 0, 0)];

    [hydro addChildNode:[self connectorWithPositions:SCNVector3Make(+2.5, 0, 0) and:SCNVector3Make(-2.5, 0, 0) command:@"0xy"]];
    
    hydro.name = @"Hydrogen";
    return hydro;
}

- (SCNNode *)fluorineMolecule {
    SCNNode *fluorine = [SCNNode node];
    fluorine.position = SCNVector3Make(0, 0, 0);
    [self nodeWithAtom:[Atom fluorineAtom] molecule:fluorine position:SCNVector3Make(-2.5, 0, 0)];
    [self nodeWithAtom:[Atom fluorineAtom] molecule:fluorine position:SCNVector3Make(+2.5, 0, 0)];
    
    [fluorine addChildNode:[self connectorWithPositions:SCNVector3Make(2.5, 0, 0) and:SCNVector3Make(-2.5, 0, 0) command:@"0xy"]];
    
    fluorine.name = @"Fluorine";
    return fluorine;
}

- (SCNNode *)nitrogenMolecule {
    SCNNode *nitrogen = [SCNNode node];
    nitrogen.position =SCNVector3Make(0, 0, 0);
    
    [self nodeWithAtom:[Atom nitrogenAtom] molecule:nitrogen position:SCNVector3Make(-2.5, 0, 0)];
    [self nodeWithAtom:[Atom nitrogenAtom] molecule:nitrogen position:SCNVector3Make(2.5, 0, 0)];
    
    SCNNode *connector = [self tripleBondConnectorPositionA:SCNVector3Make(-2.5, 0, 0) b:SCNVector3Make(+2.5, 0, 0) YBased:YES command:@"0xy"];
    [nitrogen addChildNode:connector];
    
    nitrogen.name = @"Nitrogen";
    return nitrogen;
}

- (SCNNode *)bromineMolecule {
    SCNNode *bromine = [SCNNode node];
    bromine.position = SCNVector3Make(0, 0, 0);
    
    [self nodeWithAtom:[Atom bromineAtom] molecule:bromine position:SCNVector3Make(-3, 0, 0)];
    [self nodeWithAtom:[Atom bromineAtom] molecule:bromine position:SCNVector3Make(+3, 0, 0)];
    
    [bromine addChildNode:[self connectorWithPositions:SCNVector3Make(+3, 0, 0) and:SCNVector3Make(-3, 0, 0) command:@"0xy"]];
    bromine.name = @"Bromine";
    return bromine;
}

- (SCNNode *)ozoneMolecule {
    SCNNode *ozone = [SCNNode node];
    SCNVector3 oxygenLeft = SCNVector3Make(4, 3, 0);
    SCNVector3 oxygenCenter = SCNVector3Make(0, 0, 0);
    SCNVector3 oxygenRight = SCNVector3Make(-4, 3, 0);
    
    [self nodeWithAtom:[Atom oxygenAtom] molecule:ozone position:oxygenCenter];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:ozone position:oxygenRight];
    [self nodeWithAtom:[Atom oxygenAtom] molecule:ozone position:oxygenLeft];
    
    SCNNode *rightConnector = [self connectorWithPositions:oxygenRight and:oxygenCenter command:@"-40xy"];
    SCNNode *leftConnector = [self doubleBondConnectorPositionA:oxygenCenter b:oxygenLeft YBased:YES command:@"40xy"];
    
    [ozone addChildNode:rightConnector];
    [ozone addChildNode:leftConnector];
    
    
    ozone.name = @"Ozone";
    return ozone;
}

- (SCNNode *)phosphorousMolecule {
    SCNNode *phos = [SCNNode node];
    
    SCNVector3 phosTop = SCNVector3Make(0, 8, 4);
    SCNVector3 phosLeft = SCNVector3Make(-4, 0, 0);
    SCNVector3 phosRight = SCNVector3Make(+4, 0, 0);
    SCNVector3 phosProtruding = SCNVector3Make(0, 0, 8);
    
    [self nodeWithAtom:[Atom phosphorousAtom] molecule:phos position:phosLeft];
    [self nodeWithAtom:[Atom phosphorousAtom] molecule:phos position:phosRight];
    [self nodeWithAtom:[Atom phosphorousAtom] molecule:phos position:phosProtruding];
    [self nodeWithAtom:[Atom phosphorousAtom] molecule:phos position:phosTop];

    SCNNode *connectorXY = [self connectorWithPositions:phosLeft and:phosRight command:@"0xy"];
    SCNNode *connectorXZLeft = [self connectorWithPositions:phosLeft and:phosProtruding command:@"30xz"];
    SCNNode *connectorXZRight = [self connectorWithPositions:phosProtruding and:phosRight command:@"-30xz"];

    [phos addChildNode:connectorXY];
    [phos addChildNode:connectorXZLeft];
    [phos addChildNode:connectorXZRight];
    
    [phos addChildNode:[self connectorWithPositions:phosTop and:phosLeft command:@"60xyz"]];
    [phos addChildNode:[self connectorWithPositions:phosTop and:phosRight command:@"-60xyz"]];
    [phos addChildNode:[self connectorWithPositions:phosTop and:phosProtruding command:@"zPosyPos"]];
    
    phos.name = @"Phosphorous";
    return phos;
}

- (SCNNode *)sulfurMolecule {
    SCNNode *sulfur = [SCNNode node];
    
    //S8 is the same sub molecule 4 times
    
    SCNNode *sulfurSubmolecule = [SCNNode node];
    sulfurSubmolecule.position = SCNVector3Make(0, 0, 0);
    SCNVector3 sulfurRight = SCNVector3Make(-5, 0, 0);
    SCNVector3 sulfurLeft = SCNVector3Make(5, 0, 0);
    SCNVector3 sulfurCenter = SCNVector3Make(0, 3, 2);
    [self nodeWithAtom:[Atom sulfurAtom] molecule:sulfurSubmolecule position:sulfurCenter];
    [self nodeWithAtom:[Atom sulfurAtom] molecule:sulfurSubmolecule position:sulfurRight];
    [self nodeWithAtom:[Atom sulfurAtom] molecule:sulfurSubmolecule position:sulfurLeft];
    
    [sulfurSubmolecule addChildNode:[self connectorWithPositions:sulfurLeft and:sulfurCenter command:@"45xyz"]];
    [sulfurSubmolecule addChildNode:[self connectorWithPositions:sulfurRight and:sulfurCenter command:@"135xyz"]];

    SCNNode *sulfurSubmoleculeLeft = [sulfurSubmolecule clone];
    sulfurSubmoleculeLeft.position = SCNVector3Make(-5, 0, -5);
    sulfurSubmoleculeLeft.pivot = SCNMatrix4MakeRotation(M_PI_2, 1, 50, 2);
    
    SCNNode *sulfurHalf = [SCNNode node];
    sulfurHalf.position = SCNVector3Make(0, 0, 0);
    [sulfurHalf addChildNode:sulfurSubmolecule];
    [sulfurHalf addChildNode:sulfurSubmoleculeLeft];
    
    SCNNode *sulfurHalfB = [sulfurHalf clone];
    sulfurHalfB.position = SCNVector3Make(0, 0, -10);
    sulfurHalfB.pivot = SCNMatrix4MakeRotation(M_PI, 0.5, 50, 0.5);

    [sulfur addChildNode:sulfurHalf];
    [sulfur addChildNode:sulfurHalfB];
    sulfur.name = @"Sulfur";
    return sulfur;
}

#pragma mark - convienience

- (void)nodeWithAtom:(SCNGeometry *)atom molecule:(SCNNode *)molecule position:(SCNVector3)position {
    SCNNode *node = [SCNNode nodeWithGeometry:atom];
    node.position = position;
    [molecule addChildNode:node];
}

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
    }else if([command isEqualToString:@"30xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, 1.5, 0);
    }else if([command isEqualToString:@"-30xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -1.5, 0);
    } else if([command isEqualToString:@"40xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, 2, 0);
    } else if([command isEqualToString:@"-40xy"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -2, 0);
        //YZ
    } else if([command isEqualToString:@"45yz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 0, -2.5, 1);
    } else if([command isEqualToString:@"135yz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 0, -2.5, -1);
    }else if([command isEqualToString:@"-135yz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 0, 2.5, -1);
    }
    //XYZ
    else if([command isEqualToString:@"45xyzWIDE"]){
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -2.5, -1);
    } else if([command isEqualToString:@"-45xyzWIDE"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, 1, -2.5, 1);
    } else if([command isEqualToString:@"60xyz"]) { //phosphorous
        rotation = SCNMatrix4MakeRotation(M_PI, 2, 10, 2);
    } else if([command isEqualToString:@"-60xyz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI, -2, 10, 2);
    } else if([command isEqualToString:@"zPosyPos"]) {
        rotation = SCNMatrix4MakeRotation(M_PI_2, 2, -10, 2);
    }
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
    } else if([command isEqualToString:@"30xz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI_2, 10, 0, -4);
    } else if([command isEqualToString:@"-30xz"]) {
        rotation = SCNMatrix4MakeRotation(M_PI_2, 10, 0, 4);
    }
    
    return rotation;
}

#pragma mark - all exposed molecules

- (NSArray *)normalMolecules {
    if(!_normalMolecules) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableArray *allMolecs = [NSMutableArray array];
            NSArray *acids =@[  [self nitricAcidMolecule] , [self aceticAcidMolecule], [self sulfuricAcidMolecule], ];
            NSArray *hydroCarbons = @[[self nitrousOxideMolecule] , [self etherMolecule] , [self acetoneMolecule] , [self benzeneMolecule] ,[self pentaneMolecule] ,[self butaneMolecule] , [self propaneMolecule] , [self ethaneMolecule] , [self carbonDioxideMolecule] , [self carbonMonoxideMolecule], [self sulfurTrioxideMolecule], [self sulfurDioxideMolecule] , [self hydrogenChlorideMolecule] , [self hydrogenPeroxideMolecule] , [self waterMolecule], [self ammoniaMolecule] , [self ptfeMolecule] , [self methaneMolecule]];
            [allMolecs addObjectsFromArray:acids];
            [allMolecs addObjectsFromArray:hydroCarbons];
            molecules = (NSArray *)allMolecs;
        });
        _normalMolecules = molecules;
    }
    return _normalMolecules;
}

- (NSArray *)diatomicMolecules {
    if(!_diatomicMolecules) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            diatomicMolecules = @[[self sulfurMolecule] ,[self ozoneMolecule] , [self IodineMolecule], [self chlorineMolecule] ,[self oxygenMolecule], [self bromineMolecule] , [self phosphorousMolecule], [self nitrogenMolecule] , [self fluorineMolecule]];
        });
        _diatomicMolecules = diatomicMolecules;
    }
    return _diatomicMolecules;
}

#pragma mark - convienience submolecules

- (SCNNode *)doubleBondConnectorPositionA:(SCNVector3)positionA b:(SCNVector3)positionB YBased:(BOOL)yBased command:(NSString *)command {
    SCNNode *connectors = [SCNNode node];
    
    SCNVector3 connectorPointA = SCNVector3Make(positionA.x, positionA.y - 0.3, positionA.z);
    SCNVector3 connectorPointB = SCNVector3Make(positionA.x, positionA.y + 0.3, positionA.z);
    
    SCNVector3 connectorPointC = SCNVector3Make(positionB.x, positionB.y + 0.3, positionB.z);
    SCNVector3 connectorPointD = SCNVector3Make(positionB.x, positionB.y - 0.3, positionB.z);
    if(!yBased) {
        connectorPointA = SCNVector3Make(positionA.x - 0.3, positionA.y, positionA.z);
        connectorPointB = SCNVector3Make(positionA.x + 0.3, positionA.y, positionA.z);
        connectorPointC = SCNVector3Make(positionB.x + 0.3, positionB.y, positionB.z);
        connectorPointD = SCNVector3Make(positionB.x - 0.3, positionB.y, positionB.z);
    }
    
    [connectors addChildNode:[self connectorWithPositions:connectorPointB and:connectorPointC command:command]];
    [connectors addChildNode:[self connectorWithPositions:connectorPointA and:connectorPointD command:command]];

    return connectors;
}

- (SCNNode *)tripleBondConnectorPositionA:(SCNVector3)positionA b:(SCNVector3)positionB YBased:(BOOL)yBased command:(NSString *)command {
    SCNNode *connectors = [SCNNode node];
    
    SCNVector3 connectorPointA = SCNVector3Make(positionA.x, positionA.y - 0.4, positionA.z);
    SCNVector3 connectorPointB = SCNVector3Make(positionA.x, positionA.y + 0.4, positionA.z);
    
    SCNVector3 connectorPointC = SCNVector3Make(positionB.x, positionB.y + 0.4, positionB.z);
    SCNVector3 connectorPointD = SCNVector3Make(positionB.x, positionB.y - 0.4, positionB.z);
    
    if(!yBased) {
        connectorPointA = SCNVector3Make(positionA.x - 0.4, positionA.y, positionA.z);
        connectorPointB = SCNVector3Make(positionA.x + 0.4, positionA.y, positionA.z);
        connectorPointC = SCNVector3Make(positionB.x + 0.4, positionB.y, positionB.z);
        connectorPointD = SCNVector3Make(positionB.x - 0.4, positionB.y, positionB.z);
    }
    
    
    [connectors addChildNode:[self connectorWithPositions:connectorPointB and:connectorPointC command:command]];
    [connectors addChildNode:[self connectorWithPositions:connectorPointA and:connectorPointD command:command]];
    [connectors addChildNode:[self connectorWithPositions:positionA and:positionB command:command]];
    
    
    return connectors;
}

- (SCNNode *)oneCarbonOneHydrogenFaceUp:(BOOL)faceUp {
    SCNNode *carbonHydroSubMolec = [SCNNode node];
    SCNVector3 carbonPosition = SCNVector3Make(0, 0, 0);
    SCNVector3 hydrogenPosition = (faceUp) ? SCNVector3Make(0, 3.5, 0) : SCNVector3Make(0 , -3.5, 0);
    
    [self nodeWithAtom:[Atom carbonAtom] molecule:carbonHydroSubMolec position:carbonPosition];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:carbonHydroSubMolec position:hydrogenPosition];
    
    [carbonHydroSubMolec addChildNode:[self connectorWithPositions:carbonPosition and:hydrogenPosition command:@"90xy"]];
    
    return carbonHydroSubMolec;
}

- (SCNNode *)oneCarbonThreeHydrogen {
    SCNNode *topLeft = [SCNNode node];
    SCNVector3 carbonPosition = SCNVector3Make(0, 0, 0);
    SCNVector3 hydroPosZ = SCNVector3Make(0, 3, +3);
    SCNVector3 hydroNegZ = SCNVector3Make(0, 3, -3);
    SCNVector3 hydroXY = SCNVector3Make(-2.5, -2.5, 0);
    [self nodeWithAtom:[Atom carbonAtom] molecule:topLeft position:carbonPosition];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:topLeft position:hydroNegZ];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:topLeft position:hydroPosZ];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:topLeft position:hydroXY];
    [topLeft addChildNode:[self connectorWithPositions:carbonPosition and:hydroNegZ command:@"45yz"]];
    [topLeft addChildNode:[self connectorWithPositions:carbonPosition and:hydroPosZ command:@"135yz"]];
    [topLeft addChildNode:[self connectorWithPositions:carbonPosition and:hydroXY command:@"45xy"]];
    
    return topLeft;
}

- (SCNNode *)oneCarbonTwoHydrogenYZFaceUp:(BOOL)faceUp {
    SCNNode *bottomSubMolec = [SCNNode node];
    SCNVector3 carbonPositionBottom = SCNVector3Make(0, 0, 0);
    SCNVector3 hydrogenPositionPosZ = SCNVector3Make(0, -3, 3);
    SCNVector3 hydrogenPositionNegZ = SCNVector3Make(0, -3, -3);
    
    [self nodeWithAtom:[Atom carbonAtom] molecule:bottomSubMolec position:carbonPositionBottom];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:bottomSubMolec position:hydrogenPositionPosZ];
    [self nodeWithAtom:[Atom hydrogenAtom] molecule:bottomSubMolec position:hydrogenPositionNegZ];
    
    [bottomSubMolec addChildNode:[self connectorWithPositions:carbonPositionBottom and:hydrogenPositionNegZ command:@"-45yz"]];
    [bottomSubMolec addChildNode:[self connectorWithPositions:carbonPositionBottom and:hydrogenPositionPosZ command:@"45yz"]];
    
    if(faceUp) {
        bottomSubMolec.pivot = SCNMatrix4MakeRotation(M_PI, 0, 0, 5);
    }
    return bottomSubMolec;
}

#pragma mark - exposed methods

+ (SCNNode *)moleculeForName:(NSString *)name {
    for(SCNNode *node in molecules) {
        if([node.name isEqualToString:name]) {
            return node;
        }
    }
    [[NSException exceptionWithName:@"Wrong molecule name" reason:@"no molecule available for given input" userInfo:0] raise];
    
    return nil;
}


@end
