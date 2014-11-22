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
    hydrogen.firstMaterial.diffuse.contents = [UIColor colorWithWhite:0.2 alpha:1];
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

+ (SCNGeometry *)sulfurAtom {
    SCNGeometry *sulfur = [SCNSphere sphereWithRadius:1.80];
    sulfur.firstMaterial.diffuse.contents = [UIColor yellowColor];
    sulfur.firstMaterial.specular.contents = [UIColor whiteColor];
    sulfur.name = @"Sulfur";
    return sulfur;
}

+ (SCNGeometry *)iodineAtom {
    SCNGeometry *iodine = [SCNSphere sphereWithRadius:1.98];
    iodine.firstMaterial.diffuse.contents = [UIColor cyanColor];
    iodine.firstMaterial.specular.contents = [UIColor whiteColor];
    iodine.name = @"Iodine-Atom";
    return iodine;
}

+ (SCNGeometry *)bromineAtom {
    SCNGeometry *bromine = [SCNSphere sphereWithRadius:1.9];
    bromine.firstMaterial.specular.contents = [UIColor whiteColor];
    bromine.firstMaterial.diffuse.contents = [UIColor magentaColor];
    bromine.name = @"bromine-atom";
    return bromine;
}

+ (SCNGeometry *)arsenicAtom {
    SCNGeometry *arsenic = [SCNSphere sphereWithRadius:2.05];
    arsenic.firstMaterial.diffuse.contents = [UIColor colorWithRed:156/255 green:204/255 blue:83/255 alpha:1.0];
    arsenic.firstMaterial.specular.contents = [UIColor whiteColor];
    arsenic.name = @"Arsenic-atom";
    return arsenic;
}

+ (SCNGeometry *)phosphorousAtom {
    SCNGeometry *p = [SCNSphere sphereWithRadius:1.95];
    p.firstMaterial.specular.contents = [UIColor whiteColor];
    p.firstMaterial.diffuse.contents = [UIColor brownColor];
    p.name = @"Phosphorous-Atom";
    return p;
}
@end
