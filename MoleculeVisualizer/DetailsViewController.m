//
//  DetailsViewController.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/22/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import "DetailsViewController.h"
#import "Molecule.h"
#import "ViewController.h"
#import "WolframAlpha.h"
#import "WolframAlphaHelper.h"


@interface DetailsViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSString *moleculeName;
@property (strong, nonatomic) NSURL *moleculeURL;   //will use the name of the molecule to query
@end

@implementation DetailsViewController

#pragma mark - lifecycle

- (instancetype)initWithMolecule:(NSString *)molecule {
    if(self = [super init]) {
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self
                                                                    action:@selector(performRevised)];
        self.moleculeName = molecule;
        self.navigationItem.leftBarButtonItem = backButton;
        NSString *urlString = kQuery;
        [urlString stringByAppendingString:molecule];
        [urlString stringByAppendingString:kQueryEnd];
        self.moleculeURL = [NSURL URLWithString:urlString];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMolecule];
}

#pragma mark - back button

- (void)performRevised {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main2" bundle:[NSBundle mainBundle]];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Molecule"];
    vc.geometryNode = [Molecule moleculeForName:self.moleculeName];

    
    
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

#pragma mark - querying Wolfram Alpha

- (void)loadMolecule {
    [WolframAlphaHelper downloadDataFromURL:self.moleculeURL withCompletionHandler:^(NSData *data) {
        if(data) {
            NSLog(@"data: %@" , data);
            
        } else {
            NSLog(@"data is nil");
        }
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
