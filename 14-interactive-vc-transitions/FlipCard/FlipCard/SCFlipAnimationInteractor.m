//
//  SCFlipAnimationInteractor.m
//  FlipCard
//
//  Created by Sam Davies on 14/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCFlipAnimationInteractor.h"

@interface SCFlipAnimationInteractor ()

@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *gestureRecogniser;

@end


@implementation SCFlipAnimationInteractor

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gestureRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    return self;
}


#pragma mark - Gesture recognition
- (void)handlePan:(UIPanGestureRecognizer *)pgr
{
    NSLog(@"panning");
    CGPoint translation = [pgr translationInView:pgr.view];
    CGFloat percentage  = fabs(translation.y / CGRectGetHeight(pgr.view.bounds));
    switch (pgr.state) {
        case UIGestureRecognizerStateBegan:
            [self.presentingVC proceedToNextViewController];
            break;
            
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:percentage];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            [self finishInteractiveTransition];
            break;
            
        case UIGestureRecognizerStateCancelled:
            [self cancelInteractiveTransition];
            
        default:
            break;
    }
}

@end
