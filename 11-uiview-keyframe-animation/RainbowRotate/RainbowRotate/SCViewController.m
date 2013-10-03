/*
 Copyright 2013 Scott Logic Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


#import "SCViewController.h"

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.rainbowSwatch.backgroundColor = [UIColor redColor];
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
    [self enableToolbarItems:NO];
    
    void (^animationBlock)() = ^{
        NSArray *rainbowColors = @[[UIColor orangeColor],
                                   [UIColor yellowColor],
                                   [UIColor greenColor],
                                   [UIColor blueColor],
                                   [UIColor purpleColor],
                                   [UIColor redColor]];
        
        NSUInteger colorCount = [rainbowColors count];
        for(NSUInteger i=0; i<colorCount; i++) {
            [UIView addKeyframeWithRelativeStartTime:i/(CGFloat)colorCount
                                    relativeDuration:1/(CGFloat)colorCount
                                          animations:^{
                                              self.rainbowSwatch.backgroundColor = rainbowColors[i];
                                          }];
        }
    };
    
    [UIView animateKeyframesWithDuration:4.0
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewAnimationOptionCurveLinear
                              animations:animationBlock
                              completion:^(BOOL finished) {
                                  [self enableToolbarItems:YES];
                              }];
}

#pragma mark - Utility methods
- (void)enableToolbarItems:(BOOL)enabled
{
    for (UIBarButtonItem *item in self.toolbar.items) {
        item.enabled = enabled;
    }
}
@end
