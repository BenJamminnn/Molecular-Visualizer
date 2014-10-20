//
//  MoleculesTableViewController.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "MoleculesTableViewController.h"
#import "ViewController.h"
#import "Molecule.h"

@interface MoleculesTableViewController ()
@property (strong, nonatomic) NSArray *molecules;
@end

@implementation MoleculesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.molecules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [[self.molecules objectAtIndex:indexPath.row] name];
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = identifier;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main2" bundle:[NSBundle mainBundle]];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Molecule"];
    vc.geometryNode = [self.molecules objectAtIndex:indexPath.row];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - lazy loading 

- (NSArray *)molecules   {
    if(!_molecules) {
        Molecule *molec = [Molecule new];
        
        SCNNode *m = [molec methaneMolecule];
        SCNNode *p = [molec ptfeMolecule];
        SCNNode *n = [molec ammoniaMolecule];
        SCNNode *w = [molec waterMolecule];
        SCNNode *h = [molec hydrogenPeroxideMolecule];
        SCNNode *hcl = [molec hydrogenChlorideMolecule];
        SCNNode *sulfuricAcid = [molec sulfuricAcidMolecule];
        SCNNode *nitricAcid = [molec nitricAcidMolecule];
        SCNNode *aceticAcid = [molec aceticAcidMolecule];
        _molecules = @[m, p, n, w, h, hcl, sulfuricAcid , nitricAcid, aceticAcid];
    }
    return _molecules;
}

@end
