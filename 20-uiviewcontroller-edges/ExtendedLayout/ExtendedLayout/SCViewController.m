//
//  SCViewController.m
//  ExtendedLayout
//
//  Created by Sam Davies on 15/10/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    box.backgroundColor = [UIColor blueColor];
    [self.view addSubview:box];
}


@end
