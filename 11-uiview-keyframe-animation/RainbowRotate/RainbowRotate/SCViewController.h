//
//  SCViewController.h
//  RainbowRotate
//
//  Created by Sam Davies on 02/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *rotatingHead;
@property (weak, nonatomic) IBOutlet UIView *rainbowSwatch;

- (IBAction)handleRotateCW:(id)sender;
- (IBAction)handleRotateCCW:(id)sender;
- (IBAction)handleRainbow:(id)sender;

@end
