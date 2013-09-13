//
//  SCModalViewController.m
//  FlipCard
//
//  Created by Sam Davies on 13/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCModalViewController.h"

@interface SCModalViewController ()

@end

@implementation SCModalViewController

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
}

- (IBAction)handleDismissPressed:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissModalVC)]) {
        [self.delegate dismissModalVC];
    }
}

@end
