//
//  SCFirstViewController.m
//  Fader
//
//  Created by Sam Davies on 11/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCFirstViewController.h"

@interface SCFirstViewController ()

@end

@implementation SCFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"First VC";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
