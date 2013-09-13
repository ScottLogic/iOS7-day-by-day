//
//  SCModalViewController.h
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCModalViewControllerDelegate <NSObject>

@required
- (void)dismissModalVC;

@end


@interface SCModalViewController : UIViewController

@property (nonatomic, weak) id<SCModalViewControllerDelegate> delegate;

@end
