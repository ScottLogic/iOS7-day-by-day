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
    [self enableToolbarItems:NO];
    [UIView animateKeyframesWithDuration:2.0
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:1/3.0
                                                                animations:^{
                                                                    self.rotatingHead.transform = CGAffineTransformMakeRotation(2.0 * M_PI / 3.0);
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:1/3.0
                                                          relativeDuration:1/3.0
                                                                animations:^{
                                                                    self.rotatingHead.transform = CGAffineTransformMakeRotation(4.0 * M_PI / 3.0);
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:2/3.0
                                                          relativeDuration:1/3.0
                                                                animations:^{
                                                                    self.rotatingHead.transform = CGAffineTransformMakeRotation(0);
                                                                }];
                                  
                              }
                              completion:^(BOOL finished) {
                                  [self enableToolbarItems:YES];
                              }];
}

- (IBAction)handleRotateCCW:(id)sender {
    [self enableToolbarItems:NO];
    [UIView animateKeyframesWithDuration:2.0
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:1/3.0
                                                                animations:^{
                                                                    self.rotatingHead.transform = CGAffineTransformMakeRotation(4.0 * M_PI / 3.0);
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:1/3.0
                                                          relativeDuration:1/3.0
                                                                animations:^{
                                                                    self.rotatingHead.transform = CGAffineTransformMakeRotation(2.0 * M_PI / 3.0);
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:2/3.0
                                                          relativeDuration:1/3.0
                                                                animations:^{
                                                                    self.rotatingHead.transform = CGAffineTransformMakeRotation(0);
                                                                }];
                                  
                              }
                              completion:^(BOOL finished) {
                                  [self enableToolbarItems:YES];
                              }];
}

- (IBAction)handleRainbow:(id)sender {
}

#pragma mark - Utility methods
- (void)enableToolbarItems:(BOOL)enabled
{
    for (UIBarButtonItem *item in self.toolbar.items) {
        item.enabled = enabled;
    }
}
@end
