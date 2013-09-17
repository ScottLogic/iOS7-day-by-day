//
//  SCModalViewController.m
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCModalViewController.h"
#import "SCModalTransitioningDelegate.h"

@interface SCModalViewController () {
    id<UIViewControllerTransitioningDelegate> _transitionDelegate;
}

@end

@implementation SCModalViewController

#pragma mark - Construction
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _transitionDelegate = [SCModalTransitioningDelegate new];
    self.transitioningDelegate = _transitionDelegate;
}

- (void)setInteractor:(id<UIViewControllerInteractiveTransitioning>)interactor
{
    if (interactor != _interactor) {
        _interactor = interactor;
        ((SCModalTransitioningDelegate*)_transitionDelegate).interactor = self.interactor;
    }
}


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)handleDismissPressed:(id)sender {
    [self proceedToNextViewController];
}

#pragma mark - SCInteractiveTransitionViewControllerDelegate methods
- (void)proceedToNextViewController
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissModalVC)]) {
        [self.delegate dismissModalVC];
    }
}

@end
