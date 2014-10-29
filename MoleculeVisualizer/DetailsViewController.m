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
#import "WolframAlphaHelper.h"


@interface DetailsViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
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

        self.view.backgroundColor = [UIColor whiteColor];
        self.moleculeName = molecule;
        self.navigationItem.leftBarButtonItem = backButton;
        
        NSString *urlString = [NSString stringWithFormat:@"%@appid=%@&input=%@" , kQueryURL , kAppID , molecule];

        self.moleculeURL = [NSURL URLWithString:urlString];
        [self loadMolecule];
        

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

#pragma mark - querying Wolfram Alpha

- (void)loadMolecule {
    [self setUpScrollView];
    [self activityIndicatorStart];
    [WolframAlphaHelper downloadDataFromURL:self.moleculeURL withCompletionHandler:^(NSData *data) {
        if(data) {
            WolframAlphaHelper *helper = [[WolframAlphaHelper alloc]initWithData:data];
            [self displayImages:helper.images];
        } else {
            NSLog(@"data is nil");
        }
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - convienience

- (void)displayImages:(NSArray *)images {
    CGFloat height = 0;
    for(UIImage *img in images) {
        CGRect rect = CGRectMake(self.view.frame.size.width/2,height , 10, self.view.frame.size.width);
        height += img.size.height;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.image = img;
        imageView.contentMode = UIViewContentModeCenter;
        [self.scrollView addSubview:imageView];
    }
}

- (void)activityIndicatorStart {
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.scrollView addSubview:self.activityIndicator];

    self.activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    [self.activityIndicator startAnimating];
}

- (void)setUpScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 560, 10000)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 70);
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.scrollView];
}

@end
