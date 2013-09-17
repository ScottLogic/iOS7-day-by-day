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

@interface SCViewController () <SCModalViewControllerDelegate> {
    SCFlipAnimationInteractor *_animationInteractor;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _animationInteractor = [[SCFlipAnimationInteractor alloc] initWithViewController:self];
    // Add the gesture recogniser
    //[self.view.window addGestureRecognizer:_animationInteractor.gestureRecogniser];
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
        vc.delegate = self;
    }
}

#pragma mark - SCModalViewControllerDelegate
- (void)dismissModalVC
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - SCInteractiveTransitionViewControllerDelegate methods
- (void)proceedToNextViewController
{
    SCModalViewController *vc = [SCModalViewController new];
    vc.delegate = self;
    vc.interactor = _animationInteractor;
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
