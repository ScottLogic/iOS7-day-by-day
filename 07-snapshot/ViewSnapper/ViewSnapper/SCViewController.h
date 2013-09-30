//
//  SCViewController.h
//  ViewSnapper
//
//  Created by Sam Davies on 29/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController

- (IBAction)handleAnimate:(id)sender;
- (IBAction)handleSnapshot:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
