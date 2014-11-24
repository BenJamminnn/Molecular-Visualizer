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
#import "BGColorTableViewController.h"
#import "WYPopoverController.h"
static CGFloat currentAngleX = 0;
static CGFloat currentAngleY = 0;
static UIColor *currentBackgroundColor = nil;

@interface ViewController () <ColorPickerDelegate, WYPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet SCNView *sceneView;
@property (nonatomic, strong) BGColorTableViewController *colorPicker;
@property (nonatomic, strong) WYPopoverController *colorPickerPopover;
@end

@implementation ViewController

#pragma mark - lifecycle

- (instancetype)initWithMolecule:(SCNNode *)molecule {
    if(self = [super init]) {
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

- (IBAction)resetButtonTapped:(id)sender {
    [self.geometryNode removeFromParentNode];
    self.geometryNode = [MoleculeImage moleculeForName:self.geometryNode.name];
    [self.sceneView.scene.rootNode addChildNode:self.geometryNode];
}

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
    ambientLight.light.color = [UIColor colorWithWhite:0.75 alpha:1.0];
    [scene.rootNode addChildNode:ambientLight];
    
    SCNNode *camNode = [SCNNode node];
    camNode.camera = [SCNCamera camera];
    camNode.name = @"camNode";
    camNode.position = SCNVector3Make(0, 0, 40);
    [scene.rootNode addChildNode:camNode];
    
    scene.rootNode.position = SCNVector3Make(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 0);
    
    UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    self.sceneView.scene = scene;

    self.sceneView.backgroundColor = (currentBackgroundColor) ? currentBackgroundColor : [UIColor lightGrayColor];
    
    [self.sceneView addGestureRecognizer:pan];
    [self.sceneView addGestureRecognizer:pinch];

    [self.sceneView.scene.rootNode addChildNode:self.geometryNode];
}

#pragma mark - picking background color

- (IBAction)backgroundColorTapped:(UIButton *)sender {
    if(!_colorPicker) {
        _colorPicker = [[BGColorTableViewController alloc]initWithStyle:UITableViewStylePlain];
        _colorPicker.colorDelegate = self;
    }
    if(!_colorPickerPopover) {
        _colorPickerPopover = [[WYPopoverController alloc]initWithContentViewController:_colorPicker];
        _colorPickerPopover.delegate = self;
        [_colorPickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:WYPopoverArrowDirectionDown animated:YES];
        
    } else {
        [_colorPickerPopover dismissPopoverAnimated:YES];
        _colorPickerPopover = nil;
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)popoverController {
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    _colorPickerPopover.delegate = nil;
    _colorPickerPopover = nil;
}

- (void)selectedColor:(UIColor *)color {
    self.sceneView.backgroundColor = color;
    currentBackgroundColor = color;
    if (_colorPickerPopover) {
        [_colorPickerPopover dismissPopoverAnimated:YES];
        _colorPickerPopover = nil;
    }
}


#pragma mark - gesture recognizers

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

@end
