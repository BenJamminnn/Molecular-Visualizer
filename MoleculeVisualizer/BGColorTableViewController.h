//
//  BGPopover.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 11/21/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerDelegate <NSObject>
@required
- (void)selectedColor:(UIColor *)color;
@end


@interface BGColorTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id <ColorPickerDelegate> colorDelegate;

@end
