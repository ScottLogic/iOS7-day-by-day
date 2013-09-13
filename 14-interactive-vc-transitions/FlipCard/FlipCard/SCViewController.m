//
//  SCViewController.m
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"
#import "SCModalViewController.h"

@interface SCViewController () <SCModalViewControllerDelegate>

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
