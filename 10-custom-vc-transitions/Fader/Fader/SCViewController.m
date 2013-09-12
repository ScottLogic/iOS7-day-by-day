//
//  SCViewController.m
//  Fader
//
//  Created by Sam Davies on 11/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"
#import "SCNavControllerDelegate.h"

@interface SCViewController () {
    id<UINavigationControllerDelegate> _navDelegate;
}

@end

@implementation SCViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        _navDelegate = [SCNavControllerDelegate new];
        self.delegate = _navDelegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

@end
