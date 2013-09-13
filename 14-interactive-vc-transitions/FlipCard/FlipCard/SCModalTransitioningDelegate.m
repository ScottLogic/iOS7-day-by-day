//
//  SCModalTransitioningDelegate.m
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCModalTransitioningDelegate.h"
#import "SCFlipAnimation.h"

@implementation SCModalTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[SCFlipAnimation alloc] initForDismissal:NO];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[SCFlipAnimation alloc] initForDismissal:YES];
}

@end
