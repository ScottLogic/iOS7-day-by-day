//
//  SCViewController.m
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"
#import "SCModalViewController.h"
#import "SCFlipAnimationInteractor.h"
#import "SCFlipAnimation.h"
#import "SCInteractiveTransitionViewControllerDelegate.h"

@interface SCViewController () <SCInteractiveTransitionViewControllerDelegate, UIViewControllerTransitioningDelegate> {
    SCFlipAnimationInteractor *_animationInteractor;
    SCFlipAnimation *_flipAnimation;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _animationInteractor = [[SCFlipAnimationInteractor alloc] initWithViewController:self];
    _flipAnimation = [[SCFlipAnimation alloc] initForDismissal:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view.window addGestureRecognizer:_animationInteractor.gestureRecogniser];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[SCModalViewController class]]) {
        // Set the delegate
        SCModalViewController *vc = (SCModalViewController *)segue.destinationViewController;
        vc.transitioningDelegate = self;
    }
}


#pragma mark - SCInteractiveTransitionViewControllerDelegate methods
- (void)proceedToNextViewController
{
    [self performSegueWithIdentifier:@"displayModal" sender:self];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return _flipAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return _animationInteractor;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

@end
