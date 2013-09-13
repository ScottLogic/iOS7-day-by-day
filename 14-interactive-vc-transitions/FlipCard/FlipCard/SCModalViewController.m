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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        _transitionDelegate = [SCModalTransitioningDelegate new];
        self.transitioningDelegate = _transitionDelegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)handleDismissPressed:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissModalVC)]) {
        [self.delegate dismissModalVC];
    }
}

@end
