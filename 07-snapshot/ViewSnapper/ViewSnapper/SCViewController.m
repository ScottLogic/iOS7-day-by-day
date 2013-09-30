//
//  SCViewController.m
//  ViewSnapper
//
//  Created by Sam Davies on 29/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

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

- (void)createComplexView
{
    _complexView = [[SCRotatingViews alloc] initWithFrame:self.view.bounds];
    [self.containerView addSubview:_complexView];
    
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
}

#pragma mark - Utility methods
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
@end
