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
#import "WYPopoverController.h"
#import "BGFontSelectorTVC.h"
#import <CoreText/CoreText.h>
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
       
 TODO +++++
 CHECK  +didSelectRowAtIndexPath should do nothing
 CHECK  +figure out the reason the 3 is getting cut off. contentViewSize?
 CHECK  +find unicode for Cp and 'f' (getting turned into aliens)
 CHECK  +3D panning
 +fill info for other compounds.
 CHECK +look for N/A for right text values and dont use that cell
 CHECK +do research and order accordingly (hydrocarbons are only carbon and hydrogen)
*/

static UIFont *selectedFont = nil;
static NSArray *elements = nil;

@interface DetailsViewController ()  <UITableViewDataSource , UITableViewDelegate, FontSelectorDelegate, WYPopoverControllerDelegate>
@property (strong, nonatomic) NSString *moleculeName;
@property (strong, nonatomic) Molecule *molecule;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *attributedStringOptions;
@property (nonatomic) BOOL isDiatomic;

@property (nonatomic, strong) WYPopoverController *fontSelectorPopover;
@property (nonatomic, strong) BGFontSelectorTVC *fontSelectorTVC;
@end

@implementation DetailsViewController

#pragma mark - lifecycle

- (instancetype)initWithMolecule:(NSString *)molecule {
    if(self = [super init]) {
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self
                                                                    action:@selector(back)];
        UIBarButtonItem *fontSelector = [[UIBarButtonItem alloc]initWithTitle:@"Font Size" style:UIBarButtonItemStylePlain target:self action:@selector(fontChanged:)];
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = backButton;
        self.navigationItem.rightBarButtonItem = fontSelector;
        self.attributedStringOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:(NSString *)kCTSuperscriptAttributeName];
        self.moleculeName = molecule;
    
        self.molecule = [[Molecule alloc]initWithMolecule:self.moleculeName];

        self.tableView = [self setUpTableView];
        [self.view addSubview:self.tableView];
        self.title = molecule;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedFont = (selectedFont) ? selectedFont : [UIFont fontWithName:@"Helvetica" size:12];
}

#pragma mark - back and font button

- (void)fontChanged:(UIFont *)font {
    if(!_fontSelectorTVC) {
        _fontSelectorTVC = [[BGFontSelectorTVC alloc]initWithStyle:UITableViewStylePlain];
        _fontSelectorTVC.fontDelegate = self;
    }
    if(!_fontSelectorPopover) {
        _fontSelectorPopover = [[WYPopoverController alloc]initWithContentViewController:_fontSelectorTVC];
        _fontSelectorPopover.delegate = self;
        [_fontSelectorPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:WYPopoverArrowDirectionDown animated:YES];

        
    } else {
        [_fontSelectorPopover dismissPopoverAnimated:YES];
        _fontSelectorPopover = nil;
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)popoverController {
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    _fontSelectorPopover.delegate = nil;
    _fontSelectorPopover = nil;
}

- (void)selectedFont:(UIFont *)font {
    selectedFont = font;
    [self.tableView reloadData];
    if (_fontSelectorPopover) {
        [_fontSelectorPopover dismissPopoverAnimated:YES];
        _fontSelectorPopover = nil;
    }
}

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

- (NSAttributedString *)superOrSubscriptStringAtIndex:(NSInteger)index super:(BOOL)isSuperScript originalString:(NSString *)originalString {
    UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString
                                                                                         attributes:@{NSFontAttributeName: [fnt fontWithSize:12]}];
    NSNumber *offSet = (isSuperScript) ? @15 : [NSNumber numberWithDouble:-3];
    
    [attributedString setAttributes:@{NSFontAttributeName : [fnt fontWithSize:10]
                                      , NSBaselineOffsetAttributeName : offSet} range:NSMakeRange(index ,1)];
    
    return attributedString;
}

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

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger baseHeight = 44;
    NSUInteger numberOfRightChars = [[self.molecule rightTextForIndexPath:indexPath] length];
    NSUInteger numberOfLeftChars = [[self.molecule leftTextForIndexPath:indexPath] length];
    NSUInteger sum = numberOfLeftChars + numberOfRightChars;
    if(selectedFont.pointSize == 14) {
        baseHeight += 10;
        if(sum > 25) {
            baseHeight += 20;
            
        }
    } else if(selectedFont.pointSize == 16) {
        if(sum < 30) {
            baseHeight += 10;
        } else if(sum >= 30 && sum < 45) {
            baseHeight += 25;
        } else {
            baseHeight += 90;
        }
    }
    return baseHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Basic Information";
            break;
        case 1:
            return @"Thermodynamic Information";
            break;
        case 2:
            return @"Electromagnetic Information";
            break;
        case 3:
            return @"Material Information";
        default:
            return @"";
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.molecule.isDiatomic) ? 4 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.molecule.basicInfo.count;
            break;
        case 1:
            return self.molecule.thermoInfo.count;
            break;
        case 2:
            return self.molecule.electroInfo.count;
            break;
        case 3:
            return self.molecule.materialInfo.count;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    UIFont *cellFont = selectedFont;
    NSAttributedString *rightString = [[NSAttributedString alloc]initWithString:[self.molecule rightTextForIndexPath:indexPath] attributes:self.attributedStringOptions];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.textLabel.font = cellFont;
    cell.detailTextLabel.font = cellFont;
    cell.detailTextLabel.attributedText = rightString;
    if([[self.molecule leftTextForIndexPath:indexPath] isKindOfClass:[NSAttributedString class]]) {
        cell.textLabel.attributedText = (NSAttributedString *)[self.molecule leftTextForIndexPath:indexPath];
        cell.textLabel.font = cellFont;

    } else {
        cell.textLabel.text = [self.molecule leftTextForIndexPath:indexPath];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
