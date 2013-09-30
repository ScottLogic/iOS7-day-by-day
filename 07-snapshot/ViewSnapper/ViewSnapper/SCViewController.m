//
//  SCViewController.m
//  ViewSnapper
//
//  Created by Sam Davies on 29/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"
#import "SCRotatingViews.h"

@interface SCViewController () {
    UIView *_complexView;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self createComplexView];
}

- (void)createComplexView
{
    _complexView = [[SCRotatingViews alloc] initWithFrame:self.view.bounds];
    [self.containerView addSubview:_complexView];
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)handleAnimate:(id)sender {
    [UIView animateWithDuration:2.0
                     animations:^{
                         _complexView.bounds = CGRectZero;
                     }
                     completion:^(BOOL finished) {
                         [_complexView removeFromSuperview];
                         [self performSelector:@selector(createComplexView) withObject:nil afterDelay:1];
                     }];
}

- (IBAction)handleSnapshot:(id)sender {
    UIView *snapshotView = [_complexView snapshotViewAfterScreenUpdates:NO];
    [self.containerView addSubview:snapshotView];
    [_complexView removeFromSuperview];
    [UIView animateWithDuration:2.0
                     animations:^{
                         snapshotView.bounds = CGRectZero;
                     }
                     completion:^(BOOL finished) {
                         [snapshotView removeFromSuperview];
                         [self performSelector:@selector(createComplexView) withObject:nil afterDelay:1];
                     }];
}
@end
