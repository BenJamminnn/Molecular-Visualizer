//
//  BGFontSelectorTVC.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 11/25/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "BGFontSelectorTVC.h"

static NSArray *fontOptions = nil;
static NSArray *fontNames = nil;
@interface BGFontSelectorTVC ()

@end

@implementation BGFontSelectorTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontOptions = @[[UIFont fontWithName:@"Helvetica" size:12],
                        [UIFont fontWithName:@"Helvetica" size:14],
                        [UIFont fontWithName:@"Helvetica" size:16]];
        fontNames = @[@"12" , @"14" , @"16"];
    });
}

- (CGSize)preferredContentSize {
#warning doesnt scale
    NSUInteger height = 90;
    return CGSizeMake(100, height);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return fontOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [fontNames objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *selectedFont = [fontOptions objectAtIndex:indexPath.row];
    if(self.fontDelegate) {
        [self.fontDelegate selectedFont:selectedFont];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

@end
