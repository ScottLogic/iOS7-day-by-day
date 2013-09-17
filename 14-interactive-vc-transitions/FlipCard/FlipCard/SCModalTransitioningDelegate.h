//
//  SCModalTransitioningDelegate.h
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCModalTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) id<UIViewControllerInteractiveTransitioning> interactor;

@end
