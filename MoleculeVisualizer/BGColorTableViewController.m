//
//  BGPopover.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 11/21/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//
#import "BGColorTableViewController.h"
@interface BGColorTableViewController()
@property (nonatomic, strong) NSDictionary *colorsDictionary;
@property (nonatomic, strong) NSArray *colorNames;
@end
@implementation BGColorTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if(self = [super initWithStyle:style]) {
        self.colorNames = @[@"Sea Green" , @"Light Gray" , @"Dark Blue" , @"Orange", @"Sky Blue" , @"Stars"];
        self.colorsDictionary = @{@"Sea Green" : [UIColor colorWithRed:131.0f/255.0f green:1.0f blue:179.0/255.0f alpha:1.0f],
                                  @"Light Gray" : [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f],
                                  @"Dark Blue" : [UIColor colorWithRed:33.0f/255.0f green:23.0f/255.0f blue:178.0f/255.0f alpha:1.0f],
                                  @"Orange" : [UIColor colorWithRed:1.0f green:168.0f/255.0f blue:6.0f/255.0f alpha:1],
                                  @"Sky Blue" : [UIColor colorWithRed:90.0f/255.0f green:210.0f/255.0f blue:171.0f alpha:1.0f],
                                  @"Stars" : [UIColor whiteColor]
                                };
        self.clearsSelectionOnViewWillAppear = NO;
        
    }
    return self;
}

- (CGSize)preferredContentSize {
    NSUInteger width = 100;
    NSUInteger height = 33 * self.colorNames.count;
    return CGSizeMake(width, height);
}

#pragma mark - tableView


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.colorNames.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:13];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = cellFont;
    }
    cell.textLabel.text = [self.colorNames objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedColorName = [_colorNames objectAtIndex:indexPath.row];
    NSArray *keys = [self.colorsDictionary allKeys];
    UIColor *selectedColor = [UIColor whiteColor];
    for(NSString *colorName in keys) {
        if([colorName isEqualToString:selectedColorName]) {
            selectedColor = [self.colorsDictionary valueForKey:colorName];
        }
    }
    if(self.colorDelegate) {
        [self.colorDelegate selectedColor:selectedColor];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
