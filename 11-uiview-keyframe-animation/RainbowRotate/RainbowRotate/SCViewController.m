//
//  SCViewController.m
//  RainbowRotate
//
//  Created by Sam Davies on 02/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Toolbar button handlers
- (IBAction)handleRotateCW:(id)sender {
}

- (IBAction)handleRotateCCW:(id)sender {
}

- (IBAction)handleRainbow:(id)sender {
}
@end
