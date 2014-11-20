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
@end

@implementation MoleculesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}


#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)     {
        return @"Diatomic and Polyatomic Molecules";
    } else {
        return @"Complex Molecules";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.diatomicMolecules.count;
    } else {
        return self.normalMolecules.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    if(indexPath.section == 0) {
        identifier = [[self.diatomicMolecules objectAtIndex:indexPath.row] name];
    } else {
        identifier = [[self.normalMolecules objectAtIndex:indexPath.row] name];
    }
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = identifier;

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main2" bundle:[NSBundle mainBundle]];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Molecule"];
    if(indexPath.section == 0) {
        vc.geometryNode = [self.diatomicMolecules objectAtIndex:indexPath.row];
    } else {
        vc.geometryNode = [self.normalMolecules objectAtIndex:indexPath.row];
    }
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - lazy loading 

- (NSArray *)normalMolecules   {
    if(!_normalMolecules) {
        MoleculeImage *m = [MoleculeImage new];
        _normalMolecules = m.normalMolecules;
    }
    return _normalMolecules;
}

- (NSArray *)diatomicMolecules {
    if(!_diatomicMolecules) {
        MoleculeImage *m = [MoleculeImage new];
        _diatomicMolecules = m.diatomicMolecules;
    }
    return _diatomicMolecules;
}
@end
