//
//  SCViewController.m
//  FontPalette
//
//  Created by Sam Davies on 05/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set the font on the subheading label
    self.subHeadingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
