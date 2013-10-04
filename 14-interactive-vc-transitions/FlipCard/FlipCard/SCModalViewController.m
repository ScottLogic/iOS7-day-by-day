//
//  SCModalViewController.m
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCModalViewController.h"

@implementation SCModalViewController

#pragma mark - View Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    // Reset which view controller should be the receipient of the
    // interactor's transition
    self.interactor.presentingVC = self;
}

- (IBAction)handleDismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)proceedToNextViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
