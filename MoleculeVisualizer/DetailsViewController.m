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
        
        [self unpackMoleculeDataWithName:@"Chlorine"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *basicInfoDiatomic = @[@"Formula" , @"Name" , @"Atomic Number" , @"Electron Configuration" , @"Block" , @"Group" , @"Period", @"Atomic Mass" ];
        NSArray *thermoInfoDiatomic = @[@"Phase (STP)", @"Melting Point", @"Boiling Point", @"Critical Temperature", @"Critical Pressure", @"Molar Heat of Fusion", @"Molar Heat of Vaporization", @"Specific Heat at STP"];
        NSArray *materialInfoDiatomic = @[@"Density" , @"Molar Volume", @"Thermal Conductivity"];
        NSArray *electromageticInfoDiatomic = @[@"Electrical Type" , @"Resistivity" , @"Electrical Conductivity"];
        
        NSArray *basicInfoComplex = @[@"Formula" , @"Name", @"Mass Fractions" , @"Molar Mass" , @"Phase (STP)" , @"Melting Point" , @"Boiling Point" , @"Density"];
        if(self.isDiatomic) {
            
        } else {
            
        }
    });
}

- (void)unpackMoleculeDataWithName:(NSString *)name {
    NSDictionary *dict = [Molecule dataForMoleculeName:name];    //unpack a dictionary of data values
    
    NSArray *basicInfo = dict[@"Basic Properties"];
    NSArray *thermoInfo = dict[@"Thermo Properties"];
    NSArray *electroInfo = dict[@"Electromagnetic Properties"];
    NSArray *materialInfo = dict[@"Material Properties"];
    
    self.basicInfo = [self superOrSubscriptStrings:basicInfo];
    self.thermoInfo = [self superOrSubscriptStrings:thermoInfo];
    self.electroInfo = [self superOrSubscriptStrings:electroInfo];
    self.materialInfo = [self superOrSubscriptStrings:materialInfo];
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

#warning not set up for inputs like "^-4"

- (NSArray *)superOrSubscriptStrings:(NSArray *)strings {
    if(strings.count == 0) {
        return strings;
    }
    NSMutableArray *newStrings = [NSMutableArray array];
    for(int i = 0; i < strings.count -1; i++) {    //cycle through all strings in the array
        NSString *temp = [strings objectAtIndex:i];
        NSArray *characters = [self convertToArray:temp];
        NSString *revisedString = @"";
        for(int j = 0; j < characters.count - 1; j++) { //cycle through the characters and replace...
            BOOL changed = NO;
            NSString *current = [characters objectAtIndex:j];
            NSString *next = [characters objectAtIndex:j+1];
            if([current isEqualToString:@"|"]) {
                current = [self subSciptOf:next];
                changed = YES;
            } else if([current isEqualToString:@"^"]) {
                current = [self superScriptOf:next];
                changed = YES;
            }
            revisedString = [NSString stringWithFormat:@"%@%@" , revisedString , current];
            if((j + 1) == characters.count - 1 && !changed) {
                revisedString = [NSString stringWithFormat:@"%@%@" , revisedString , next];
                break;
            }
        }
        [newStrings addObject:revisedString];
    }
    
    
    return newStrings;
}

- (NSString *)subSciptOf:(NSString *)inputNumber {
    
    NSString *outp=@"";
    for (int i =0; i<[inputNumber length]; i++) {
        unichar chara=[inputNumber characterAtIndex:i] ;
        switch (chara) {
            case '1':
                outp=[outp stringByAppendingFormat:@"\u2081"];
                break;
            case '2':
                outp=[outp stringByAppendingFormat:@"\u2082"];
                break;
            case '3':
                outp=[outp stringByAppendingFormat:@"\u2083"];
                break;
            case '4':
                outp=[outp stringByAppendingFormat:@"\u2084"];
                break;
            case '5':
                outp=[outp stringByAppendingFormat:@"\u2085"];
                break;
            case '6':
                outp=[outp stringByAppendingFormat:@"\u2086"];
                break;
            case '7':
                outp=[outp stringByAppendingFormat:@"\u2087"];
                break;
            case '8':
                outp=[outp stringByAppendingFormat:@"\u2088"];
                break;
            case '9':
                outp=[outp stringByAppendingFormat:@"\u2089"];
                break;
            case '0':
                outp=[outp stringByAppendingFormat:@"\u2080"];
                break;
            default:
                break;
        }
    }
    return outp;
}

- (NSString *)superScriptOf:(NSString *)inputNumber{
    
    NSString *outp=@"";
    for (int i =0; i<[inputNumber length]; i++) {
        unichar chara=[inputNumber characterAtIndex:i] ;
        switch (chara) {
            case '1':
                outp=[outp stringByAppendingFormat:@"\u00B9"];
                break;
            case '2':
                outp=[outp stringByAppendingFormat:@"\u00B2"];
                break;
            case '3':
                outp=[outp stringByAppendingFormat:@"\u00B3"];
                break;
            case '4':
                outp=[outp stringByAppendingFormat:@"\u2074"];
                break;
            case '5':
                outp=[outp stringByAppendingFormat:@"\u2075"];
                break;
            case '6':
                outp=[outp stringByAppendingFormat:@"\u2076"];
                break;
            case '7':
                outp=[outp stringByAppendingFormat:@"\u2077"];
                break;
            case '8':
                outp=[outp stringByAppendingFormat:@"\u2078"];
                break;
            case '9':
                outp=[outp stringByAppendingFormat:@"\u2079"];
                break;
            case '0':
                outp=[outp stringByAppendingFormat:@"\u2070"];
                break;
            default:
                break;
        }
    }
    return outp;   
}

- (NSArray *)convertToArray:(NSString *)string
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i < string.length; i++) {
        NSString *tmp_str = [string substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:[tmp_str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return arr;
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
