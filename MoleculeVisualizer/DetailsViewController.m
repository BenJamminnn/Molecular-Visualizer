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

static NSArray *leftTextValues = nil;

@interface DetailsViewController ()  <UITableViewDataSource , UITableViewDelegate>
@property (strong, nonatomic) NSString *moleculeName;
@property (strong, nonatomic) NSArray *basicInfo;
@property (strong, nonatomic) NSArray *thermoInfo;
@property (strong, nonatomic) NSArray *electroInfo;
@property (strong, nonatomic) NSArray *materialInfo;
@property (strong, nonatomic) NSDictionary *leftTextCollection;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic) BOOL isDiatomic;
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
        
        [self unpackMoleculeDataWithName:@"Ammonia"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLeftText];
    self.tableView = [self setUpTableView];
    [self.view addSubview:self.tableView];
    
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

- (void)setUpLeftText {
    NSArray *basicInfoDiatomic = @[@"Formula" , @"Name" , @"Atomic Number" , @"Electron Configuration" , @"Block" , @"Group" , @"Period", @"Atomic Mass" ];
    NSArray *thermoInfoDiatomic = @[@"Phase (STP)", @"Melting Point", @"Boiling Point", @"Critical Temperature", @"Critical Pressure", @"Molar Heat of Fusion", @"Molar Heat of Vaporization", @"Specific Heat at STP"];
    NSArray *materialInfoDiatomic = @[@"Density" , @"Molar Volume", @"Thermal Conductivity"];
    NSArray *electromageticInfoDiatomic = @[@"Electrical Type" , @"Resistivity" , @"Electrical Conductivity"];

        //COMPLEX MOLECULES
    NSArray *basicInfoComplex = @[@"Formula" , @"Name", @"Mass Fractions" , @"Molar Mass" , @"Phase (STP)" , @"Melting Point" , @"Boiling Point" , @"Density"];
    NSArray *thermoInfoComplex = @[@"Specific Heat Capacity c𝓅" , @"Specific Heat of formation Δ𝑓H°" , @"Specific Entropy S°" , @"Specific Heat of Vaporization" , @"Specific Heat of Combustion" , @"Specific Heat of Fusion" , @"Critical Temperature"  , @"Critical Pressure"];
    
    
    NSArray *complexInfo = @[basicInfoComplex , thermoInfoComplex];
    if(self.isDiatomic) {
        self.leftTextCollection = @{@"Basic" : basicInfoDiatomic ,
                                    @"Thermo" : thermoInfoDiatomic,
                                    @"Electro" : electromageticInfoDiatomic,
                                    @"Material" : materialInfoDiatomic
                                    };
    } else {
        self.leftTextCollection = @{@"Basic" : basicInfoComplex ,
                                    @"Thermo" : thermoInfoComplex
                                    };
    }
}

- (void)unpackMoleculeDataWithName:(NSString *)name {
    NSDictionary *dict = [Molecule dataForMoleculeName:name];    //unpack a dictionary of data values
    self.basicInfo = dict[@"Basic Properties"];
    self.thermoInfo = dict[@"Thermo Properties"];
    self.electroInfo = dict[@"Electromagnetic Properties"];
    self.materialInfo = dict[@"Material Properties"];
}

- (BOOL)isDiatomic {
    NSArray *elements = @[@"Chlorine" , @"Bromine" , @"Fluorine", @"Carbon", @"Phosphorous" , @"Oxygen" , @"Iodine" , @"Hydrogen" , @"Nitrogen" , @"Ozone" , @"Sulfur"];
    for(NSString *str in elements) {
        if([self.moleculeName isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

- (UITableView *)setUpTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = 45;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    return tableView;
}

- (NSString *)rightTextForIndexPath:(NSIndexPath *)indexPath {
    NSString *text = @"";
    switch (indexPath.section) {
        case 0:
            text = [self.basicInfo objectAtIndex:indexPath.row];
            break;
        case 1:
            text = [self.electroInfo objectAtIndex:indexPath.row];
            break;
        case 2:
            text = [self.thermoInfo objectAtIndex:indexPath.row];
            break;
        case 3:
            text = [self.materialInfo objectAtIndex:indexPath.row];
        default:
            break;
    }
    return text;
}

- (NSString *)leftTextForIndexPath:(NSIndexPath *)indexPath {
    NSString *leftText = @"";
    switch (indexPath.section) {
        case 0:
            leftText = [self.leftTextCollection[@"Basic"] objectAtIndex:indexPath.row];
            break;
        case 1:
            leftText = [self.leftTextCollection[@"Electro"] objectAtIndex:indexPath.row];
            break;
        case 2:
            leftText = [self.leftTextCollection[@"Thermo"] objectAtIndex:indexPath.row];
            break;
        case 3:
            leftText = [self.leftTextCollection[@"Material"] objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    return leftText;
}


#pragma mark - tableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Basic Information";
            break;
        case 1:
            return @"Electromagnetic Information";
            break;
        case 2:
            return @"Thermodynamic Information";
            break;
        case 3:
            return @"Material Information";
        default:
            return @"";
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.basicInfo.count;
            break;
        case 1:
            return self.electroInfo.count;
            break;
        case 2:
            return self.thermoInfo.count;
            break;
        case 3:
            return self.materialInfo.count;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.detailTextLabel.text = [self rightTextForIndexPath:indexPath];
    cell.textLabel.text = [self leftTextForIndexPath:indexPath];
    return cell;
}



@end
