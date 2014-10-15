//
//  MathFunctions.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/13/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "MathFunctions.h"

@implementation MathFunctions

+ (CGFloat)distanceFormulaWithVectors:(SCNVector3)vectorA and:(SCNVector3)vectorB {
    CGFloat result = 0;
    
    CGFloat xArguement = pow((vectorB.x - vectorA.x), 2);
    CGFloat yArguement = pow((vectorB.y - vectorA.y), 2);
    CGFloat zArguement = pow((vectorB.z - vectorA.z), 2);
    
    result = sqrt(xArguement + yArguement + zArguement);
    
    return result;
}

+ (CGFloat)angleBetween:(SCNVector3)vectorA and:(SCNVector3)vectorB {
    /*
     numerator = ( (A.x * B.x) + (A.y * B.y) + (A.z * B.z) )
     
     A = sqrt(  (A.x)^2 + (A.y)^2 + (A.z)^2 )
     B = " "
     
     denominator = A * B
     
     //cos(theta) = numerator/denominator....
     
     */
    CGFloat result = 0;
    
    CGFloat numerator =  (vectorA.x * vectorB.x) + (vectorA.y * vectorB.y) + (vectorA.z * vectorB.z);
    CGFloat denominatorA = sqrt( pow(vectorA.x, 2) + pow(vectorA.y, 2) + pow(vectorA.z, 2));
    CGFloat denominatorB = sqrt( pow(vectorB.x, 2) + pow(vectorB.y, 2) + pow(vectorB.z, 2));
    CGFloat denominator = denominatorA * denominatorB;
    
    CGFloat cosTheta = numerator/denominator;
    result = acos(cosTheta);
    
    return result;
}

+ (SCNVector3)connectorPositionWithVector:(SCNVector3)vectorA and:(SCNVector3)vectorB {
    //we figure half the distance between both vectors
    
    CGFloat x = (vectorA.x + vectorB.x)/2;
    CGFloat y = (vectorA.y + vectorB.y)/2;
    CGFloat z = (vectorA.z + vectorB.z)/2;
    
    return SCNVector3Make(x, y, z);
}
@end
