//
//  ViewController.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//
@import SceneKit;
#import "ViewController.h"
#import "MoleculeImage.h"
#import "MoleculesTableViewController.h"
#import "DetailsViewController.h"
#import <GLKit/GLKit.h>
static CGFloat currentAngleX = 0;
static CGFloat currentAngleY = 0;
static SCNVector3 startingPosition;
@interface ViewController ()



@property (weak, nonatomic) IBOutlet SCNView *sceneView;
@end

@implementation ViewController {

}

#pragma mark - lifecycle

- (instancetype)initWithMolecule:(SCNNode *)molecule {
    if(self = [super init]) {
        startingPosition = molecule.position;
        self.geometryNode = molecule;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(done)];
    UIBarButtonItem *details = [[UIBarButtonItem alloc]initWithTitle:@"Details" style:UIBarButtonItemStylePlain target:self action:@selector(details)];
    self.navigationItem.rightBarButtonItem = details;
    self.navigationItem.leftBarButtonItem = backButton;
    self.title = self.geometryNode.name;

    [self sceneSetup];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.sceneView stop:nil];
    [self.sceneView play:nil];
}

#pragma mark - UINavigationBar actions and reset button

- (void)details {
    DetailsViewController *vc = [[DetailsViewController alloc]initWithMolecule:self.geometryNode.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)done {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sceneSetup {
    SCNScene *scene = [SCNScene scene];
    
    SCNNode *ambientLight = [SCNNode node];
    ambientLight.light = [SCNLight light];
    ambientLight.light.type = SCNLightTypeDirectional;
    ambientLight.light.color = [UIColor colorWithWhite:0.67 alpha:1.0];
    [scene.rootNode addChildNode:ambientLight];
    
    SCNNode *omniLight = [SCNNode node];
    omniLight.light = [SCNLight light];
    omniLight.light.type = SCNLightTypeOmni;
    omniLight.light.color = [UIColor colorWithWhite:0.75 alpha:1.0];
    [scene.rootNode addChildNode:omniLight];
    
    SCNNode *camNode = [SCNNode node];
    camNode.camera = [SCNCamera camera];
    camNode.name = @"camNode";
    camNode.position = SCNVector3Make(0, 0, 40);
    [scene.rootNode addChildNode:camNode];
    
    scene.rootNode.position = SCNVector3Make(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 0);

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    
    UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    self.sceneView.scene = scene;
    
    //transformation is messing up our double tap, look into RW tut for details
   // [self.sceneView addGestureRecognizer:doubleTap];
    
    
    [self.sceneView addGestureRecognizer:pan];
    [self.sceneView addGestureRecognizer:pinch];


    
    [self.sceneView.scene.rootNode addChildNode:self.geometryNode];
}

//- (void)addResetButton {
//    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [resetButton setBackgroundColor:[UIColor greenColor]];
//    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
//    resetButton.frame = CGRectMake(self.view.frame.size.width/2,self.view.frame.size.height/1.2, 120, 40);
//    [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:resetButton];
//}
//
//- (void)reset {
//#warning implement reset, make the button look nice, mess with UI
//    SCNNode *geoNode = [self.sceneView.scene.rootNode childNodeWithName:self.geometryNode.name recursively:NO];
//    geoNode.position = SCNVector3Make(0, 0, 0);
//}

#pragma mark - gesture recognizers

//TODO
- (void)doubleTap:(UITapGestureRecognizer *)sender {

}

- (void)pinchGesture:(UIPinchGestureRecognizer *)sender {
    CGFloat scale = sender.scale;
    SCNNode *cam = [self.sceneView.scene.rootNode childNodeWithName:@"camNode" recursively:NO];
    CGFloat zValue = cam.position.z - log(scale);
    zValue = (zValue > 90) ? 90 : zValue;
    zValue = (zValue < 10) ? 10 : zValue;
    cam.position = SCNVector3Make(cam.position.x, cam.position.y, zValue);

}

- (void)panGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:sender.view];
    CGFloat newAngleX = (float)(translation.x) * (float)(M_PI)/180.0;
    CGFloat newAngleY = (float)(translation.y) * (float)(M_PI)/180.0;

    newAngleX += currentAngleX;
    newAngleY += currentAngleY;

    SCNMatrix4 yDiff = SCNMatrix4MakeRotation(newAngleY, 1, 0, 0);
    SCNMatrix4 xDiff =  SCNMatrix4MakeRotation(newAngleX, 0, 1, 0);
    SCNMatrix4 sum = SCNMatrix4Mult(yDiff, xDiff);
    
    self.geometryNode.transform = sum;
    if(sender.state == UIGestureRecognizerStateEnded) {
        currentAngleX = newAngleX;
        currentAngleY = newAngleY;
    }
}

#pragma mark - convienience

- (void)zoomCameraToPosition:(int)zPosition {
    //get a ref to the cam
    SCNNode *cam = [self.sceneView.scene.rootNode childNodeWithName:@"camNode" recursively:NO];
    
    //find out if we're zooming in or out, get the amount we have to zoom in/out
    BOOL zoomIn = (cam.position.z > zPosition) ? YES : NO;
    SCNAction *scale = nil;
    if(zoomIn) {
        scale = [SCNAction scaleBy:2.0 duration:0.3];
    } else {
        scale = [SCNAction scaleBy:0.5 duration:0.3];
    }
    [self.geometryNode runAction:scale];
}


@end
