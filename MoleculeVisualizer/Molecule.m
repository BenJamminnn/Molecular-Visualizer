//
//  MoleculeData.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 11/4/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "Molecule.h"
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

/*
This class will output a dictionary of information based on the chemical input
*/
//TODO migrate left text collection data to here. Details VC getting too large

static NSArray *elements = nil;

@interface Molecule ()

@property (nonatomic, strong, readwrite) NSArray *basicInfo;
@property (nonatomic, strong, readwrite) NSMutableArray *thermoInfo;
@property (nonatomic, strong, readwrite) NSArray *materialInfo;
@property (nonatomic, strong, readwrite) NSArray *electroInfo;
@property (nonatomic, readwrite) BOOL isDiatomic;
@property (nonatomic, strong) NSString *moleculeName;

@property (nonatomic, strong) NSDictionary *leftTextCollection;
@end

@implementation Molecule

- (instancetype)initWithMolecule:(NSString *)name   {
    if(self = [super init]) {
        self.moleculeName = name;
        [self unpackMoleculeData];
        [self setUpLeftTextCollection];
        [self checkThermoInfo];
    }
    return self;
}

- (void)unpackMoleculeData {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.moleculeName ofType:@"plist"];
    NSDictionary *moleculeData = [[NSDictionary alloc]initWithContentsOfFile:path];
    if(!moleculeData) {
        NSLog(@"molecule file does not exist!");
    }
    self.basicInfo = moleculeData[@"Basic Properties"];
    self.thermoInfo = [NSMutableArray arrayWithArray:moleculeData[@"Thermo Properties"]];
    if(self.isDiatomic) {
        self.electroInfo = moleculeData[@"Electromagnetic Properties"];
        self.materialInfo = moleculeData[@"Material Properties"];
    }
}

+ (NSDictionary *)dataForMoleculeName:(NSString *)name {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *moleculeData = [[NSDictionary alloc]initWithContentsOfFile:path];
    if(!moleculeData) {
        NSLog(@"molecule file does not exist!");
        return nil;
    }
    return moleculeData;
}

#pragma mark - datasource

- (NSString *)leftTextForIndexPath:(NSIndexPath *)indexPath {
    NSString *leftText = @"";
    switch (indexPath.section) {
        case 0:
            leftText = [self.leftTextCollection[@"leftBasic"] objectAtIndex:indexPath.row];
            break;
        case 1:
            leftText = [self.leftTextCollection[@"leftThermo"] objectAtIndex:indexPath.row];
            break;
        case 2:
            leftText = [self.leftTextCollection[@"leftMaterial"] objectAtIndex:indexPath.row];
            break;
        case 3:
            leftText = [self.leftTextCollection[@"leftElectro"] objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    return leftText;
}

- (NSString *)rightTextForIndexPath:(NSIndexPath *)indexPath {
    NSString *text = @"";
    switch (indexPath.section) {
        case 0:
            text = [self.basicInfo objectAtIndex:indexPath.row];
            break;
        case 1:
            text = [self.thermoInfo objectAtIndex:indexPath.row];
            break;
        case 2:
            text = [self.electroInfo objectAtIndex:indexPath.row];
            break;
        case 3:
            text = [self.materialInfo objectAtIndex:indexPath.row];
        default:
            break;
    }
    return text;
}

#pragma mark - convienience

- (void)checkThermoInfo {
    for(int i = 0; i < self.thermoInfo.count; i++) {
        NSString *temp = [self.thermoInfo objectAtIndex:i];
        if([self shouldBeEmptyCell:temp]) {
            [self.thermoInfo removeObjectAtIndex:i];
            [self.leftTextCollection[@"leftThermo"] removeObjectAtIndex:i];
        }
    }
}

- (BOOL)shouldBeEmptyCell:(NSString *)cellText {
    return [cellText isEqualToString:@"N/A"];
}

- (NSAttributedString *)superOrSubscriptStringAtIndex:(NSInteger)index super:(BOOL)isSuperScript originalString:(NSString *)originalString {
    UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString
                                                                                         attributes:@{NSFontAttributeName: [fnt fontWithSize:12]}];
    NSNumber *offSet = (isSuperScript) ? @15 : [NSNumber numberWithDouble:-3];
    
    [attributedString setAttributes:@{NSFontAttributeName : [fnt fontWithSize:10]
                                      , NSBaselineOffsetAttributeName : offSet} range:NSMakeRange(index ,1)];
    
    
    
    return attributedString;
}

- (void)setUpLeftTextCollection {
    
    NSString *inputString = @"Specific Heat Capacity cp";
    NSAttributedString *s = [self superOrSubscriptStringAtIndex:inputString.length -1 super:NO originalString:inputString ];
    NSMutableDictionary *leftText = [NSMutableDictionary new];
    if(self.isDiatomic) {
        NSArray *basicInfoDiatomic = @[@"Formula" , @"Name" , @"Atomic Number" , @"Electron Configuration" , @"Block" , @"Group" , @"Period", @"Atomic Mass" ];
        NSMutableArray *thermoInfoDiatomic = [NSMutableArray arrayWithArray:@[@"Phase (STP)", @"Melting Point", @"Boiling Point", @"Critical Temperature", @"Critical Pressure", @"Molar Heat of Fusion", @"Molar Heat of Vaporization", s]];
        NSArray *materialInfoDiatomic = @[@"Density" , @"Molar Volume", @"Thermal Conductivity"];
        NSArray *electromageticInfoDiatomic = @[@"Electrical Type" , @"Resistivity" , @"Electrical Conductivity"];
        leftText = [NSMutableDictionary dictionaryWithDictionary:@{@"leftBasic" : basicInfoDiatomic,
                                                                   @"leftThermo" : thermoInfoDiatomic,
                                                                   @"leftMaterial" : materialInfoDiatomic,
                                                                   @"leftElectro" : electromageticInfoDiatomic
                                                                   }];
    } else {
        NSArray *basicInfoComplex = @[@"Formula" , @"Name", @"Mass Fractions" , @"Molar Mass" , @"Phase (STP)" , @"Melting Point" , @"Boiling Point" , @"Density"];
        NSMutableArray *thermoInfoComplex = [NSMutableArray arrayWithArray: @[ s, @"Specific Heat of formation Δ\u0192H°" , @"Specific Entropy S°" , @"Specific Heat of Vaporization" , @"Specific Heat of Fusion" , @"Critical Temperature"  , @"Critical Pressure"]];
        leftText = [NSMutableDictionary dictionaryWithDictionary:@{@"leftBasic" : basicInfoComplex,
                                                                   @"leftThermo" : thermoInfoComplex
                                                                   }];
    }
    self.leftTextCollection = leftText;
}


#pragma mark - lazy loading

- (BOOL)isDiatomic {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        elements = @[@"Chlorine" , @"Bromine" , @"Fluorine", @"Carbon", @"Phosphorous" , @"Oxygen" , @"Iodine" , @"Hydrogen" , @"Nitrogen", @"Sulfur"];
    });
    for(NSString *str in elements) {
        if([self.moleculeName isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

@end
