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
    _animationInteractor = [SCFlipAnimationInteractor new];
    _flipAnimation = [SCFlipAnimation new];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Add the gesture recogniser to the window first render time
    if (![self.view.window.gestureRecognizers containsObject:_animationInteractor.gestureRecogniser]) {
        [self.view.window addGestureRecognizer:_animationInteractor.gestureRecogniser];
    }
    // Set the recipeint of the interactor
    _animationInteractor.presentingVC = self;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[SCModalViewController class]]) {
        // Set the delegate
        SCModalViewController *vc = (SCModalViewController *)segue.destinationViewController;
        vc.transitioningDelegate = self;
        vc.interactor = _animationInteractor;
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
    _flipAnimation.dismissal = NO;
    return _flipAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _flipAnimation.dismissal = YES;
    return _flipAnimation;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return _animationInteractor;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return _animationInteractor;
}

@end
