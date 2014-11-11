//
//  DetailsViewController.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/22/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "DetailsViewController.h"
#import "MoleculeImage.h"
#import "ViewController.h"
#import "Molecule.h"

/*
latest plan is to use plists 
  > good for data such as string and numbers

 DATA ON MOLECS
    
 BASICS
   formula 
   name
   structure diagram (not really necessary because of our viewer)
   molar mass
   melting point
   boiling point
   density
   phase at STP
   atomic weight
 
 THERMO PROPERTIES
   specific heat capacity
   molar heat capacity
   specific heat of formation
   molar head of formation
   specific entropy
   molar entropy
   ....
  TODO:
    -pick layout pertinent to above info
 
 
 ORDER of elements:
     BASIC
        >formula
        >atomic number (if diatomic)
        >atomic mass  (if diatomic)
        >electron config (if diatomic)
        >group (if diatomic)
        >period (if diatomic)
    THERMO
        >phase at STP
        >melting point
        >boiling point
        >critical temp
        >critical pressure
        >molar heat of fusion
        >molar heat of vaporization
        >specific heat at STP
        >molar heat of fusion
        
    MATERIAL PROPERTIES (if diatomic)
        >density
        >molar volume
        >sound speed
        >thermal conductivity
    ELECTROMAGNETIC 
        >electrical type
        >resistivity
        >electrical conductivity
        >magnetic type
        >color
        
 
*/


@interface DetailsViewController ()
@property (strong, nonatomic) NSString *moleculeName;
@end

@implementation DetailsViewController

#pragma mark - lifecycle

- (instancetype)initWithMolecule:(NSString *)molecule {
    if(self = [super init]) {
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self
                                                                    action:@selector(back)];
        self.moleculeName = molecule;
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = backButton;
        
        NSDictionary *dict = [Molecule dataForMoleculeName:@"Chlorine"];
        NSLog(@"%@" , dict);
        NSArray *basicInfo = dict[@"Basic Properties"];
        basicInfo = [self superOrSubscriptStrings:basicInfo];
        NSLog(@"%@" , basicInfo);

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

#pragma mark - back button

- (void)back {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main2" bundle:[NSBundle mainBundle]];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Molecule"];
    vc.geometryNode = [MoleculeImage moleculeForName:self.moleculeName];

    
    
    [self.view addSubview:vc.view];
    [vc.view setFrame:self.view.window.frame];
    [vc.view setTransform:CGAffineTransformMakeScale(0.5,0.5)];
    [vc.view setAlpha:1.0];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
                         [vc.view setTransform:CGAffineTransformMakeScale(1.0,1.0)];
                         [vc.view setAlpha:1.0];
                     }
                     completion:^(BOOL finished){
                         [vc.view removeFromSuperview];
                         [self.navigationController pushViewController:vc animated:NO];
                     }];
    
}


#pragma mark - convienience



@end
