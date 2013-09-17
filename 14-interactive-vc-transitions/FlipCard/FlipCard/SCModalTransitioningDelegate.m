//
//  SCModalTransitioningDelegate.m
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCModalTransitioningDelegate.h"
#import "SCFlipAnimation.h"
#import "SCFlipAnimationInteractor.h"

@implementation SCModalTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    NSLog(@"Providing animator");
    return [[SCFlipAnimation alloc] initForDismissal:NO];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[SCFlipAnimation alloc] initForDismissal:YES];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    NSLog(@"Returning the interactor");
    return self.interactor;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactor;
}

@end
