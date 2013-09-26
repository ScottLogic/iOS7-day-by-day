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

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.dimTintSwitch.on = NO;
    
    // Load the image
    UIImage *shinobiHead = [UIImage imageNamed:@"shinobihead"];
    // Set the rendering mode to respect tint color
    shinobiHead = [shinobiHead imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    // And set to the image view
    self.tintedImageView.image = shinobiHead;
    self.tintedImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Action Handlers
- (IBAction)changeColorHandler:(id)sender {
    // Generate a random color
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.view.tintColor = color;
    [self updateProgressViewTint];
}

- (IBAction)dimTintHandler:(id)sender {
    if(self.dimTintSwitch.isOn) {
        self.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    } else {
        self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    }
    [self updateProgressViewTint];
    
}

- (void)updateProgressViewTint
{
    self.progressView.progressTintColor = self.view.tintColor;
}
@end
