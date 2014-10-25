//
//  ViewController.m
//  MoleculeVisualizer
//
//  Created by Mac Admin on 10/12/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//
@import SceneKit;
#import "ViewController.h"
#import "Molecule.h"
#import "MoleculesTableViewController.h"
#import "DetailsViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SCNView *sceneView;

@property (nonatomic) CGFloat currentAngle;
@end

@implementation ViewController {
    CGFloat _scaleStart;
    CGFloat _scaleEnd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(done)];
    UIBarButtonItem *details = [[UIBarButtonItem alloc]initWithTitle:@"Details" style:UIBarButtonItemStylePlain target:self action:@selector(details)];
    self.navigationItem.rightBarButtonItem = details;
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationController.navigationBar.topItem.title = self.geometryNode.name;
    
    [self sceneSetup];

}
- (void)details {
    DetailsViewController *vc = [[DetailsViewController alloc]initWithMolecule:self.geometryNode.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)done {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (instancetype)initWithMolecule:(SCNNode *)molecule {
    if(self = [super init]) {
        self.geometryNode = molecule;
    }
    return self;
}


- (void)sceneSetup {
    _scaleStart = 1.0;
    
    SCNScene *scene = [SCNScene scene];
    
    SCNNode *ambientLight = [SCNNode node];
    ambientLight.light = [SCNLight light];
    ambientLight.light.type = SCNLightTypeAmbient;
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
    [self.sceneView addGestureRecognizer:doubleTap];
    [self.sceneView addGestureRecognizer:pan];
    [self.sceneView addGestureRecognizer:pinch];

    [self.sceneView.scene.rootNode addChildNode:self.geometryNode];
}

- (void)doubleTap:(UITapGestureRecognizer *)sender {
    [self.geometryNode runAction:[SCNAction scaleTo:1.5 duration:0.5]];
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
    CGFloat newAngle = (float)(translation.x) * (float)(M_PI)/180.0;
    
    newAngle += self.currentAngle;
    
    self.geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0);
    if(sender.state == UIGestureRecognizerStateEnded) {
        self.currentAngle = newAngle;
    }

}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.sceneView stop:nil];
    [self.sceneView play:nil];
}

@end
