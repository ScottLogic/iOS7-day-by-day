//
//  SCBallBearingView.m
//  NewtonsCradle
//
//  Created by Sam Davies on 02/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCBallBearingView.h"
@import QuartzCore;

@implementation SCBallBearingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = MIN(CGRectGetHeight(frame), CGRectGetWidth(frame)) / 2.0;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2;
    }
    return self;
}


@end
