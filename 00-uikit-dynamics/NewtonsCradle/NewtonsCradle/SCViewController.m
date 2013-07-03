//
//  SCViewController.m
//  NewtonsCradle
//
//  Created by Sam Davies on 02/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCViewController.h"
#import "SCNewtonsCradleView.h"

@interface SCViewController () {
    SCNewtonsCradleView *_newtonsCradle;
}
@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _newtonsCradle = [[SCNewtonsCradleView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_newtonsCradle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
