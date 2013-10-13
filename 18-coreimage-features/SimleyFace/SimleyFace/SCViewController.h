//
//  SCViewController.h
//  SimleyFace
//
//  Created by Sam Davies on 13/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *retakeButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

- (IBAction)handleRestart:(id)sender;

@end
