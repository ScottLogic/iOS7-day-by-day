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


#import "SCFlipAnimation.h"

@implementation SCFlipAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Get the respective view controllers
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Get the views
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    // Add the toView to the container
    [containerView addSubview:toView];
    
    // Set the frames
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    toView.frame = initialFrame;
    
    // Start building the transform - 3D so need perspective
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/CGRectGetHeight(initialFrame);
    containerView.layer.sublayerTransform = transform;
    
    CGFloat direction = self.dismissal ? -1.0 : 1.0;
    
    toView.layer.transform = CATransform3DMakeRotation(-direction * M_PI_2, 1, 0, 0);
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                   delay:0.0
                                 options:0
                              animations:^{
                                  // First half is rotating in
            [UIView addKeyframeWithRelativeStartTime:0.0
                                    relativeDuration:0.5
                                          animations:^{
        fromView.layer.transform = CATransform3DMakeRotation(direction * M_PI_2, 1, 0, 0);
                                          }];
            [UIView addKeyframeWithRelativeStartTime:0.5
                                    relativeDuration:0.5
                                          animations:^{
        toView.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
                                          }];
                              } completion:^(BOOL finished) {
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

@end
