//
//  SCFlipAnimation.m
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCFlipAnimation.h"

@implementation SCFlipAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Get the respective view controllers
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [UIView transitionFromView:fromVC.view
                        toView:toVC.view
                      duration:[self transitionDuration:transitionContext]
                       options:( self.dismissal ?
                                UIViewAnimationOptionTransitionFlipFromBottom :
                                UIViewAnimationOptionTransitionFlipFromTop )
                    completion:^(BOOL finished) {
                        // Tell everybody that we're done
                        [transitionContext completeTransition:YES];
                    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

@end
