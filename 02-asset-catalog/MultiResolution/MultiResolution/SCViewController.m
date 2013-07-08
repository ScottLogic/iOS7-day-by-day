//
//  SCViewController.m
//  MultiResolution
//
//  Created by Sam Davies on 05/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGFloat yPosition = 100;
    for(UIImage *image in [self images]) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        iv.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, yPosition);
        yPosition += 100;
        [self.view addSubview:iv];
    }
    // Add the sliced images
    [self createButtonImages];
}

- (void)createButtonImages
{
    UIImage *btnImage = [UIImage imageNamed:@"ButtonSlice"];
    
    // Let's make 2
    UIImageView *iv = [[UIImageView alloc] initWithImage:btnImage];
    iv.bounds = CGRectMake(0, 0, 150, CGRectGetHeight(iv.bounds));
    iv.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, 300);
    [self.view addSubview:iv];
    
    // And a stretched version
    iv = [[UIImageView alloc] initWithImage:btnImage];
    iv.bounds = CGRectMake(0, 0, 300, CGRectGetHeight(iv.bounds));
    iv.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, 350);
    [self.view addSubview:iv];
}

- (NSArray *)images
{
    return @[
             [UIImage imageNamed:@"USA"],
             [UIImage imageNamed:@"Australia"]
             ];
}

@end
