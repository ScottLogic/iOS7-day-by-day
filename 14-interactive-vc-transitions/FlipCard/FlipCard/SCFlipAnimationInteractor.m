//
//  SCFlipAnimationInteractor.m
//  FlipCard
//
//  Created by Sam Davies on 14/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCFlipAnimationInteractor.h"

@interface SCFlipAnimationInteractor () {
    UIViewController<SCInteractiveTransitionViewControllerDelegate>* _vc;
}

@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *gestureRecogniser;

@end




@implementation SCFlipAnimationInteractor

- (instancetype)initWithViewController:(UIViewController<SCInteractiveTransitionViewControllerDelegate> *)vc
{
    self = [super init];
    if(self) {
        _vc = vc;
        self.gestureRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    return self;
}

#pragma mark - Gesture recognition
- (void)handlePan:(UIPanGestureRecognizer *)pgr
{
    CGPoint translation = [pgr translationInView:pgr.view];
    CGFloat percentage  = fabs(translation.y / CGRectGetHeight(pgr.view.bounds));
    switch (pgr.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Begin");
            [_vc proceedToNextViewController];
            break;
            
        case UIGestureRecognizerStateChanged: {
            NSLog(@"%f", percentage);
            [self updateInteractiveTransition:percentage];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            [self finishInteractiveTransition];
            [pgr.view removeGestureRecognizer:pgr];
            break;
            
        case UIGestureRecognizerStateCancelled:
            [self cancelInteractiveTransition];
            
        default:
            break;
    }
}

@end
