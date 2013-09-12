//
//  SCNavControllerDelegate.m
//  Fader
//
//  Created by Sam Davies on 11/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCNavControllerDelegate.h"
#import "SCFadeTransition.h"

@implementation SCNavControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    return [SCFadeTransition new];
}

@end
