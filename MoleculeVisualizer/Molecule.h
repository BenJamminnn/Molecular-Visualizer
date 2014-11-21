//
//  MoleculeData.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 11/4/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Molecule : NSObject

@property (nonatomic, strong, readonly) NSArray *basicInfo;
@property (nonatomic, strong, readonly) NSMutableArray *thermoInfo;
@property (nonatomic, strong, readonly) NSArray *materialInfo;
@property (nonatomic, strong, readonly) NSArray *electroInfo;
@property (nonatomic, readonly) BOOL isDiatomic;

- (instancetype)initWithMolecule:(NSString *)name;

- (NSString *)leftTextForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)rightTextForIndexPath:(NSIndexPath *)indexPath;

+ (NSDictionary *)dataForMoleculeName:(NSString *)name;

@end
