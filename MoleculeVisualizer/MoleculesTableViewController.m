//
//  MoleculesTableViewController.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "MoleculesTableViewController.h"
#import "ViewController.h"
#import "MoleculeImage.h"

@interface MoleculesTableViewController ()
@property (strong, nonatomic) NSArray *normalMolecules;
@property (strong, nonatomic) NSArray *diatomicMolecules;
@property (strong, nonatomic) NSArray *acidMolecules;
@property (strong, nonatomic) NSArray *hydrocarbonMolecules;

@end

@implementation MoleculesTableViewController {
    MoleculeImage *_m;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [self setUpTableView];
    self.title = @"Molecules";
    _m = [MoleculeImage new];
}

#pragma mark - convienience

- (UITableView *)setUpTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = 44;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    return tableView;
}

#pragma mark - Table view data source

- (NSString *)nameForRowAtIndexPath:(NSIndexPath *)path {
    NSString *name = @"";
    switch (path.section) {
        case 0:
            return [[self.normalMolecules objectAtIndex:path.row]name];
            break;
        case 1:
            return [[self.acidMolecules objectAtIndex:path.row]name];
            break;
        case 2:
            return [[self.hydrocarbonMolecules objectAtIndex:path.row]name];
            break;
        case 3:
            return [[self.diatomicMolecules objectAtIndex:path.row]name];
            break;
        default:
            NSLog(@"Something wrong nameForRowAtIndexPath, path: %@" , path);
            break;
    }
    return name;
}

- (SCNNode *)nodeForIndexPath:(NSIndexPath *)path {
    SCNNode *selectedMolecule;
    switch (path.section) {
        case 0:
            return [self.normalMolecules objectAtIndex:path.row];
            break;
        case 1:
            return [self.acidMolecules objectAtIndex:path.row];
            break;
        case 2:
            return [self.hydrocarbonMolecules objectAtIndex:path.row];
            break;
        case 3:
            return [self.diatomicMolecules objectAtIndex:path.row];
            break;
        default:
            NSLog(@"Something wrong nodeForRowAtIndexPath, path: %@" , path);
            break;
    }
    return selectedMolecule;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerName = @"";
    switch (section) {
        case 0:
            headerName = @"Other";
            break;
        case 1:
            headerName = @"Acids";
            break;
        case 2:
            headerName = @"Hydrocarbons";
            break;
        case 3:
            headerName = @"Diatomic and Polyatomic";
            break;
        default:
            break;
    }
    return headerName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.diatomicMolecules.count;
            break;
        case 1:
            return self.acidMolecules.count;
            break;
        case 2:
            return self.hydrocarbonMolecules.count;
            break;
        case 3:
            return self.normalMolecules.count;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self nameForRowAtIndexPath:indexPath];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:16];

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.font = cellFont;
    cell.textLabel.text = identifier;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main2" bundle:[NSBundle mainBundle]];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Molecule"];
    vc.geometryNode = [self nodeForIndexPath:indexPath];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - lazy loading

- (NSArray *)normalMolecules   {
    if(!_normalMolecules) {
        _normalMolecules = _m.otherMolecules;
    }
    return _normalMolecules;
}

- (NSArray *)diatomicMolecules {
    if(!_diatomicMolecules) {
        _diatomicMolecules = _m.diatomicMolecules;
    }
    return _diatomicMolecules;
}

- (NSArray *)hydrocarbonMolecules {
    if(!_hydrocarbonMolecules) {
        _hydrocarbonMolecules = _m.hydrocarbonMolecules;
    }
    return _hydrocarbonMolecules;
}

- (NSArray *)acidMolecules {
    if(!_acidMolecules) {
        _acidMolecules = _m.acidMolecules;
    }
    return _acidMolecules;
}


@end