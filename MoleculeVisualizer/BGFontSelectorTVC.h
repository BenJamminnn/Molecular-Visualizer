//
//  BGFontSelectorTVC.h
//  MoleculeVisualizer
//
//  Created by Mac Admin on 11/25/14.
//  Copyright (c) 2014 Ben Gabay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FontSelectorDelegate <NSObject>
@required
- (void)selectedFont:(UIFont *)font;
@end

@interface BGFontSelectorTVC : UITableViewController

@property (strong, nonatomic) id <FontSelectorDelegate> fontDelegate;

@end
