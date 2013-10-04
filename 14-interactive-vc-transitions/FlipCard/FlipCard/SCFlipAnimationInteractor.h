//
//  SCFlipAnimationInteractor.h
//  FlipCard
//
//  Created by Sam Davies on 14/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCInteractiveTransitionViewControllerDelegate.h"

@interface SCFlipAnimationInteractor : UIPercentDrivenInteractiveTransition

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *gestureRecogniser;
@property (nonatomic, weak) UIViewController<SCInteractiveTransitionViewControllerDelegate> *presentingVC;

@end
