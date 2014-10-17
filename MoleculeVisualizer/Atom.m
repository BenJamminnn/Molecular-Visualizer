//
//  Atom.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "Atom.h"

@implementation Atom


+ (SCNGeometry *)carbonAtom {
    SCNGeometry *carbon = [SCNSphere sphereWithRadius:1.7];
    carbon.firstMaterial.diffuse.contents = [UIColor grayColor];
    carbon.firstMaterial.specular.contents = [UIColor whiteColor];
    carbon.name = @"carbon";
    return carbon;
}

+ (SCNGeometry *)hydrogenAtom {
    SCNGeometry *hydrogen = [SCNSphere sphereWithRadius:1.2];
    hydrogen.firstMaterial.diffuse.contents = [UIColor lightGrayColor];
    hydrogen.firstMaterial.specular.contents = [UIColor whiteColor];
    hydrogen.name = @"hydrogen";
    return hydrogen;
}

+ (SCNGeometry *)fluorineAtom {
    SCNGeometry *fluorine = [SCNSphere sphereWithRadius:1.47];
    fluorine.firstMaterial.diffuse.contents = [UIColor yellowColor];
    fluorine.firstMaterial.specular.contents = [UIColor whiteColor];
    fluorine.name = @"fluorine";
    return fluorine;
}

+ (SCNGeometry *)oxygenAtom {
    SCNGeometry *oxygen = [SCNSphere sphereWithRadius:1.52];
    oxygen.firstMaterial.diffuse.contents = [UIColor redColor];
    oxygen.firstMaterial.specular.contents = [UIColor whiteColor];
    oxygen.name = @"oxygen";
    return oxygen;
}

+ (SCNGeometry *)nitrogenAtom {
    SCNGeometry *nitrogen = [SCNSphere sphereWithRadius:1.55];
    nitrogen.firstMaterial.diffuse.contents = [UIColor blueColor];
    nitrogen.firstMaterial.specular.contents = [UIColor whiteColor];
    nitrogen.name = @"nitrogen";
    return nitrogen;
}

+ (SCNGeometry *)chlorineAtom {
    SCNGeometry *chlorine = [SCNSphere sphereWithRadius:1.75];
    chlorine.firstMaterial.diffuse.contents = [UIColor purpleColor];
    chlorine.firstMaterial.specular.contents = [UIColor whiteColor];
    chlorine.name = @"chlorine";
    return chlorine;
}
@end
