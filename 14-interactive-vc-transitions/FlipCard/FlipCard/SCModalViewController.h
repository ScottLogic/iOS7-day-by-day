//
//  SCModalViewController.h
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCInteractiveTransitionViewControllerDelegate.h"
#import "SCFlipAnimationInteractor.h"

@interface SCModalViewController : UIViewController <SCInteractiveTransitionViewControllerDelegate>

- (IBAction)handleDismissPressed:(id)sender;

@property (nonatomic, weak) SCFlipAnimationInteractor *interactor;

@end
