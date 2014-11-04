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


@interface DetailsViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSString *moleculeName;
@end

@implementation DetailsViewController

#pragma mark - lifecycle

- (instancetype)initWithMolecule:(NSString *)molecule {
    if(self = [super init]) {
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self
                                                                    action:@selector(performRevised)];

        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
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






#pragma mark - convienience

- (void)displayImages:(NSArray *)images {
    CGFloat height = 0;
    for(UIImage *img in images) {
        CGRect rect = CGRectMake(0,height , 10, self.view.frame.size.width);
        height += img.size.height;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.image = img;
        imageView.contentMode = UIViewContentModeBottomLeft;
        [self.scrollView addSubview:imageView];
    }
}


- (void)setUpScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 560, 10000)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 70);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.scrollView];
}

@end
