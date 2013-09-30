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
#import "SCRotatingViews.h"

@interface SCViewController () {
    SCRotatingViews *_complexView;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self createComplexView];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

/**
 These 2 methods demonstrate how a UIView snapshot can be used in an animation
 to simplify complex views
 */
- (IBAction)handleAnimate:(id)sender {
    [self animateViewAwayAndReset:_complexView];
}

- (IBAction)handleSnapshot:(id)sender {
    UIView *snapshotView = [_complexView snapshotViewAfterScreenUpdates:NO];
    [self.containerView addSubview:snapshotView];
    [_complexView removeFromSuperview];
    [self animateViewAwayAndReset:snapshotView];
}

/**
 These 2 methods compare the difference between allowing screen updates and
 not
 */
- (IBAction)handlePreUpdateSnapshot:(id)sender {
    // Change the views
    [_complexView recolorSubviews:[[UIColor redColor] colorWithAlphaComponent:0.3]];
    // Take a snapshot. Don't wait for changes to be applied
    UIView *snapshotView = [_complexView snapshotViewAfterScreenUpdates:NO];
    [self.containerView addSubview:snapshotView];
    [_complexView removeFromSuperview];
    [self animateViewAwayAndReset:snapshotView];
}

- (IBAction)handlePostUpdateSnapshot:(id)sender {
    // Change the views
    [_complexView recolorSubviews:[[UIColor redColor] colorWithAlphaComponent:0.3]];
    // Take a snapshot. This time, wait for the render changes to be applied
    UIView *snapshotView = [_complexView snapshotViewAfterScreenUpdates:YES];
    [self.containerView addSubview:snapshotView];
    [_complexView removeFromSuperview];
    [self animateViewAwayAndReset:snapshotView];
}

/**
 This method demonstrate how to add an image effect to a UIView snapshot
 */
- (IBAction)handleImageSnapshot:(id)sender {
    // Want to create an image context - the size of complex view and the scale of the device screen
    UIGraphicsBeginImageContextWithOptions(_complexView.bounds.size, NO, 0.0);
    // Render our snapshot into the image context
    [_complexView drawViewHierarchyInRect:_complexView.bounds afterScreenUpdates:NO];
    
    // Grab the image from the context
    UIImage *complexViewImage = UIGraphicsGetImageFromCurrentImageContext();
    // Finish using the context
    UIGraphicsEndImageContext();
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[self applyBlurToImage:complexViewImage]];
    iv.center = _complexView.center;
    [self.containerView addSubview:iv];
    [_complexView removeFromSuperview];
    // Let's wait a bit before we animate away
    [self performSelector:@selector(animateViewAwayAndReset:) withObject:iv afterDelay:1.0];
}

#pragma mark - Utility methods
- (void)createComplexView
{
    _complexView = [[SCRotatingViews alloc] initWithFrame:self.view.bounds];
    [self.containerView addSubview:_complexView];
}

- (void)animateViewAwayAndReset:(UIView *)view
{
    [UIView animateWithDuration:2.0
                     animations:^{
                         view.bounds = CGRectZero;
                     }
                     completion:^(BOOL finished) {
                         [view removeFromSuperview];
                         [self performSelector:@selector(createComplexView)
                                    withObject:nil
                                    afterDelay:1];
                     }];
}

- (UIImage *)applyBlurToImage:(UIImage *)image
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ci_image = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ci_image forKey:kCIInputImageKey];
    [filter setValue:@5 forKey:kCIInputRadiusKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    return [UIImage imageWithCGImage:cgImage scale:image.scale orientation:image.imageOrientation];
}
@end
